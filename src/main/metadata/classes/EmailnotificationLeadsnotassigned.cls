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
Bug JIRA NO			:	 SFDCJP-2782

MODIFICATION DETAILS:

1. Modified By      :    Sergio Kobayashi
   Modifide Date    :    07.13.2017
************************************************************************************/

global class EmailnotificationLeadsnotassigned implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    Date pastdatdate = system.today().addDays(-1);    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,CAC_Lead_Status__c,Last_Nonassign_Notification_Date__c,
                    Assigned_Dealer__r.Dealer_GC_Code__c,Assigned_Dealer__r.Dealer_ND_Code__c, Assigned_Dealer__r.Name,Service_Advisor__c FROM Lead__c where (Last_Nonassign_Notification_Date__c <=: pastdatdate OR Last_Nonassign_Notification_Date__c = null)
                    and Service_Advisor__c = NULL and CAC_Lead_Status__c = 'Allocated']);            
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);

        Map<Id,Lead__c> updateLeadMap = new Map<id,Lead__c>();
		Map<Id, List<User>> leadAssignedDealerUserMap = new Map<Id, List<User>>();
        Map<Id, Map<String, String>> leadAssignedDealers = new Map<Id, Map<String, String>>();
        Map<Id, List<User>> leadAssignedDealerRecipients = new Map<Id, List<User>>();
        Set<String> assignedDealerNDCodes = new Set<String>();
        Set<String> assignedDealerGCCodes = new Set<String>();
        
        for(Lead__c led : Scope){
            assignedDealerGCCodes.add(led.Assigned_Dealer__r.Dealer_GC_Code__c);
            assignedDealerNDCodes.add(led.Assigned_Dealer__r.Dealer_ND_Code__c);
            
            Map<String, String> GcNdMap = new Map<String, String>();
            GcNdMap.put(led.Assigned_Dealer__r.Name, led.Assigned_Dealer__r.Dealer_GC_Code__c);
            leadAssignedDealers.put(led.Id, GcNdMap);
            led.Last_Nonassign_Notification_Date__c = system.today();
            updateLeadMap.put(led.id,led);
        }
        List<User> userNdcodeRecords = [Select id,Name,email,Market__c,Dealer_GC_Code__c,Dealer_ND_Code__c from User where IsActive = True and Profile.Name IN ('Japan Dealer Sales Manager','Japan Dealer Sales Representative','Japan Dealer Service Advisor','Japan Dealer Service Manager') and Dealer_ND_Code__c IN :assignedDealerNDCodes];
        
        for (Lead__c led : Scope){
            List<User> userList = new List<User>();
            for (User u: userNdcodeRecords){
                if (led.Assigned_Dealer__r.Dealer_ND_Code__c == u.Dealer_ND_Code__c){
                    userList.add(u);
                }
            }
            leadAssignedDealerUserMap.put(led.Id, userList);
        }
        
        List<User> userGccodeRecords = [Select id,Name,email,Market__c,Dealer_GC_Code__c,Notification_Lead_Not_Assigned__c from User where IsActive = True and Profile.Name = 'Japan Dealer Company Manager' and Dealer_GC_Code__c IN : assignedDealerGCCodes];
        
        for (Id lid: leadAssignedDealers.keySet()) {
            List<User> leadAssignedDealerRecipientsList = new List<User>();
            for (User u: userGccodeRecords) {
                for (String assignedDealerName: leadAssignedDealers.get(lid).keySet()){
                    if (u.Dealer_GC_Code__c == leadAssignedDealers.get(lid).get(assignedDealerName)){
                        if (u.Notification_Lead_Not_Assigned__c != Null){
                            List<String> outletNameList = u.Notification_Lead_Not_Assigned__c.split(';');
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

        sendMail(leadAssignedDealerUserMap,leadAssignedDealerRecipients );
        if(updateLeadMap.size() > 0){
            update updateLeadMap.values();
        }
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(Map<Id, List<User>> leadAssignedDealerUserMap,Map<Id, List<User>> leadAssignedDealerRecipients){        

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'Lead assignment to dealer outlet for unassigned' limit 1];

        for(Id lid : leadAssignedDealerUserMap.keySet()){            
            for (User u: leadAssignedDealerUserMap.get(lid)) {
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
        
        for(Id lid : leadAssignedDealerRecipients.keySet()){
            for (User u: leadAssignedDealerRecipients.get(lid)) {
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
        
        Messaging.sendEmail(mails);
        
    }
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new EmailnotificationLeadsnotassigned());
    }
}