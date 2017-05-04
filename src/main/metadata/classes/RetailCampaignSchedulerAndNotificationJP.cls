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
    global String templateName;
    global List<NotificationWrapper> notificationWrapperList;
    global List<String> templateNameList = new List<String>{'Retail CampaignnotificationforExecution', 'Campaign Lead Assignment Notification', 'Task Notification to Dealer Outlet'};
    global Set<Id> campignIdSetForLeadType = new Set<Id>();
    global Set<Id> newInsertedLeadId = new Set<Id>();
    global Map<String, Id> templateNameToTemplateIdMap;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.Today();
        
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
        query += ' FROM Campaign_Members__r) ';
        
        query += ' FROM Retail_Campaign__c WHERE RecordType.DeveloperName = \'Retail_Execution_Campaign\'';
        
        
        //String query = 'Select  Id, OwnerId, Owner.Email, Owner.Name, Execution_Type__c, Child_Campaign_Status__c, Execution_Start_Date__c, Parent_Campaign1__c, Parent_Campaign1__r.Campaign_Type__c, Dealer_Name__c, Dealer_Name__r.Dealer_Sales_Manager_Email__c, Dealer_Name__r.Dealer_Sales_Manager__c, Dealer_Name__r.Dealer_Aftersales_Manager__c, Dealer_Name__r.Dealer_Aftersales_Manager_Email__c,';
        //query += '(Select Id, Status__c, Contact_Id__c From Campaign_Members__r) From Retail_Campaign__c Where Execution_Start_Date__c =: today AND RecordType.DeveloperName = \'Retail_Execution_Campaign\'';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Task> taskList = new List<Task>();
        List<Campaign_Lead__c> cLeadLst = new List<Campaign_Lead__c>();
        List<Retail_Campaign__c> campLst = new List<Retail_Campaign__c>();
        List<Campaign_Member__c> campaignMemberListToUpdate = new List<Campaign_Member__c>();
        notificationWrapperList = new List<NotificationWrapper>();
        List<Campaign_Member__c> autoCreateLeadCheckedCampaignMemberRecList = new List<Campaign_Member__c>();
        
        // Create Tempate Map to avoid SOQL Limits
        templateNameToTemplateIdMap = new Map<String, Id>();
        List<EmailTemplate> templateList = [Select Id, Name from EmailTemplate where Name IN: templateNameList];
        for(EmailTemplate tempRec : templateList) {
            templateNameToTemplateIdMap.put(tempRec.Name, tempRec.Id);
        }
        
        //List<Group> queueList = [select Id from Group where DeveloperName = 'Test_Queue' and Type = 'Queue'];
        Map<String, Id> leadRecTypeNameToRecTypeIdMap = new Map<String, Id>();
        leadRecTypeNameToRecTypeIdMap.put('Sales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        leadRecTypeNameToRecTypeIdMap.put('Aftersales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
        //leadRecTypeNameToRecTypeIdMap.put('Finance', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance').getRecordTypeId());
     
        Map<String, String> parentCapmaignToLeadRecTypeMap = new Map<String, String>();
        parentCapmaignToLeadRecTypeMap.put('Sales', 'Sales Leads');
        parentCapmaignToLeadRecTypeMap.put('After Sales', 'Aftersales Leads');
        parentCapmaignToLeadRecTypeMap.put('Finance', 'Sales Leads');
        
        
        for(Retail_Campaign__c campaignRec : scope){
            if(campaignRec.Execution_Start_Date__c == Date.Today()) {
                if(campaignRec.Execution_Type__c != null && campaignRec.Execution_Type__c == 'OB Call' && campaignRec.Child_Campaign_Status__c == 'Segmentation') {
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
                        task.ActivityDate = campaignRec.Execution_Start_Date__c;
                        taskList.add(task);
                        
                        campaignMemberRec.Status__c = 'Executed';
                        campaignMemberListToUpdate.add(campaignMemberRec);
                    }
                    
                    campaignRec.Child_Campaign_Status__c = 'Execution';
                    campLst.add(campaignRec);
                    
                    
                    String templateId =  templateNameToTemplateIdMap.get('Task Notification to Dealer Outlet');
                    setNotificationTemplate(campaignRec.OwnerId, templateId, campaignRec.Id);
                    
                    /*if(ownerEmailIdToCreateTask != null){
                        //notiMailerList.add(ownerEmailIdToCreateTask);
                    } else {
                        notiMailerList.add(campaignRec.OwnerId);
                    }
                    emailBodyStr = 'Hi '+campaignRec.Owner.Name+',<br /><br/>This Retail Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                    emailBodyStr += URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignRec.Id+'<br/><br />Thanks!!<br/>Salesforce';*/
                }
                
                else if(campaignRec.Execution_Type__c != null && (campaignRec.Execution_Type__c == 'DM' || campaignRec.Execution_Type__c == 'eDM') && campaignRec.Child_Campaign_Status__c == 'Segmentation') {
                    //notiMailerList.add(campaignRec.OwnerId);
                    //emailBodyStr = 'Hi '+campaignRec.Owner.Name+',<br /><br/>This Retail Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                    //emailBodyStr += URL.getSalesforceBaseUrl().toExternalForm()+'/'+campaignRec.Id+'<br/><br />Thanks!!<br/>Salesforce';
                    
                    //templateName = 'Retail CampaignnotificationforExecution';
                    
                    String templateId = templateNameToTemplateIdMap.containsKey('Retail CampaignnotificationforExecution') 
                                                    ? templateNameToTemplateIdMap.get('Retail CampaignnotificationforExecution')
                                                    : templateNameToTemplateIdMap.get('Task Notification to Dealer Outlet');
                    setNotificationTemplate(campaignRec.OwnerId, templateId, campaignRec.Id);
                    
                    for(Campaign_Member__c campaignMemberRec : campaignRec.Campaign_Members__r ) {
                        campaignMemberRec.Status__c = 'Executed';
                        campaignMemberListToUpdate.add(campaignMemberRec);
                    }
                    campaignRec.Child_Campaign_Status__c = 'Execution';
                    campLst.add(campaignRec);
                }
                
                else if(campaignRec.Execution_Type__c != null && campaignRec.Execution_Type__c == 'Lead' && campaignRec.Child_Campaign_Status__c == 'Segmentation') {
                    Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(campaignRec.Parent_Campaign1__r.Campaign_Type__c) ? 
                                                leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(campaignRec.Parent_Campaign1__r.Campaign_Type__c)) : null);
                    for(Campaign_Member__c campaignMemberRec : campaignRec.Campaign_Members__r ) {
                        Lead__c lead = new Lead__c();
                        lead.CAC_Lead_Status__c = 'New';
                        lead.Retail_Campaign_Name__c = campaignRec.id;
                        lead.OwnerId = campaignRec.OwnerId;
                        lead.Contact__c = campaignMemberRec.Contact_Id__c;
                        if(recTypeId != null) {
                            lead.RecordTypeId = recTypeId;
                        }
                        leadList.add(lead);
                    
                        campaignMemberRec.Status__c = 'Executed';
                        campaignMemberListToUpdate.add(campaignMemberRec);
                    }
                    campaignRec.Child_Campaign_Status__c = 'Execution';
                    campLst.add(campaignRec);
                    
                    /*String templateId = templateNameToTemplateIdMap.containsKey('Campaign Lead Assignment Notification') 
                                                    ? templateNameToTemplateIdMap.get('Campaign Lead Assignment Notification')
                                                    : templateNameToTemplateIdMap.get('Task Notification to Dealer Outlet');
                    setNotificationTemplate(campaignRec.OwnerId, templateId, campaignRec.Id);*/
                    campignIdSetForLeadType.add(campaignRec.Id);
                    
                }
            }
            
            for(Campaign_Member__c campaignMemberRec : campaignRec.Campaign_Members__r) {
                if(campaignMemberRec.Auto_creation_of_leads__c) {
                    autoCreateLeadCheckedCampaignMemberRecList.add(campaignMemberRec);
                }
            }
        }
        
        // Create Auto Lead related Queries
        Set<Id> personAccIdSet = new Set<Id>();
        Set<String> zipCodeSet = new Set<String>();
        Map<Id, Id> personAccIdToDealerAccIdMap = new Map<Id, Id>();
        Map<String, Id> zipCodeToDealerAccIdMap = new Map<String, Id>();
        
        for(Campaign_Member__c campMemberRec : autoCreateLeadCheckedCampaignMemberRecList) {
            if(campMemberRec.Preferred_Dealer__c == null && campMemberRec.Contact_Id__c != null) {
                personAccIdSet.add(campMemberRec.Contact_Id__c);
            }
            if(campMemberRec.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Finance') {
                zipCodeSet.add(campMemberRec.Zip_Code_Finance__c);
            } else {
                zipCodeSet.add(campMemberRec.Zip_Code__c);
            }
        }
        personAccIdSet.remove(null);
        zipCodeSet.remove(null);
        
        
        if(personAccIdSet.size() > 0) {
            List<Account_Link__c> accountLinkList = [select fromRole__c, toRole__c from Account_Link__c where RecordType.DeveloperName = 'ContactSector' 
                                                        AND toRole__c IN: personAccIdSet AND Status__c = 'My Shop'];
            for(Account_Link__c accLinkRec : accountLinkList) {
                personAccIdToDealerAccIdMap.put(accLinkRec.toRole__c, accLinkRec.fromRole__c);
            }                                           
        }
        
        if(zipCodeSet.size() > 0) {
            List<Dealer_Locator__c> dealerLocatorList = [select Post_Code__c, Dealer_Name__c from Dealer_Locator__c where Post_Code__c IN: zipCodeSet];
            for(Dealer_Locator__c dealerLocatorRec : dealerLocatorList) {
                zipCodeToDealerAccIdMap.put(dealerLocatorRec.Post_Code__c, dealerLocatorRec.Dealer_Name__c);
            }
        }
        
        
        for(Campaign_Member__c campMemberRec : autoCreateLeadCheckedCampaignMemberRecList) {
            Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(campMemberRec.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c) ? 
                                    leadRecTypeNameToRecTypeIdMap.get(campMemberRec.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c) : null);
            Lead__c lead = new Lead__c();
            lead.CAC_Lead_Status__c = 'New'; 
            lead.Retail_Campaign_Name__c = campMemberRec.Retail_Campaign_Id__c;
            lead.Contact__c = campMemberRec.Contact_Id__c;
            lead.Assigned_Dealer__c = getDealerIdForDealerAssignment(campMemberRec, personAccIdToDealerAccIdMap, zipCodeToDealerAccIdMap);
            lead.OwnerId = campMemberRec.Retail_Campaign_Id__r.OwnerId;
            if(recTypeId != null) {
                lead.RecordTypeId = recTypeId;
            }
            leadList.add(lead);
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
                newInsertedLeadId.add(lead.Id);
            }
            insert cLeadLst;  
        }
        
        if(campLst.size() > 0) {
            update campLst;
        }
        
        if(campaignMemberListToUpdate.size() > 0) {
            update campaignMemberListToUpdate;
        }
    }
    
    private String getDealerIdForDealerAssignment(Campaign_Member__c campaignMemberRec, Map<Id, Id> personAccIdToDealerAccIdMap, Map<String, Id> zipCodeToDealerAccIdMap) {
        String dealerId;
        if(campaignMemberRec.Preferred_Dealer__c != null) {
            dealerId = campaignMemberRec.Preferred_Dealer__c;
        } else if(campaignMemberRec.Contact_Id__c != null) {
            if(personAccIdToDealerAccIdMap.containsKey(campaignMemberRec.Contact_Id__c)) {
                dealerId = personAccIdToDealerAccIdMap.get(campaignMemberRec.Contact_Id__c);
            }
        } 
        
        if(String.isBlank(dealerId)) {
            String zipCode;
            if(campaignMemberRec.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Finance') {
                zipCode = campaignMemberRec.Zip_Code_Finance__c;
            } else {
                zipCode = campaignMemberRec.Zip_Code__c;
            }
            if(zipCode != null && zipCodeToDealerAccIdMap.containsKey(zipCode)) {
                dealerId = zipCodeToDealerAccIdMap.get(zipCode);
            }
        }
        return dealerId;
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
        List<Retail_Campaign__c> campaignList = [select OwnerId, (select Id from Leads__r where Id IN : newInsertedLeadId) from Retail_Campaign__c where Id IN: campignIdSetForLeadType];
        String templateId = templateNameToTemplateIdMap.containsKey('Campaign Lead Assignment Notification') 
                                                    ? templateNameToTemplateIdMap.get('Campaign Lead Assignment Notification')
                                                    : templateNameToTemplateIdMap.get('Task Notification to Dealer Outlet');
                                                    
        for(Retail_Campaign__c campRec : campaignList) {
            for(Lead__c leadRec : campRec.Leads__r) {
                setNotificationTemplate(campRec.OwnerId, templateId, leadRec.Id);
            }
        }
    }
    
    private List<String> getCampaignFields() {
        List<String> fieldList = new List<String> {'OwnerId',
                                                    'Owner.Email',
                                                    'Owner.Name',
                                                    'Execution_Type__c',
                                                    'Child_Campaign_Status__c',
                                                    'Execution_Start_Date__c',
                                                    'Parent_Campaign1__c',
                                                    'Campaign_Code__c',
                                                    'Parent_Campaign1__r.Campaign_Type__c',
                                                    'Dealer_Name__c', 
                                                    'Dealer_Name__r.Dealer_Sales_Manager_Email__c', 
                                                    'Dealer_Name__r.Dealer_Sales_Manager__c', 
                                                    'Dealer_Name__r.Dealer_Aftersales_Manager__c', 
                                                    'Dealer_Name__r.Dealer_Aftersales_Manager_Email__c'
                                                };
        
        return fieldList;
    }
    
    private List<String> getCampaignMemberFields() {
        List<String> fieldList = new List<String> {'OwnerId',
                                                    'Status__c',
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
                                                    'Retail_Campaign_Id__c',
                                                    'Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c',
                                                    'Zip_Code_Finance__c',
                                                    'Zip_Code__c',
                                                    'Retail_Campaign_Id__r.OwnerId'
                                                };
        
        return fieldList;
    }
     
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new RetailCampaignSchedulerAndNotificationJP());
    }
}