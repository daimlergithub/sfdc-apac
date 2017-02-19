/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    Retail Campaign Scheduler and Notification Class
                          
JIRA NO             :    SFDCJP-1015                                             
************************************************************************************/
global class RetailCampaignSchedulerAndNotificationJP implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    global List<String> notiMailerList = new List<String>();
    global String emailBodyStr;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.Today();
        String query = 'Select  Id, OwnerId, Owner.Email, Owner.Name, Execution_Type__c, Parent_Campaign1__c, Parent_Campaign1__r.Campaign_Type__c, Dealer_Name__c, Dealer_Name__r.Dealer_Sales_Manager_Email__c, Dealer_Name__r.Dealer_Sales_Manager__c, Dealer_Name__r.Dealer_Aftersales_Manager__c, Dealer_Name__r.Dealer_Aftersales_Manager_Email__c,';
        query += '(Select Id, Status__c From Campaign_Members__r) From Retail_Campaign__c Where Execution_Start_Date__c =: today AND RecordType.DeveloperName = \'Retail_Execution_Campaign\'';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Task> taskList = new List<Task>();
        List<Campaign_Lead__c> cLeadLst = new List<Campaign_Lead__c>();
        List<Retail_Campaign__c> campLst = new List<Retail_Campaign__c>();
        List<Campaign_Member__c> campaignMemberListToUpdate = new List<Campaign_Member__c>();
        
        List<Group> queueList = [select Id from Group where DeveloperName = 'Test_Queue' and Type = 'Queue'];
        Map<String, Id> leadRecTypeNameToRecTypeIdMap = new Map<String, Id>();
        leadRecTypeNameToRecTypeIdMap.put('Sales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        leadRecTypeNameToRecTypeIdMap.put('Aftersales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
        leadRecTypeNameToRecTypeIdMap.put('Finance', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance').getRecordTypeId());
     
        Map<String, String> parentCapmaignToLeadRecTypeMap = new Map<String, String>();
        parentCapmaignToLeadRecTypeMap.put('Sales', 'Sales Leads');
        parentCapmaignToLeadRecTypeMap.put('After Sales', 'Aftersales Leads');
        parentCapmaignToLeadRecTypeMap.put('Finance', 'Finance');
        
        
        for(Retail_Campaign__c campaignRec : scope){
            if(campaignRec.Execution_Type__c != null && campaignRec.Execution_Type__c == 'OB Call') {
                String ownerEmailIdToCreateTask = null;
                if(campaignRec.Parent_Campaign1__c != null) {
                    if(campaignRec.Parent_Campaign1__r.Campaign_Type__c != null && campaignRec.Dealer_Name__c != null) {        
                        if(campaignRec.Parent_Campaign1__r.Campaign_Type__c == 'Sales') {
                            ownerEmailIdToCreateTask = campaignRec.Dealer_Name__r.Dealer_Sales_Manager_Email__c;
                        } else if(campaignRec.Parent_Campaign1__r.Campaign_Type__c == 'After Sales' || campaignRec.Parent_Campaign1__r.Campaign_Type__c == 'Finance') {
                            ownerEmailIdToCreateTask = campaignRec.Dealer_Name__r.Dealer_Aftersales_Manager_Email__c;
                        }
                    }
                }
                String taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
                for(Campaign_Member__c campaignMemberRec : campaignRec.Campaign_Members__r) {
                    Task task = new Task();
                    task.WhatID = campaignRec.Id;
                    task.Status = 'Open';
                    task.Type = 'Campaign';
                    task.subject = 'Campaign Executed';
                    task.ownerId = campaignRec.OwnerId;
                    task.priority = 'Normal';
                    task.RecordTypeId = taskRecTypeId;
                    taskList.add(task);
                    
                    campaignMemberRec.Status__c = 'Executed';
                    campaignMemberListToUpdate.add(campaignMemberRec);
                }
                
                if(ownerEmailIdToCreateTask != null){
                    notiMailerList.add(ownerEmailIdToCreateTask);
                } else {
                    notiMailerList.add(campaignRec.Owner.Email);
                }
                emailBodyStr = 'Hi '+campaignRec.Owner.Name+',<br /><br/>This Retail Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                emailBodyStr += URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignRec.Id+'<br/><br />Thanks!!<br/>Salesforce';
            }
            
            else if(campaignRec.Execution_Type__c != null && (campaignRec.Execution_Type__c == 'DM' || campaignRec.Execution_Type__c == 'eDM')) {
                notiMailerList.add(campaignRec.Owner.Email);
                emailBodyStr = 'Hi '+campaignRec.Owner.Name+',<br /><br/>This Retail Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                emailBodyStr += URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignRec.Id+'<br/><br />Thanks!!<br/>Salesforce';
            }
            
            else if(campaignRec.Execution_Type__c != null && campaignRec.Execution_Type__c == 'Lead') {
                Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(campaignRec.Parent_Campaign1__r.Campaign_Type__c) ? 
                                            leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(campaignRec.Parent_Campaign1__r.Campaign_Type__c)) : null);
                for(Campaign_Member__c campaignMemberRec : campaignRec.Campaign_Members__r ) {
                    Lead__c lead = new Lead__c();
                    lead.CAC_Lead_Status__c = 'New';
                    lead.Retail_Campaign_Name__c = campaignRec.id;
                    lead.OwnerId = queueList[0].Id;
                    if(recTypeId != null) {
                        lead.RecordTypeId = recTypeId;
                    }
                    leadList.add(lead);
                
                    campaignMemberRec.Status__c = 'Executed';
                    campaignMemberListToUpdate.add(campaignMemberRec);
                }
                notiMailerList.add(campaignRec.Owner.Email);
                emailBodyStr = 'Hi '+campaignRec.Owner.Name+',<br /><br/>This Retail Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                emailBodyStr += URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignRec.Id+'<br/><br />Thanks!!<br/>Salesforce';
            }
        }
        
        if(taskList.size() > 0) {
            insert taskList;
        }
        if(leadList.size() > 0) {
            insert leadList;
        }
        
        if(leadList.size() > 0) {
            for(Lead__c lead : leadList){
                Campaign_Lead__c cLead = new Campaign_Lead__c(); 
                cLead.Lead__c = lead.id;
                cLead.Retail_Campaign__c = lead.Retail_Campaign_Name__c;
                cLeadLst.add(cLead);
            }
            insert cLeadLst;  
        }
    
        if(campaignMemberListToUpdate.size() > 0) {
            update campaignMemberListToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
         EmailTemplate templateId = [Select id from EmailTemplate where name = 'test email'];
         List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
         for(String userId : notiMailerList){
               Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
               msg.SetsaveAsActivity(false); 
               //msg.setTemplateId(templateId.Id);
               //msg.setTargetObjectId(userId);  
               msg.setToAddresses(new string[]{userId});
               msg.setHTMLBody(emailBodyStr);
               msg.subject = 'Retail Campaign Notification';
              
               msgList.add(msg);
          }
          Messaging.sendEmail(msgList);     
    }
     
     
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CampaignSchedulerAndNotificationJP());
    }
}