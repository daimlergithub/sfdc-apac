/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    01.18.2017
Company             :    NTT Data,Inc.
Usage               :    Campaign Execution via External Scheduler and Notification
                          
JIRA NO             :    SFDCJP-1013                                               
************************************************************************************/

global class Batch_CreateCampaignNotification implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    global List<Campaign> notiMailerList = new List<Campaign>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String strExecutionTypeEmail = 'Email';
        String strExecutionTypeDM = 'DM';
        String strChildCampStatus= 'Segmentation';
        Date today = Date.Today();
        String query = 'Select Id, OwnerId, Owner.Name from Campaign Where (Execution_Type__c =: strExecutionTypeEmail OR Execution_Type__c =: strExecutionTypeDM) AND Child_Campaign_Status__c =: strChildCampStatus AND Execution_Start_Date__c =: today';
        
        return Database.getQueryLocator(query);
    
    }
    
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
        
        List<Task> tskList = new List<Task>();
        List<Campaign> campList = new List<Campaign>();

        for(Campaign camp : scope){
            notiMailerList.add(camp); 
        }     
    }
    
    global void finish(Database.BatchableContext bc) {
       
       EmailTemplate templateId = [Select id from EmailTemplate where name = 'test email'];
       List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
       
       for(Campaign camp : notiMailerList){
       String emailBodyStr = 'Hi '+camp.Owner.Name+',<br /><br/>Please find the below detail link for the campaign record:<br/>';
           emailBodyStr = emailBodyStr +''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+camp.Id+'<br/><br />Thanks!!<br/>Salesforce';
           System.debug('---emailBodyStr ----'+emailBodyStr);
           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
           msg.SetsaveAsActivity(false); 
           msg.setTemplateId(templateId.Id);
           msg.subject = 'Campaign Notification';
           msg.setHTMLBody(emailBodyStr);
           msg.setTargetObjectId(camp.OwnerId);  
           msgList.add(msg);
       }
       Messaging.sendEmail(msgList);    
    }
    
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_CreateCampaignNotification());
    }
}