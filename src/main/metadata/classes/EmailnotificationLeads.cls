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
2. Modified By		:	 Sergio Kobayashi
   Modified Date	:	 08.09.2017
************************************************************************************/
global class EmailnotificationLeads implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,CAC_Lead_Status__c,Last_Nonassign_Notification_Date__c, Assigned_Dealer__r.Dealer_GC_Code__c, 
                                         Assigned_Dealer__r.Dealer_ND_Code__c, Assigned_Dealer__r.Name 
                                         FROM Lead__c where Lead_Assignment_Notification_Done__c =: false
                    					 and Assigned_Dealer__c !=: NULL and CAC_Lead_Status__c = 'Allocated' and 
                                         ((RecordType.Name IN('Sales Leads') and Assigned_Dealer__r.SalesLead_Notification_Timing__c = '3 times a day') 
                                         OR (RecordType.Name IN('Aftersales Leads') and Assigned_Dealer__r.ASLead_Notification_Timing__c = '3 times a day'))]);            
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        
        Map<Id,Lead__c> updateLeadMap = new Map<id,Lead__c>();
        Map<Lead__c, List<User>> leadAssignedDealerUserMap = new Map<Lead__c, List<User>>();
        Map<Lead__c, Map<String, String>> leadAssignedDealers = new Map<Lead__c, Map<String, String>>();
        Map<Lead__c, List<User>> leadAssignedDealerRecipients = new Map<Lead__c, List<User>>();
        Map<User, Map<String, List<Lead__c>>> leadAssignedMailRecipientMap = new Map<User, Map<String, List<Lead__c>>>();
        Set<String> assignedDealerNDCodes = new Set<String>();
        Set<String> assignedDealerGCCodes = new Set<String>();
        
        for(Lead__c led : Scope){
            assignedDealerGCCodes.add(led.Assigned_Dealer__r.Dealer_GC_Code__c);
            assignedDealerNDCodes.add(led.Assigned_Dealer__r.Dealer_ND_Code__c);
            
            Map<String, String> GcNdMap = new Map<String, String>();
            GcNdMap.put(led.Assigned_Dealer__r.Name, led.Assigned_Dealer__r.Dealer_GC_Code__c);
            leadAssignedDealers.put(led, GcNdMap);
			led.Lead_Assignment_Notification_Done__c = true;
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
            leadAssignedDealerUserMap.put(led, userList);
        }
        
        List<User> userGccodeRecords = [Select id,Name,email,Market__c,Dealer_GC_Code__c,Notification_Lead_Not_Assigned__c from User where IsActive = True and Profile.Name = 'Japan Dealer Company Manager' and Dealer_GC_Code__c IN : assignedDealerGCCodes];
        
        for (Lead__c lid: leadAssignedDealers.keySet()) {
            List<User> leadAssignedDealerRecipientsList = new List<User>();
            for (User u: userGccodeRecords) {
                if (leadAssignedDealers.get(lid) != null){
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
            }
            leadAssignedDealerRecipients.put(lid, leadAssignedDealerRecipientsList);
        }
        
        for (Lead__c led: leadAssignedDealerUserMap.keySet()){
            for (User u: leadAssignedDealerUserMap.get(led)){
                if (leadAssignedMailRecipientMap.containsKey(u)){
                    if(leadAssignedMailRecipientMap.get(u).containsKey(led.Assigned_Dealer__r.Name)){
                        leadAssignedMailRecipientMap.get(u).get(led.Assigned_Dealer__r.Name).add(led);
                    } else{
                        List<Lead__c> leadList = new List<Lead__c>();
                    	leadList.add(led);
                        leadAssignedMailRecipientMap.get(u).put(led.Assigned_Dealer__r.Name, leadList);
                    }
                } else {
                    List<Lead__c> leadList = new List<Lead__c>();
                    leadList.add(led);
                    Map<String, List<Lead__c>> leadMap = new Map<String, List<Lead__c>>();
                    leadMap.put(led.Assigned_Dealer__r.Name, leadList);
                    leadAssignedMailRecipientMap.put(u, leadMap);
                }
            }
        }
        
        for (Lead__c led: leadAssignedDealerRecipients.keySet()){
            for (User u: leadAssignedDealerRecipients.get(led)){
                if (leadAssignedMailRecipientMap.containsKey(u)){
                    if(leadAssignedMailRecipientMap.get(u).containsKey(led.Assigned_Dealer__r.Name)){
                        leadAssignedMailRecipientMap.get(u).get(led.Assigned_Dealer__r.Name).add(led);
                    } else{
                        List<Lead__c> leadList = new List<Lead__c>();
                    	leadList.add(led);
                        leadAssignedMailRecipientMap.get(u).put(led.Assigned_Dealer__r.Name, leadList);
                    }
                } else {
                    List<Lead__c> leadList = new List<Lead__c>();
                    leadList.add(led);
                    Map<String, List<Lead__c>> leadMap = new Map<String, List<Lead__c>>();
                    leadMap.put(led.Assigned_Dealer__r.Name, leadList);
                    leadAssignedMailRecipientMap.put(u, leadMap);
                }
            }
        }

        sendMail(leadAssignedMailRecipientMap);
        if(updateLeadMap.size() > 0){
            update updateLeadMap.values();
        }
        
    } 
    //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(Map<User, Map<String, List<Lead__c>>> leadAssignedMailRecipientMap){        
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate e = [select id,name,DeveloperName, HtmlValue, Subject from EmailTemplate WHERE DeveloperName = 'Lead_assignment_to_outlet_batch_version' limit 1];
        
        for (User u: leadAssignedMailRecipientMap.keySet()){
       		if (u.Id != null){
                for (String outletName: leadAssignedMailRecipientMap.get(u).keySet()){
                    if (outletName != null){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.saveAsActivity = false;
                        mail.setTargetObjectId(u.Id);
                        
                        String emailHtmlBody = e.HtmlValue;
                        emailHtmlBody = emailHtmlBody.replace('{DealerOutletName}', outletName);
                        
                        List<Lead__c> leadList = leadAssignedMailRecipientMap.get(u).get(outletName);
                        emailHtmlBody = emailHtmlBody.replace('{NumberOfLeads}', String.valueOf(leadList.size()));
                        
                        String leadURLList = '';
                        
                        for (Lead__c led: leadList){
                            leadURLList = leadURLList + '<a href="' + Label.Dealer_login_Url + '/' + led.Id + '">' + Label.Dealer_login_Url + '/' + led.Id + '</a><br>';
                        }
                        
                        emailHtmlBody = emailHtmlBody.replace('{LinksToLeads}', leadURLList);
                        
                        System.debug(emailHtmlBody);
                        
                        mail.setHtmlBody(emailHtmlBody);
                        mail.setCharset('JIS');
                        mail.setUseSignature(false);
                        mail.setSubject(e.Subject);
                        mails.add(mail); 
                	}
                }
        	}            
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