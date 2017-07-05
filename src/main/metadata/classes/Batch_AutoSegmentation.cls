/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to get autosegmentation on retail campaign 
                         Business Conditions :
                          * Create Camapign Members Based on Segmentation Criteria SOQL ,                      
JIRA NO             :    SFDCJP-1609                                              
************************************************************************************/
global class Batch_AutoSegmentation implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    global List<Retail_Campaign__c> retNotiList = new List<Retail_Campaign__c>();
    global Set<Id> camMem = new Set<Id>();
    global Set<String> errorList = new Set<String>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        Date today = Date.Today();
        //String query = 'Select Id,Name, OwnerId,Segmentation_Criteria__r.Criteria__c, Owner.Name from Retail_Campaign__c Where Auto_Segmentation__c = true AND Segmentation_Date__c =: today AND IsAutoSegmentationExecuted__c = false';
        String query = 'Select Id,Name, OwnerId, Owner.Name from Retail_Campaign__c Where Auto_Segmentation__c = true AND Segmentation_Date__c =: today AND IsAutoSegmentationExecuted__c = false';
         system.debug('+++++++ Query'+query);
        return Database.getQueryLocator(query);
         
    }
    
    
    global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
       String sid;
        String accQuery;
        List<Retail_Campaign__c> campList = new List<Retail_Campaign__c>();
        List<Retail_Campaign__c> campError = new List<Retail_Campaign__c>();
        List<Campaign_Member__c> campMemList = new List<Campaign_Member__c>();

        for(Retail_Campaign__c camp : scope){
             //sid=camp.Segmentation_Criteria__r.Criteria__c;
        } 
        system.debug('+++++++++sid'+sid);    
        accQuery = sid;
        List<Account> accList = new List<Account>();
        try{    
        accList = Database.query(accQuery);
        
        
           
           
        
        system.debug('+++++++++++accList'+accList);
        if(accList.size()>0 && !accList.isEmpty()){
            
            for(Retail_Campaign__c reCamp : scope){
                
                 retNotiList.add(reCamp); 
            
            
            for(Account acc : accList){
                
                Campaign_Member__c camMem = New Campaign_Member__c ();
                //camMem.Name = acc.Name;
                camMem.Contact_Id__c = acc.Id;
                camMem.Retail_Campaign_Id__c = reCamp.Id;
                campMemList.add(camMem);
                
                
                }
                
               reCamp.IsAutoSegmentationExecuted__c = true;
                campList.add(reCamp);
                
            }
            }}catch( QueryException e ) {
           System.debug( e.getMessage() );
           for(Retail_Campaign__c caError : scope){
             caError.hasError__c = true;
             campError.add(caError);
        } 
        
            
        }
            
        Database.Update(campError,false);
           
           Database.Update(campList,false);  
           system.debug('+++++++campMemList'+campMemList);
           Database.SaveResult[] srList =  Database.insert(campMemList,false);
           System.debug('+++++++++++'+srList);
           for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        
        System.debug('Successfully inserted: ' + sr.getId());
        
        camMem.add(sr.getId());
        
    }
    else {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields this error: ' + err.getFields());
            errorList.add(err.getMessage());
        }
    }
    }
    List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
      
      List<Campaign_Member__c> camMemList = [Select id ,Name From campaign_Member__c Where Id =: camMem];
      for(Retail_Campaign__c campMail : retNotiList){
         String mainName = campMail.Name;
         system.debug('++++++++++'+mainName );
         system.debug('++++++++++'+campMail.Name );
         system.debug('++++++++++'+retNotiList);
       String emailBodyStr = '';
           emailBodyStr = emailBodyStr +'Following records are sucessfully inserted';
           emailBodyStr = emailBodyStr + camMemList.size()  ;
           emailBodyStr = emailBodyStr + 'Retail Campaign Name is '+ mainName    ;
           System.debug('---emailBodyStr ----'+emailBodyStr);
           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
           msg.SetsaveAsActivity(false); 
           //msg.setTemplateId(templateId.Id);
           msg.subject = 'Campaign Notification';
           msg.setHTMLBody(emailBodyStr);
           msg.setTargetObjectId(campMail.OwnerId);  
           msgList.add(msg);
       }
       Messaging.sendEmail(msgList);    
       camMem.clear();
    }
    
    
    
    
    global void finish(Database.BatchableContext bc) {
      
      
    
    
    }
      
       
       global void execute(SchedulableContext ctx) {
       
       Batch_AutoSegmentation batchSch = New Batch_AutoSegmentation();
       String sch='0 1 * * * ?';
        Database.executeBatch(new Batch_AutoSegmentation(),1);
        System.schedule('Batch Schedule', sch , batchSch);
    }
}