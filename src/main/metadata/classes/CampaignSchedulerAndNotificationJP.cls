/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    Campaign Scheduler and Notification Class
                          
JIRA NO             :    SFDCJP-1013                                            
************************************************************************************/

global class CampaignSchedulerAndNotificationJP implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    global List<String> notiMailerList = new List<String>();
    global String emailBodyStr;
    global String templateName;
    global List<NotificationWrapper> notificationWrapperList;
    global List<String> templateNameList = new List<String>{'Campaign notification on Execution', 'Campaign Lead Assignment Notification', 'Task Notification'};
    global Set<Id> campignIdSetForLeadType = new Set<Id>();
    global Set<Id> newInsertedLeadId = new Set<Id>();
    global Map<String, Id> templateNameToTemplateIdMap;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT ';
        for(String fieldName : getCampaignFields()) {
            query += fieldName + ', ';
        }
        // Child Query 
        query += '( SELECT ';
        for(String fieldName : getCampaignMemberFields()) {
            query += fieldName + ', ';
        }
        query = query.substring(0, query.length() - 2);
        query += ' FROM Campaign_Members1__r) ';
        
        query += ' FROM Campaign WHERE RecordType.DeveloperName = \'Campaign_Executiono\'';
        
        //String query = 'Select Id, OwnerId, Owner.Name, Execution_Type__c, Child_Campaign_Status__c, Campaign_CCC_Manager__c, Execution_Start_Date__c, ParentId, Parent.Campaign_Type__c, ';
        //query += '(Select Id, OwnerId, Contact_Id__c, Special_Flag_to_Include__c, Special_flag_to_Exclude__c, Delinquency_Flag__c, MBF_Anti_Social_flag__c, Offer_Prohibit_Flag__c, Payment_Suspended_Flag__c from Campaign_Members1__r)';
        //query += 'from Campaign Where Execution_Start_Date__c =: today AND RecordType.DeveloperName = \'Campaign_Executiono\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
        List<Lead__c>leadLst = new List<Lead__c>();
        List<Task>tskLst = new List<Task>();
        List<Campaign_Lead__c> cLeadLst = new List<Campaign_Lead__c>();
        List<Campaign >campLst = new List<Campaign>();
        List<Campaign_Member__c> campMemberLst = new List<Campaign_Member__c>();
        notificationWrapperList = new List<NotificationWrapper>();
         
        // Create Tempate Map to avoid SOQL Limits
        templateNameToTemplateIdMap = new Map<String, Id>();
        List<EmailTemplate> templateList = [Select Id, Name from EmailTemplate where Name IN: templateNameList];
        for(EmailTemplate tempRec : templateList) {
            templateNameToTemplateIdMap.put(tempRec.Name, tempRec.Id);
        }
         
        Map<String, Id> leadRecTypeNameToRecTypeIdMap = new Map<String, Id>();
        leadRecTypeNameToRecTypeIdMap.put('Sales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        leadRecTypeNameToRecTypeIdMap.put('Aftersales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
       // leadRecTypeNameToRecTypeIdMap.put('Finance', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance').getRecordTypeId());
         
        Map<String, String> parentCapmaignToLeadRecTypeMap = new Map<String, String>();
        parentCapmaignToLeadRecTypeMap.put('Sales', 'Sales Leads');
        parentCapmaignToLeadRecTypeMap.put('After Sales', 'Aftersales Leads');
        parentCapmaignToLeadRecTypeMap.put('Finance', 'Sales Leads');
        String taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        
        for(Campaign camp : scope) {
            if(camp.Execution_Start_Date__c == Date.Today()) {
                if((camp.Execution_Type__c == 'eMail' || camp.Execution_Type__c == 'DM') && camp.Child_Campaign_Status__c == 'Segmentation') {
                    String templateId = templateNameToTemplateIdMap.containsKey('Campaign notification on Execution') 
                                                    ? templateNameToTemplateIdMap.get('Campaign notification on Execution')
                                                    : templateNameToTemplateIdMap.get('Task Notification');
                    setNotificationTemplate(camp.OwnerId, templateId, camp.Id);
                     
                    camp.Child_Campaign_Status__c = 'Execution';
                    campLst.add(camp);
                }
                 
                else if(camp.Execution_Type__c == 'Lead' && camp.Child_Campaign_Status__c == 'Segmentation') {
                    if(camp.Campaign_CCC_Manager__c != null) {
                        /*String templateId = templateNameToTemplateIdMap.containsKey('Campaign Lead Assignment Notification') 
                                                    ? templateNameToTemplateIdMap.get('Campaign Lead Assignment Notification')
                                                    : templateNameToTemplateIdMap.get('Task Notification');
                        setNotificationTemplate(camp.Campaign_CCC_Manager__c , templateId, camp.Id);*/
                        campignIdSetForLeadType.add(camp.Id);
                    }
                     
                     
                    Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(camp.Parent.Campaign_Type__c) ? 
                                                leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(camp.Parent.Campaign_Type__c)) : null);
                    for(Campaign_Member__c campaignMemberRec : camp.Campaign_Members1__r) {
                        Lead__c lead = new Lead__c();
                        lead.CAC_Lead_Status__c = 'New'; 
                        lead.Source_Campaign__c = camp.id;
                        lead.Contact__c = campaignMemberRec.Contact_Id__c;
                        
                        if(campaignMemberRec.Special_Flag_to_Include__c == 'true') {
                            lead.OwnerId = camp.OwnerId;//campaignMemberRec.Contact_Id__c;
                            
                        } else if(camp.Parent.Campaign_Type__c == 'Finance' && (campaignMemberRec.Delinquency_Flag__c == 'true' || campaignMemberRec.Special_flag_to_Exclude__c == 'true' ||
                                campaignMemberRec.MBF_Anti_Social_flag__c == 'true' || campaignMemberRec.Offer_Prohibit_Flag__c == 'true' || campaignMemberRec.Payment_Suspended_Flag__c == 'true')) {
                            lead.OwnerId = camp.Campaign_CCC_Manager__c;
                            
                        } else {
                            lead.OwnerId = camp.OwnerId;//campaignMemberRec.Contact_Id__c;
                        }
                        
                        if(recTypeId != null) {
                            lead.RecordTypeId = recTypeId;
                        }
                        leadLst.add(lead);
                        
                        campaignMemberRec.Status__c = 'Executed';
                        campMemberLst.add(campaignMemberRec);
                    }
                    camp.Child_Campaign_Status__c = 'Execution';
                    campLst.add(camp);
                }
                 
                else if(camp.Execution_Type__c == 'OB Call' && camp.Child_Campaign_Status__c == 'Segmentation'){
                     
                    if(camp.Campaign_CCC_Manager__c != null){
                        setNotificationTemplate(camp.Campaign_CCC_Manager__c , templateNameToTemplateIdMap.get('Task Notification'), camp.Id);
                    }
                     
                    for(Campaign_Member__c campaignMemberRec : camp.Campaign_Members1__r) {
                        Task task = new Task();
                        task.WhatID = camp.Id;
                        task.Status = 'Open';
                        task.Type = 'Campaign';
                        task.subject = 'Campaign Executed';
                      //  task.ownerId = camp.Campaign_CCC_Manager__c;
                        task.priority = 'Normal';
                        task.RecordTypeId = taskRecTypeId;
                        task.ActivityDate = camp.Execution_Start_Date__c;
                        tskLst.add(task);
                        
                        campaignMemberRec.Status__c = 'Executed';
                        campMemberLst.add(campaignMemberRec);
                    }
                     
                    camp.Child_Campaign_Status__c = 'Execution';
                    campLst.add(camp);
                }
            }
        }
        
             
        if(tskLst.size() >0){
            insert tskLst;
        }    
          
        if(leadLst.size() >0){  
            insert leadLst;
        }
          
        if(campLst.size() >0){
            update campLst;
        }
          
        if(campMemberLst.size() >0){
            update campMemberLst;
        }
        
        if(leadLst.size() >0){
            for(Lead__c lead : leadLst){
                Campaign_Lead__c cLead = new Campaign_Lead__c(); 
                cLead.Lead__c = lead.id;
                cLead.Campaign__c = lead.Source_Campaign__c;
                cLeadLst.add(cLead);
                newInsertedLeadId.add(lead.Id);
            }
            insert cLeadLst;  
        }
    }
    
    public class NotificationWrapper {
        public String userId;
        public String templateId;
        public String whatId;
        
        public NotificationWrapper(String userId, String templateId, String whatId) {
            this.userId = userId;
            this.templateId = templateId;
            this.whatId = whatId;
        }
    }
    
    
    private void setNotificationTemplate(String userId, String templateId, String whatId) {
        notificationWrapperList.add(new NotificationWrapper(userId, templateId, whatId));
    }  
    
    private List<String> getCampaignFields() {
        List<String> fieldList = new List<String> {'OwnerId',
                                                    'Owner.Name',
                                                    'Execution_Type__c',
                                                    'Child_Campaign_Status__c',
                                                    'Campaign_CCC_Manager__c',
                                                    'Execution_Start_Date__c',
                                                    'ParentId',
                                                    'Campaign_Code__c',
                                                    'Parent.Campaign_Type__c'
                                                };
        
        return fieldList;
    }
    
    private List<String> getCampaignMemberFields() {
        List<String> fieldList = new List<String> {'OwnerId',
                                                    'Contact_Id__c',
                                                    'Special_Flag_to_Include__c',
                                                    'Special_flag_to_Exclude__c',
                                                    'Delinquency_Flag__c',
                                                    'MBF_Anti_Social_flag__c',
                                                    'Offer_Prohibit_Flag__c',
                                                    'Payment_Suspended_Flag__c',
                                                    'Auto_creation_of_tasks__c',
                                                    'Auto_creation_of_leads__c',
                                                    'Auto_creation_of_DM_requests__c',
                                                    'Address__r.Address_Type__c',
                                                    'Preferred_Dealer__c',
                                                    'Campaign_ID__r.Parent.Campaign_Type__c',
                                                    'Zip_Code_Finance__c',
                                                    'Zip_Code__c',
                                                    'Campaign_ID__r.OwnerId'
                                                };
        
        return fieldList;
    }
    
    global void finish(Database.BatchableContext bc) {
        system.debug('notificationList\n\n' + notificationWrapperList);
        
        if(campignIdSetForLeadType.size() > 0) {
            setWrapperListForLeads(campignIdSetForLeadType);
        }
        
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        for(NotificationWrapper notificationWrapperRec : notificationWrapperList) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.SetsaveAsActivity(false);
            msg.setTemplateId(notificationWrapperRec.templateId);
            msg.setTargetObjectId(notificationWrapperRec.userId);  
            msg.setWhatId(notificationWrapperRec.whatId);  
            msgList.add(msg);
        }
        if(msgList.size() > 0) {
            Messaging.sendEmail(msgList);     
        }
    }
    
    private void setWrapperListForLeads(Set<Id> campignIdSetForLeadType) {
        List<Campaign> campaignList = [select Campaign_CCC_Manager__c, (select Id from Leads__r where Id IN : newInsertedLeadId) from Campaign where Id IN: campignIdSetForLeadType];
        String templateId = templateNameToTemplateIdMap.containsKey('Campaign Lead Assignment Notification') 
                                                    ? templateNameToTemplateIdMap.get('Campaign Lead Assignment Notification')
                                                    : templateNameToTemplateIdMap.get('Task Notification');
                                                    
        for(Campaign campRec : campaignList) {
            for(Lead__c leadRec : campRec.Leads__r) {
                setNotificationTemplate(campRec.Campaign_CCC_Manager__c, templateId, leadRec.Id);
            }
        }
    }
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CampaignSchedulerAndNotificationJP());
    }
}