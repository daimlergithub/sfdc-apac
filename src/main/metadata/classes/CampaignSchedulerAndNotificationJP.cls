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
        /*query += '( SELECT ';
        for(String fieldName : getCampaignMemberFields()) {
            query += fieldName + ', ';
        }
        query = query.substring(0, query.length() - 2);
        query += ' FROM Campaign_Members1__r) ';*/
        
        query = query.substring(0, query.length() - 2);
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
        List<DM_Request__c> dmRequestList = New List<DM_Request__c>(); 
                Map<id,Campaign_Member__c>pMap = new Map<id,Campaign_Member__c>();
        Map<id,Account>pConMap = new Map<id,Account>();

        notificationWrapperList = new List<NotificationWrapper>();
        List<Campaign_Member__c> autoCreateLeadCheckedCampaignMemberRecList = new List<Campaign_Member__c>();
         
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
        
        
        // Create map to store Child Campign Members - To Avoid Invalid Query Locator 
        Set<Id> campaignIdSet = new Set<Id>();
        Map<Id, List<Campaign_Member__c>> campaignIdToCampaignMemberListMap =  new Map<Id, List<Campaign_Member__c>>();
         list<account>pList   = [select id,recordtypeid,personcontactid from account where id in:pMap.keyset()];
         for(account a:pList)
         {
         system.debug('+++++++++++++++'+pList );
         
         {
              pConMap.put(a.id,a);
              }
          
          }
        for(Campaign camp : scope) {
            campaignIdSet.add(camp.Id);
        }
        String query = 'SELECT ';
        for(String fieldName : getCampaignMemberFields()) {
            query += fieldName + ', ';
        }
        query = query.substring(0, query.length() - 2);
        query += ' FROM Campaign_Member__c WHERE Campaign_ID__c IN : campaignIdSet LIMIT 3000';
        List<Campaign_Member__c> campaignMemberList = Database.Query(query);
        for(Campaign_Member__c campMemberRec : campaignMemberList) {
            if(!campaignIdToCampaignMemberListMap.containsKey(campMemberRec.Campaign_ID__c)) {
                campaignIdToCampaignMemberListMap.put(campMemberRec.Campaign_ID__c, new List<Campaign_Member__c>());
            }
            campaignIdToCampaignMemberListMap.get(campMemberRec.Campaign_ID__c).add(campMemberRec);
        }
        
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
                    if(campaignIdToCampaignMemberListMap.containsKey(camp.Id)) {
                        for(Campaign_Member__c campaignMemberRec : campaignIdToCampaignMemberListMap.get(camp.Id)) {
                            Lead__c lead = new Lead__c();
                            lead.CAC_Lead_Status__c = 'Approved'; 
                            lead.Source_Campaign__c = camp.id;
                            lead.Contact__c = campaignMemberRec.Contact_Id__c;
                            lead.Assigned_Dealer__c =campaignMemberRec.Preferred_Dealer__c;
                            lead.Lead_Type__c = campaignMemberRec.Lead_Type__c;
                            lead.Lead_Sub_Type__c = campaignMemberRec.Lead_Sub_Type__c;
                            lead.Existing_Contract__c=campaignMemberRec.Contract__c;
                            lead.Interested_Vehicle_Model__c = campaignMemberRec.Interested_Model__c;
                            lead.Assigned_Dealer__c=campaignMemberRec.Preferred_Dealer__c;
                            lead.Finance_Product_Name__c=campaignMemberRec.Finance_Product__c;
                            lead.Finance_Contract_Term__c=campaignMemberRec.Term__c;
        lead.Finance_Monthly_Payment__c=campaignMemberRec.Monthly_Payment__c;
        lead.Finance_Interest_Rate__c=campaignMemberRec.Interest_Rate__c;
        lead.Finance_RV_Ballon__c=campaignMemberRec.RV_Ballon__c;
        lead.Finance_Total_V_Price_NoTax__c=campaignMemberRec.Total_Vehicle_Price_without_tax__c;
        lead.Finance_Total_V_Price_Tax__c=campaignMemberRec.Total_Vehicle_Price_with_tax__c;
        lead.Purchase_Time__c=campaignMemberRec.Purchase_Timing__c;
        lead.Lead_Desired_Service__c=campaignMemberRec.Lead_Desired_Service__c;
        
        lead.Lead_DataSource__c='Campaign';
        lead.UsVIN__c=campaignMemberRec.UsVIN__c;
        if(camp.Parent.Campaign_Type__c == 'After Sales'){
        
           lead.AfterSales_Vehicle__c=campaignMemberRec.Vehicle__c;
        
        }
        if(camp.Parent.Campaign_Type__c == 'Sales' || camp.Parent.Campaign_Type__c == 'Finance')
        {
           lead.Trade_In_Vehicle__c=campaignMemberRec.Vehicle__c;
        }
        if(camp.Parent.Campaign_Type__c  == 'Finance')
        {
          lead.Cross_Point_Model__c=campaignMemberRec.Cross_Point_Model__c;
          
        }
                            
                            
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
                }
                 
                else if(camp.Execution_Type__c == 'OB Call' && camp.Child_Campaign_Status__c == 'Segmentation'){
                     
                    if(camp.Campaign_CCC_Manager__c != null){
                        setNotificationTemplate(camp.Campaign_CCC_Manager__c , templateNameToTemplateIdMap.get('Task Notification'), camp.Id);
                    }
                    
                    if(campaignIdToCampaignMemberListMap.containsKey(camp.Id)) { 
                        for(Campaign_Member__c campaignMemberRec : campaignIdToCampaignMemberListMap.get(camp.Id)) {
                            Task task = new Task();
                            task.WhatID = camp.Id;
                            task.Status = 'Open';
                            task.Type = 'Campaign';
                            task.subject = 'Campaign Executed';
                            task.ownerId = camp.Campaign_CCC_Manager__c;
                            task.priority = 'Normal';
                            task.RecordTypeId = taskRecTypeId;
                            task.ActivityDate = camp.Execution_Start_Date__c;
                            task.Whatid = campaignMemberRec.Campaign_Id__c ;
                         task.whoid = pConMap.get(campaignMemberRec.Contact_Id__c).personcontactid;
                            task.Contract__c = campaignMemberRec.Contract__c ;
                            task.Related_Vehicle__c= campaignMemberRec.Vehicle__c;
                            task.Account_Name__c =campaignMemberRec.Company_Name__c;
                            task.Phone__c = campaignMemberRec.Contract_Phone1_1__c;
                            task.Phone_number__c= campaignMemberRec.Contract_Phone2_2__c;
                            task.Campaign_Member_ID__c = campaignMemberRec.Name;
                            tskLst.add(task);
                            
                            campaignMemberRec.Status__c = 'Executed';
                            campMemberLst.add(campaignMemberRec);
                        }
                        camp.Child_Campaign_Status__c = 'Execution';
                        campLst.add(camp);
                    }
                }
                else if (camp.Execution_Type__c == 'eMail' || camp.Execution_Type__c == 'DM'){
                    if(campaignIdToCampaignMemberListMap.containsKey(camp.Id)){
                        for(Campaign_Member__c campaignMemberRec : campaignIdToCampaignMemberListMap.get(camp.Id)){
                            campaignMemberRec.Status__c = 'Executed';
                            campMemberLst.add(campaignMemberRec);
                        }
                    }
                }
            }
            
            if(campaignIdToCampaignMemberListMap.containsKey(camp.Id)) {
                for(Campaign_Member__c campaignMemberRec : campaignIdToCampaignMemberListMap.get(camp.Id)) {
                    if(campaignMemberRec.Auto_creation_of_tasks__c) {
                        Task task = new Task();
                        task.WhatID = camp.Id;
                        task.Status = 'Open';
                        task.Type = 'Campaign';
                        task.subject = 'Campaign Auto Creation';
                        task.ownerId = camp.Campaign_CCC_Manager__c;
                        task.priority = 'Normal';
                        task.RecordTypeId = taskRecTypeId;
                        task.ActivityDate = camp.Execution_Start_Date__c;
                        task.Campaign_Name__c = camp.Campaign_Code__c;
                        task.Whatid = campaignMemberRec.Campaign_Id__c ;
                      task.whoid = pConMap.get(campaignMemberRec.Contact_Id__c).personcontactid;
                        task.Contract__c = campaignMemberRec.Contract__c ;
                        task.Related_Vehicle__c= campaignMemberRec.Vehicle__c;
                        task.Account_Name__c =campaignMemberRec.Company_Name__c;
                        task.Phone__c = campaignMemberRec.Contract_Phone1_1__c;
                        task.Phone_number__c= campaignMemberRec.Contract_Phone2_2__c;
                        task.Campaign_Member_ID__c = campaignMemberRec.Name;
                        //tskLst.add(task);
                    }
                    
                    if(campaignMemberRec.Auto_creation_of_DM_requests__c) {
                        DM_Request__c dmRequestRec = New DM_Request__c ();
                        dmRequestRec.Customer_Name__c = campaignMemberRec.Contact_Id__c;
                        if(campaignMemberRec.Address__r != null) {
                            dmRequestRec.Sending_Address__c = campaignMemberRec.Address__r.Address_Type__c;
                        }
                        dmRequestRec.TitleOfHonor__c = 'To person';
                        dmRequestRec.Channel__c = 'Campaign';
                        dmRequestRec.Campaign__c = camp.Id;
                        //dmRequestList.add(dmRequestRec);
                    }
                    
                    if(campaignMemberRec.Auto_creation_of_leads__c) {
                        autoCreateLeadCheckedCampaignMemberRecList.add(campaignMemberRec);
                    }
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
            if(campMemberRec.Campaign_ID__r.Parent.Campaign_Type__c == 'Finance') {
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
            Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(campMemberRec.Campaign_ID__r.Parent.Campaign_Type__c) ? 
                                    leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(campMemberRec.Campaign_ID__r.Parent.Campaign_Type__c)) : null);
            Lead__c lead = new Lead__c();
            lead.CAC_Lead_Status__c = 'Approved'; 
            lead.Source_Campaign__c = campMemberRec.Campaign_ID__c;
            lead.Contact__c = campMemberRec.Contact_Id__c;
            lead.Assigned_Dealer__c = getDealerIdForDealerAssignment(campMemberRec, personAccIdToDealerAccIdMap, zipCodeToDealerAccIdMap);
            lead.OwnerId = campMemberRec.Campaign_ID__r.OwnerId;
            
        
        
        
            if(recTypeId != null) {
                lead.RecordTypeId = recTypeId;
            }
            //leadLst.add(lead);
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
        if(campMemberLst.size() > 0) {
            update campMemberLst;
        }
        
        if(dmRequestList.size() > 0) {
            insert dmRequestList;
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
            if(campaignMemberRec.Campaign_ID__r.Parent.Campaign_Type__c == 'Finance') {
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
                                                    'Campaign_ID__r.OwnerId',
                                                    'Company_Name__c',
                                                    'Contract__c',
                                                    'Contract_Phone1_1__c',
                                                    'Contract_Phone2_2__c',
                                                    'Name',
                                                    'Vehicle__c',
                                                    'Lead_Type__c',
                                                    'Lead_Sub_Type__c',
                                                    'Interested_Model__c',
                                                    'Finance_Product__c',
                                                    'Term__c',
                                                    'Monthly_Payment__c',
                                                    'Interest_Rate__c',
                                                    'RV_Ballon__c',
                                                    'Total_Vehicle_Price_without_tax__c',
                                                    'Total_Vehicle_Price_with_tax__c',
                                                    'Purchase_Timing__c',
                                                    'Lead_Desired_Service__c',
                                                    'UsVIN__c',
                                                    'Cross_Point_Model__c'
                                                  
                                                    
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
        Database.executeBatch(new CampaignSchedulerAndNotificationJP(), 1);
    }
}