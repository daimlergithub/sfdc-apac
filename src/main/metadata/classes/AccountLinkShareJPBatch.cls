/***********************************************************************************
Created By          :    venky    
Created Date        :    13.07.2018
Company             :    NTT Data,Inc.
Usage               :    Adding Account link sharing for missing records.
Business Conditions :
*   
JIRA NO             :      

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class AccountLinkShareJPBatch implements Database.Batchable<sObject> ,Database.stateful {
    
    
    public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String dupnumber=label.Campaign_Member_Lead;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        
        return Database.getQueryLocator([Select id,MD__c ,Retail_Delete_Flag__c,fromRole__c,toRole__c,RecordtypeID from  Account_Link__c where Md__c='JP' and (recordtypeID=:AccountLink_RetailPersonRecordTypeId OR recordtypeID=:AccountLink_RetailCompanyRecordTypeId) and fromRole__c !=null and toRole__c!=null and createddate=TODAY ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
        List<Account_Link__c>  listalk=new List<Account_Link__c>();
        List<Account_Link__Share>  listalkshare=new List<Account_Link__Share>();
        Set<Id> AlkId=new Set<Id>();
        Set<Id> DealerId=new Set<Id>();
        Set<Id> Accid=new Set<Id>();
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        List<Group> groupList=new  List<Group>();
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> dealerAccList=new List<Account>();
        List<Account_Link__Share> InsertSharingRecord = new List<Account_Link__Share>();
        
        for(Account_Link__c alk:scope)
        {
            if(alk.Md__c =='JP' && alk.fromRole__c !=null && alk.toRole__c !=null && alk.MD__c =='JP' && (alk.RecordTypeId==AccountLink_RetailPersonRecordTypeId || alk.RecordTypeId==AccountLink_RetailCompanyRecordTypeId ))
            {
                AlkId.add(alk.id);
                DealerId.add(alk.fromRole__c);
                Accid.add(alk.toRole__c);
            }
        }
        if(AlkId !=null)
        {
            listalkshare=[SELECT Id,ParentId,RowCause,UserOrGroupId FROM Account_Link__Share where parentid=:AlkId and RowCause='Manual'];
        }
        if(listalkshare !=null && listalkshare.size()>=0)
        {
            
        }
        if(listalkshare ==null || listalkshare.size() ==0)
        {
            dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: DealerId AND RecordType.DeveloperName = 'Dealer'];
             
            if(dealerAccList !=null)
            {
                
                for(Account accRec : dealerAccList) {
                    if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                        gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                        accIdSet.add(accRec.Id);
                    }
                }
                
                 List<Account> similarGCCodeDealerAccountList = [select Id,Name, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordtypeId =: Dealer_RecordTypeId];
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
                    
                }
                if(groupList !=null && (listalkshare ==null || listalkshare.size() ==0))
                {
                    for(Group usr :groupList)
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
        
        if(InsertSharingRecord.size() >0)
        {
            Database.insert(InsertSharingRecord,false);
        }
     }
     global void finish(Database.BatchableContext BC){
     }
    
    

}