global class Batch_insertDealer implements Database.Batchable<sObject>{
    global final String campaignId;
    global final Set<Id> InsertMap;
    
    global Batch_insertDealer(Set<Id> updateMap,String camid){
    
        InsertMap = updateMap;
        campaignId = camid;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id From Account Where Id =: InsertMap ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
    
    List<Participating_Dealer__c> parDealer = New List<Participating_Dealer__c>();
    for(Account pdMain : scope){
        Participating_Dealer__c pd = New Participating_Dealer__c();
        pd.Campaign__c = campaignId;
        pd.Dealer__c = pdMain.Id;
        
          
        
        parDealer.add(pd);
        }
        
        Database.insert(parDealer,false);
        
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}