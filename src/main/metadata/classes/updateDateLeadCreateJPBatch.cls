global class updateDateLeadCreateJPBatch implements Database.batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Id userId =[select id from user where username like '%integration.inf@infosys.com%' limit 1].Id;        
        String query='select id,Assigned_Date_Time__c,Assigned_Dealer__c,createdDate from Lead__c where createdDate =LAST_N_DAYS:1 AND createdById=\''+userId +'\' AND MD__c=\'JP\' AND (Dealer_Lead_Status__c !=\'Lost\' OR Dealer_Lead_Status__c !=\'Purchased(Only Non BDC)\') AND Assigned_Dealer__r.Dealer_Group__c=\'Yanase\'';
        system.debug('hello'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){        
        List<Lead__c> leadList= (List<Lead__c>)scope;
        List<Lead__c> ldList = new List<Lead__c>();
        for(Lead__c l:leadList){
          if(l.Assigned_Dealer__c!= null || l.Assigned_Dealer__c!='')
          {
              l.Assigned_Date_Time__c = l.createdDate;
              ldList.add(l);
          }
        }
      update ldList;      
}

global void finish(Database.BatchableContext BC){
    System.debug('Records Updated');
}


}