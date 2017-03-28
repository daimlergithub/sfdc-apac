global class Batch_BounceStatus implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    
    global Set<Id> camAccount = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String newStatus = 'Bounced' ;
        
        String query = 'Select Id,Name,Status__c,Contact_Id__c, Campaign_ID__r.Execution_Start_Date__c from Campaign_Member__c Where Status__c =: newStatus  ';
         system.debug('+++++++ Query'+query);
        return Database.getQueryLocator(query);
         
    }
    
    
    global void execute(Database.BatchableContext bc, List<Campaign_Member__c> scope) {
       
       List<Account> accMainList = New List<Account>(); 
     List<Campaign_Member__c> campMemList = new List<Campaign_Member__c>();

        for(Campaign_Member__c camp : scope){
             
               camAccount.add(camp.Contact_Id__c);
        
        } 
        
        List<Account> addList = [Select Email__c,Email_Status__c,Mobile_Status__c,Email_Last_Modified_Date__c,Mobile__c,SMS_Last_Modified_Date__c,(Select id ,Hardcopy_Last_Modified_Date__c From Addresses__r ) From Account Where Id =: camAccount];
        
        For(Account acc : addList ){
            
             for(Campaign_Member__c campCheck : scope){
            
            if(acc.Email_Last_Modified_Date__c < campCheck.Campaign_ID__r.Execution_Start_Date__c){
                acc.Email_Status__c = 'Invalid';
                
            }
            if(acc.SMS_Last_Modified_Date__c < campCheck.Campaign_ID__r.Execution_Start_Date__c){
              acc.Mobile_Status__c = 'Invalid';
             
            }
               For(Address__c add : acc.Addresses__r ){
                 
                // if(add.Hardcopy_Last_Modified_Date__c  < campCheck.Campaign_ID__r.Execution_Start_Date__c ){
                     
                    // acc.Primary_Address_Validity__c = 'Invalid';
                 //}               
                   
                   
               }
            
            
             }  
             
            accMainList.add(acc); 
            
        }
           
           
        update accMainList;
        
    }
    
    
    
    
    global void finish(Database.BatchableContext bc) {
      
      
    
    
    }
      
       
       global void execute(SchedulableContext ctx) {
       
       Batch_BounceStatus batchSch = New Batch_BounceStatus();
       String sch='0 1 * * * ?';
        Database.executeBatch(new Batch_BounceStatus());
        System.schedule('Batch Schedule', sch , batchSch);
    }
}