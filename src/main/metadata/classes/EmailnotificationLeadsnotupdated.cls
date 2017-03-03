/***********************************************************************************
Created By          :    Srinivas Pendli    
Created Date        :    07.10.2016
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to send email notification to the Dealer outlet salesmanagers when lead is
                         approved with business conditions.
                         Business Conditions :
                          * It should assign to dealer outlet.
                          * lead should approved.
                          * Lead Assignment Notification should false.
                          * Send notifications to sales Managers based on the lead record type.
                          * This will execute daily 3 times. 
JIRA NO             :    SFDCJP-548                                              

MODIFICATION DETAILS:

1. Modified By      :    Srinivas Pendli
   Modifide Date    :    07.10.2016
************************************************************************************/
global class EmailnotificationLeadsnotupdated implements Database.Batchable<sObject>,Schedulable{
    //START METHOD
     Date pastdatdate = system.today().addDays(-30);   
    global Database.QueryLocator start(Database.BatchableContext BC){
          
                    
                    
                    
             return Database.getQueryLocator([SELECT Id,Name,Assigned_Dealer__c,CAC_Lead_Status__c,Lead_Assignment_Notification_Done__c,
                    Assigned_Dealer__r.Dealer_Sales_Manager_Email__c FROM Lead__c where ( LastModifiedDate <=:pastdatdate AND RecordType.Name IN('Sales Leads') AND (Dealer_Lead_Status__c != 'Purchased(Only Non BDC)' AND Dealer_Lead_Status__c !='Lost') AND (Lead_Latest_Phase__c != 'Vehicle Registration' AND 
                       Lead_Latest_Phase__c != 'Invoiced')) OR ( RecordType.Name IN('Aftersales Leads') AND Appointment_DateTime__c !=null)  ]);          
    }
    
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        Id leadId ;
        Set<String> accountIds = new Set<String>();
        for(Lead__c led : Scope){
         leadId = led.id;
            accountIds.add(led.Assigned_Dealer__r.Dealer_Sales_Manager_Email__c);
        }
        List<User> userRecords = [Select id,Name,email from User where IsActive = True and email IN : accountIds];
        sendMail(userRecords,leadId );
        
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(List<User> userRecords,Id leadId){        
        List<Id> userIds = new List<Id>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'Lead assignment to dealer outlet' limit 1];
        for(User u : userRecords){
            userIds.add(u.id);
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.saveAsActivity = false;
        mail.setTargetObjectId(u.Id);
        mail.setTemplateId(e.Id);
        mail.setUseSignature(false);
        mail.setWhatId(leadId);
        mail.setSaveAsActivity(false);
       // Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
       mails.add(mail); 
        }
        Messaging.sendEmail(mails);
        
    }
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new EmailnotificationLeadsnotupdated());
    }
}