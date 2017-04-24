global class Batch_BounceStatus implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    
   
     global Database.QueryLocator start(Database.BatchableContext bc) {
        Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
       // String Response = 'Response collection' ;
        
       // String query = 'Select Id,Name,(Select id,Campaign_ID__c From Campaign_Members1__r) from Campaign Where Child_Campaign_Status__c =:Response';
         //system.debug('+++++++ Query'+query);
        return Database.getQueryLocator([Select Id,Name,(Select id,Campaign_ID__c From Campaign_Members1__r Where Status__c !='Bounced') from Campaign Where Child_Campaign_Status__c = 'Response collection']);
         
       // return Database.getQueryLocator(query); 
    }
    
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
       
       
       
       String MainString ;
       
     List<Attachment> campMemList = new List<Attachment>();

        For(Campaign cam : Scope){
        
        system.debug('+++++++++++'+Scope);
        
        for(Campaign_Member__c camp : cam.Campaign_Members1__r){
         system.debug('+++++++++++'+cam.Campaign_Members1__r);
         
          
          String Recordmain= camp.id+','+camp.Campaign_ID__c+'\n';
           MainString = MainString +Recordmain ;
          
          }
          
         
         
        // string MainString  = string.join(recordString,'/n');
         
          
          system.debug('+++++++++++'+MainString );
            if(!String.isBlank(MainString)){
            
      
       Attachment attach = new Attachment();
    attach.Body = Blob.valueOf(MainString);
    attach.Name = 'test.csv';
    //attach.ContentType = 'csv';
    attach.IsPrivate = false;
    attach.ParentId = cam.Id;
    //attach.ParentId = 

    
      
     campMemList.add(attach);
      
      }
    
    }
    insert campMemList;
    }
    
    
    global void finish(Database.BatchableContext bc) {
      
      
    
    
    }
      
       
       global void execute(SchedulableContext ctx) {
       
       Batch_BounceStatus batchSch = New Batch_BounceStatus();
       
        Database.executeBatch(new Batch_BounceStatus());
        
    }
}