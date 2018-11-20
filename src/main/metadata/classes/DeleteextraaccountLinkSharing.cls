/***********************************************************************************
Created By          :    venky    
Created Date        :    28.09.2018
Company             :    NTT Data,Inc.
Usage               :   Delete Sharing for extra dealers, In case if any account link record is shared to different GC code code dealer,delete the sharing for those dealers.
Business Conditions :
*   
JIRA NO             :      

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

 global class DeleteextraaccountLinkSharing implements Database.Batchable<sObject> ,Database.stateful {
     public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    Global Set<Id> ExtraShare = new Set<Id>();  
     Global  List<Account_Link__Share>  DeleteAlkShare=new List<Account_Link__Share>();
     global Database.QueryLocator start(Database.BatchableContext BC){
        String dupnumber=label.Alk_Last_Modified_Date;
         String lastmodalias=label.Alk_Last_Modified_By_Alias;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
         return Database.getQueryLocator([Select id,Market__c,Md__c ,Retail_Delete_Flag__c,fromRole__c,toRole__c,RecordtypeID from  Account_Link__c where (Market__c='JP' or Md__c='JP') and (recordtypeID=:AccountLink_RetailPersonRecordTypeId OR recordtypeID=:AccountLink_RetailCompanyRecordTypeId) and fromRole__c !=null and toRole__c!=null and (Lastmodifieddate >=:lastmodifedDupNum or LastModifiedBy.alias=:lastmodalias)]); 
    }
     
      global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
          
           List<Account_Link__c>  listalk=new List<Account_Link__c>();
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
        
        Set<Id> AlkId=new Set<Id>();
        Set<Id> DealerId=new Set<Id>();
        Set<Id> Accid=new Set<Id>();
          
            for(Account_Link__c alk:scope)
        {
            if((alk.Market__c =='JP' || alk.Md__c=='JP') && alk.fromRole__c !=null && alk.toRole__c !=null &&  (alk.RecordTypeId==AccountLink_RetailPersonRecordTypeId || alk.RecordTypeId==AccountLink_RetailCompanyRecordTypeId ))
            {
                AlkId.add(alk.id);
                DealerId.add(alk.fromRole__c);
                Accid.add(alk.toRole__c);
            }
        }
            if(AlkId !=null)
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
          System.debug('-------------->>>>>>>>>>>>>>..'+existinggroupid);
           if(DealerId !=null)
         {
             dealerAccList = [select Id,Market__c,Md__c, Dealer_GC_Code__c from Account where (Market__c='JP' or md__c='JP') and Id =: DealerId AND RecordType.DeveloperName = 'Dealer'];
         
          System.debug('-------------->>>>>>>>>>>>>>..'+dealerAccList );    
            if(dealerAccList !=null)
            {
                
                for(Account accRec : dealerAccList) {
                    if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                        gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                        accIdSet.add(accRec.Id);
                    }
                }         
         }
             
               List<Account> similarGCCodeDealerAccountList = [select Id,Market__c,Md__c,Name, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
         
                                                                    AND RecordtypeId =: Dealer_RecordTypeId and (Market__c='JP' or md__c='JP') ];
          System.debug('-------------->>>>>>>>>>>>>>..'+similarGCCodeDealerAccountList );    
             if(similarGCCodeDealerAccountList !=null)
                {
                     for(Account dealerRec : similarGCCodeDealerAccountList) 
                     {
                          dealerAccNameSet.add(dealerRec.Name);
                    accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
                     }
                   
                    if(dealerAccNameSet !=null)
                    {
                          groupList=[select Id, Name, Type from Group where Name IN: dealerAccNameSet];
                    }
                    if(groupList !=null)
                    {
                        for(Group gp:groupList)
                        {
                            GcCodeGroupid.put(gp.id,gp);
                        }
                        
                       System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+existinggroupid.Keyset());
                       System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+existinggroupid.values());
                        System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+GcCodeGroupid);
                        System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+GcCodeGroupid.keyset());
                        
                  /*  for(ID alkshare:existinggroupid.Keyset())
                   // for(Account_Link__Share  alkshare: existinggroupid.values()) 
                    {
                        if(!GcCodeGroupid.containskey(alkshare))
                        {
                        //System.debug('Inside puku');
                            ExtraShare.add(alkshare);
                        }
                    }*/
                    
                    for(Account_Link__Share  alkshare: existinggroupid.values())
                    {
                    if(!GcCodeGroupid.containskey(alkshare.UserOrGroupId))
                        {
                         ExtraShare.add(alkshare.id);
                        }
                    
                    }
                        
                    }
                    
                    
                }
         }
         System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+ExtraShare);
         
         if(ExtraShare !=null )
                    {
                        DeleteAlkShare=[SELECT Id,ParentId,RowCause,UserOrGroupId FROM Account_Link__Share where id=:ExtraShare and RowCause='Manual'];
                      if(DeleteAlkShare !=null)
                      {
                          Database.Delete(DeleteAlkShare,false);
                      }
                    }
          
      }
     global void finish(Database.BatchableContext BC){
         
         
     }

}