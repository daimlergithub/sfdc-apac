/***********************************************************************************
Created By          :    Srinivas Pendli    
Created Date        :    07.10.2016
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to send email notification to the Dealer outlet salesmanagers when lead is
                         approved with business conditions.
                         Business Conditions :
                          * It Should not assigned to any one (Assigned Service Advisor == Null).
                          * lead should approved.
                          * Leads 'Last Nonassign Notification Date' is the past date.
                          * Send notifications to sales Managers based on the lead record type.
                          * This will execute daily once. 
JIRA NO             :    SFDCJP-547                                              

MODIFICATION DETAILS:

1. Modified By      :    Srinivas Pendli
   Modifide Date    :    07.10.2016
************************************************************************************/

global class EmailnotificationLeadsnotassigned implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    Date pastdatdate = system.today().addDays(-1);    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,CAC_Lead_Status__c,Last_Nonassign_Notification_Date__c,
                    Assigned_Dealer__r.Dealer_Sales_Manager_Email__c,Service_Advisor__c FROM Lead__c where (Last_Nonassign_Notification_Date__c =: pastdatdate OR Last_Nonassign_Notification_Date__c = null)
                    and Service_Advisor__c = NULL and CAC_Lead_Status__c = 'Allocated']);            
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        Id leadId ;
        Set<String> accountIds = new Set<String>();
        Map<Id,Lead__c> updateLeadMap = new Map<id,Lead__c>();
        for(Lead__c led : Scope){
             leadId = led.id;
            accountIds.add(led.Assigned_Dealer__r.Dealer_Sales_Manager_Email__c);
            led.Last_Nonassign_Notification_Date__c = system.today();
            updateLeadMap.put(led.id,led);
        }
        List<User> userRecords = [Select id,Name,email from User where IsActive = True and email IN : accountIds];
        sendMail(userRecords,leadId );
        if(updateLeadMap.size() > 0){
            update updateLeadMap.values();
        }
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(List<User> userRecords,Id leadId){        
        List<Id> userIds = new List<Id>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'Lead assignment to dealer outlet for unassigned' limit 1];
        for(User u : userRecords){
            userIds.add(u.id);
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.saveAsActivity = false;
        mail.setTargetObjectId(u.Id);
        mail.setTemplateId(e.Id);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
        mail.setWhatId(leadId);
        //Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
        mails.add(mail); 
        }
        Messaging.sendEmail(mails);
        
    }
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new EmailnotificationLeadsnotassigned());
    }
}