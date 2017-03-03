/***********************************************************************************
Created By          :    Srinivas Pendli    
Created Date        :    05.10.2016
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to send email notification to the Dealer outlet salesmanagers when lead is
                         approved with business conditions.
                         Business Conditions :
                          * It should assign to dealer outlet.
                          * lead should approved.
                          * Lead Assignment Notification should false.
                          * Send notifications to sales Managers based on the lead record type.
                          * This will execute daily 3 times. 
JIRA NO             :    SFDCJP-546                                                

MODIFICATION DETAILS:

1. Modified By      :    Srinivas Pendli
   Modifide Date    :    05.10.2016
************************************************************************************/
global class EmailnotificationLeads implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,Assigned_Dealer__c,CAC_Lead_Status__c,Lead_Assignment_Notification_Done__c,
                    Assigned_Dealer__r.Dealer_Sales_Manager_Email__c FROM Lead__c where Lead_Assignment_Notification_Done__c =: false
                    and Assigned_Dealer__c !=: NULL and CAC_Lead_Status__c = 'Allocated']);            
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        
        
        Set<String> accountIds = new Set<String>();
        Id leadId ;
		Map<Id,Lead__c> updateLeadMap = new Map<id,Lead__c>();
        for(Lead__c led : Scope){
            accountIds.add(led.Assigned_Dealer__r.Dealer_Sales_Manager_Email__c);
            leadId = led.id;
			led.Lead_Assignment_Notification_Done__c = true;
            updateLeadMap.put(led.id,led);
        }
        List<User> userRecords = [Select id,Name,email from User where IsActive = True and email IN : accountIds];
        sendMail(userRecords,leadId );
		if(updateLeadMap.size() > 0){
            update updateLeadMap.values();
        }
        
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(List<User> userRecords,Id leadId  ){        
        List<Id> userIds = new List<Id>();
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME = : 'Lead assignment to dealer outlet' limit 1];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(User u : userRecords){
            userIds.add(u.id);
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.saveAsActivity = false;
        mail.setTargetObjectId(u.id);
        mail.setTemplateId(e.Id);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
        mail.setWhatId(leadId);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        mails.add(mail); 
        }
        Messaging.sendEmail(mails);
    }
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
   
   
   
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new EmailnotificationLeads());
    }
}