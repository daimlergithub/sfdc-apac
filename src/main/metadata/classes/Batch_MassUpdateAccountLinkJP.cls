global class Batch_MassUpdateAccountLinkJP implements Database.Batchable<sObject>, Database.Stateful{
    global final List<Account_Link__c> AccountLinkList = new List<Account_Link__c>();
    global final List<Account_Link__c> AccountLinkListToUpdate = new List<Account_Link__c>();
    global final Map<Id,Account_Link__c>AccMap;
    global final Map<Id,Account_Link__c>VehMap;
    global final List<Id>AccountLinkIdList = new List<Id>();
    global final user usr;
    global Batch_MassUpdateAccountLinkJP(List<Account_Link__c> MergeAccountlinklist,Map<Id,Account_Link__c>AccountMap,Map<Id,Account_Link__c>VehicleMap,User usr){
    
        //AccountLinkList = MergeAccountlinklist;
        System.debug('alist'+MergeAccountlinklist);
         System.debug('amap>>'+AccountMap);
         System.debug('vmap>>'+VehicleMap);
         System.debug('user>>'+usr);
        for(Account_Link__c al:MergeAccountlinklist)
        { 
            System.debug('aid>>>'+al.id);
            AccountLinkIdList.add(al.id);
        }
        AccMap = AccountMap;
        VehMap = VehicleMap;
        this.usr = usr;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         
        return Database.getQueryLocator([SELECT Id, fromrole__c,torole__c FROM Account_Link__c WHERE Id IN: AccountLinkIdList ]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
    
       System.debug('amap>>>>>>'+AccMap);
       System.debug('user>>'+usr);
        for(Account_Link__c a:scope)
        {
            if(AccMap.containsKey(a.id))
            {
                a.Retail_Sales_Consultant__c=usr.id;
                AccountLinkListToUpdate.add(a);
            }
            else if(VehMap.containsKey(a.id))
            {
                a.Service_Advisor__c=usr.id;
                AccountLinkListToUpdate.add(a);
            }                       
        }
       
        if(!AccountLinkListToUpdate.isEmpty()){
            update AccountLinkListToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}