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
Bug JIRA NO         :    SFDCJP-2758

MODIFICATION DETAILS:

1. Modified By      :    Sergio Kobayashi
Modifide Date    :    07.11.2017
************************************************************************************/
global class EmailnotificationLeadsnotupdated implements Database.Batchable<sObject>,Schedulable{
    //START METHOD
    Date pastdatdate = system.today().addDays(-30);   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        
        
        
        return Database.getQueryLocator([SELECT Id,Name,Assigned_Dealer__c,CAC_Lead_Status__c,Lead_Assignment_Notification_Done__c,
                                         Service_Advisor__c, Assigned_Dealer__r.Dealer_GC_Code__c, Assigned_Dealer__r.Name FROM Lead__c where (Assigned_Dealer__c != null AND LastModifiedDate <=:pastdatdate AND RecordType.Name IN('Sales Leads') AND (Dealer_Lead_Status__c != 'Purchased(Only Non BDC)' AND Dealer_Lead_Status__c !='Lost') AND (Lead_Latest_Phase__c != 'Vehicle Registration' AND 
                                                                                                                                                                                                                                                                                                                       Lead_Latest_Phase__c != 'Invoiced') AND (CAC_Lead_Status__c = 'Allocated')) OR (Assigned_Dealer__c != null AND LastModifiedDate <=:pastdatdate AND RecordType.Name IN('Aftersales Leads') AND Appointment_DateTime__c !=null)  ]);          
    }
    
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        
        Map<Id, User> leadAssignedUserMap = new Map<Id, User>();
        Map<Id, Map<String, String>> leadAssignedDealers = new Map<Id, Map<String, String>>();
        Map<Id, List<User>> leadAssignedDealerRecipients = new Map<Id, List<User>>();
        Set<Id> assignedServiceAdvisorUserIds = new Set<Id>();
        Set<String> assignedDealerGCCodes = new Set<String>();
        
        for(Lead__c led : Scope){
            assignedServiceAdvisorUserIds.add(led.Service_Advisor__c);
            assignedDealerGCCodes.add(led.Assigned_Dealer__r.Dealer_GC_Code__c);
            User u = new User();
            u.Id = led.Service_Advisor__c;
            leadAssignedUserMap.put(led.id, u);
            
            Map<String, String> GcNdMap = new Map<String, String>();
            GcNdMap.put(led.Assigned_Dealer__r.Name, led.Assigned_Dealer__r.Dealer_GC_Code__c);
            leadAssignedDealers.put(led.Id, GcNdMap);
        }
        List<User> userRecords = [Select id,Name,email,Market__c,Dealer_GC_Code__c from User where IsActive = True and Id IN : assignedServiceAdvisorUserIds];
        
        for (Id lid: leadAssignedUserMap.keySet()){
            for (User u: userRecords){
                if (leadAssignedUserMap.get(lid).Id == u.Id){
                    leadAssignedUserMap.put(lid, u);
                }
            }
        }
        
        List<User> userGccodeRecords = [Select id,Name,email,Market__c,Dealer_GC_Code__c,Notification_Lead_No_Update__c from User where IsActive = True and Dealer_GC_Code__c IN : assignedDealerGCCodes];
        
        for (Id lid: leadAssignedDealers.keySet()) {
            List<User> leadAssignedDealerRecipientsList = new List<User>();
            for (User u: userGccodeRecords) {
                for (String assignedDealerName: leadAssignedDealers.get(lid).keySet()){
                    if (u.Dealer_GC_Code__c == leadAssignedDealers.get(lid).get(assignedDealerName)){
                        if (u.Notification_Lead_No_Update__c != Null){
                            List<String> outletNameList = u.Notification_Lead_No_Update__c.split(';');
                            for (String outletName: outletNameList){
                                if (outletName == assignedDealerName){
                                    leadAssignedDealerRecipientsList.add(u);
                                }
                            }
                        }
                    }
                }
            }
            leadAssignedDealerRecipients.put(lid, leadAssignedDealerRecipientsList);
        }
        
        sendMail(leadAssignedUserMap,leadAssignedDealerRecipients );
        
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(Map<Id, User> leadAssignedUserMap,Map<Id, List<User>> leadAssignedDealerRecipients){        
        List<Id> userIds = new List<Id>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'Lead untouched for 30 days' limit 1];
        
        for(Id lid : leadAssignedUserMap.keySet()){            
            if (leadAssignedUserMap.get(lid).Id != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.saveAsActivity = false;
                mail.setTargetObjectId(leadAssignedUserMap.get(lid).Id);
                mail.setTemplateId(e.Id);
                if (leadAssignedUserMap.get(lid).Market__c == 'JP'){
                    mail.setCharset('JIS');
                }
                mail.setUseSignature(false);
                mail.setWhatId(lid);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
        }
        
        for(Id lid : leadAssignedDealerRecipients.keySet()){
            for (User u: leadAssignedDealerRecipients.get(lid)) {
                if (u.Id != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.saveAsActivity = false;
                    mail.setTargetObjectId(u.Id);
                    mail.setTemplateId(e.Id);
                    if (u.Market__c == 'JP'){
                        mail.setCharset('JIS');
                    }
                    mail.setUseSignature(false);
                    mail.setWhatId(lid);
                    mail.setSaveAsActivity(false);
                    mails.add(mail);
                }
            }
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