/***********************************************************************************
Created By          :    venky    
Created Date        :    28.09.2018
Company             :    NTT Data,Inc.
Usage               :    Adding Account link sharing for missing records with similar Gc code.
Business Conditions :
*   
JIRA NO             :      

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class MissingAccountLinkShare implements Database.Batchable<sObject> ,Database.stateful {
    
    public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        String dupnumber=label.Alk_Last_Modified_Date;
         String lastmodalias=label.Alk_Last_Modified_By_Alias;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        // (Market__c='JP' or Md__c='JP') and (recordtypeID=:AccountLink_RetailPersonRecordTypeId OR recordtypeID=:AccountLink_RetailCompanyRecordTypeId) and fromRole__c !=null and toRole__c!=null and (Lastmodifieddate<=:lastmodifedDupNum or LastModifiedBy.alias=:lastmodalias)
        return Database.getQueryLocator([Select id,Market__c,Md__c ,Retail_Delete_Flag__c,fromRole__c,toRole__c,RecordtypeID from  Account_Link__c where (Market__c='JP' or Md__c='JP') and (recordtypeID=:AccountLink_RetailPersonRecordTypeId OR recordtypeID=:AccountLink_RetailCompanyRecordTypeId) and fromRole__c !=null and toRole__c!=null and (Lastmodifieddate >=:lastmodifedDupNum or LastModifiedBy.alias=:lastmodalias)]);
    }
    
     global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
        List<Account_Link__c>  listalk=new List<Account_Link__c>();
         List<Account_Link__c> missinglistalk=new List<Account_Link__c>();
        List<Account_Link__Share>  listalkshare=new List<Account_Link__Share>();
        List<Account> dealerAccList=new List<Account>();
        Map<Id,Account_Link__Share> existinggroupid=new Map<Id,Account_Link__Share>();
         Map<Id,Group> GcCodeGroupid=new Map<Id,Group>();
          Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        List<Group> groupList=new  List<Group>();
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        List<Account_Link__Share> InsertSharingRecord = new List<Account_Link__Share>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> Missingpublicgroup = new Set<Id>();   
        Set<Id> AlkId=new Set<Id>();
        Set<Id> DealerId=new Set<Id>();
        Set<Id> GCcodeDealerId=new Set<Id>();
        Set<Id> Accid=new Set<Id>();
         
         for(Account_Link__c alk:scope)
        {
            if(alk.Market__c =='JP' && alk.fromRole__c !=null && alk.toRole__c !=null &&  (alk.RecordTypeId==AccountLink_RetailPersonRecordTypeId || alk.RecordTypeId==AccountLink_RetailCompanyRecordTypeId ))
            {
                AlkId.add(alk.id);
                DealerId.add(alk.fromRole__c);
                Accid.add(alk.toRole__c);
            }
        }
         System.debug('-------->>>>> Account Link id'+alkid);
         System.debug('-------->>>>> Account Link id'+DealerId);
         System.debug('-------->>>>> Account Link id'+Accid);
          if(AlkId !=null && DealerId !=null && Accid!=null)
        {
            listalkshare=[SELECT Id,ParentId,RowCause,UserOrGroupId FROM Account_Link__Share where parentid=:AlkId and RowCause='Manual'];
            
            if(listalkshare !=null && listalkshare.size()>0)
            {
                for(Account_Link__Share alkshare:listalkshare)
                {
                    existinggroupid.put(alkshare.UserOrGroupId,alkshare);
                }
            }
        }
         
         if(DealerId !=null)
         {
             dealerAccList = [select Id, Dealer_GC_Code__c,Market__C,Md__c from Account where Market__c='JP' and  Id =: DealerId AND RecordType.DeveloperName = 'Dealer'];
         System.debug('-------->>>>> Account LinkdealerAccList  id'+dealerAccList );    
            if(dealerAccList !=null)
            {
                
                for(Account accRec : dealerAccList) {
                    if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                   
                        gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                        accIdSet.add(accRec.Id);
                    }
                }         
            }
              System.debug('-------->>>>> Account gcCodeToDealerAccIdMapid'+gcCodeToDealerAccIdMap);    
               List<Account> similarGCCodeDealerAccountList = [select Id,Name, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordtypeId =: Dealer_RecordTypeId];
                    System.debug('-------->>>>> Account LinkdealerAccList  id'+similarGCCodeDealerAccountList );    
             if(similarGCCodeDealerAccountList !=null)
                {
                     for(Account dealerRec : similarGCCodeDealerAccountList) 
                     {
                      GCcodeDealerId.add(dealerRec.id);
                          dealerAccNameSet.add(dealerRec.Name);
                    accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
                     }
                    System.debug('-------->>>>> Account dealerAccNameSet'+dealerAccNameSet );    
                    if(dealerAccNameSet !=null)
                    {
                          groupList=[select Id, Name, Type from Group where Name IN: dealerAccNameSet];
                    }
                     System.debug('-------->>>>> Account dealerAccNameSet'+groupList );    
                    if(groupList !=null)
                    {
                        for(Group gp:groupList)
                        {
                            GcCodeGroupid.put(gp.id,gp);
                        }
                        
                        for(group g: GcCodeGroupid.values())
                        {
                            if(!existinggroupid.containsKey(g.Id))
                            {
                                Missingpublicgroup.add(g.id);
                            }
                        }
                        List<group> missinggroupnames=new List<group>();
                        missinggroupnames=[select Id, Name, Type from Group where id=:Missingpublicgroup];
                     System.debug('-------->>>>> Account missinggroupnames'+missinggroupnames);        
                        if(missinggroupnames !=null)
                        {
                       // missinglistalk=[Select id,Market__c,Md__c,Retail_Delete_Flag__c,fromRole__c,toRole__c  from Account_Link__c where fromRole__c=:GCcodeDealerId and toRole__c=:Accid and market__c='JP'  ];
                         // System.debug('-------->>>>> Account missinglistalk'+missinglistalk);        
                             for(Group usr :missinggroupnames)
                    {
                        for(Account_Link__c alkrec:scope)
                        {
                            if(alkrec.Retail_Delete_Flag__c == false)
                            {
                           Account_Link__Share accountLinkShare = new Account_Link__Share();
                            accountLinkShare.AccessLevel = 'Edit';
                            accountLinkShare.UserOrGroupId = usr.Id;
                            accountLinkShare.ParentId = alkrec.id;
                            accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                                InsertSharingRecord.add(accountLinkShare);
                            }
                        }
                        
                    }                            
                        }
                    }
                    
                }
         }
         if(InsertSharingRecord !=null)
         {
         Database.insert(InsertSharingRecord,false);
         }
         
     }
    
    global void finish(Database.BatchableContext BC){
     }
 

}