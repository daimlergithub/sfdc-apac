trigger SendMessageToCustomerAndInstructor on Lead__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('SendMessageToCustomerAndInstructor')) {
        return;
    }
    
    String mbdaLeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MBDA Leads').getRecordTypeId();
    String SMSTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    
    Set<Id> relatedContactIds = new Set<Id>();
    Set<Id> relatedUserIds = new Set<Id>();
    set<Id> dealerIds = new Set<Id>();
    List<Lead__c> mbdaLeads = new List<Lead__c>(); 
    if(trigger.isInsert) {
        for(Lead__c tempLead : trigger.new) {
            if(tempLead.RecordTypeId == mbdaLeadRecordTypeId && (tempLead.Need_Contact__c == true || tempLead.Visit_Dealer__c == true)) {
                relatedContactIds.add(tempLead.Contact__c);
                relatedUserIds.add(tempLead.Instructor__c);
                dealerIds.add(tempLead.Recommended_Dealer__c);
                mbdaLeads.add(tempLead);
            }
        }
    }
    if(trigger.isUpdate) {
        for(Lead__c tempLead : trigger.new) {
           if(tempLead.RecordTypeId == mbdaLeadRecordTypeId && (tempLead.Need_Contact__c == true && tempLead.Need_Contact__c != trigger.oldMap.get(tempLead.Id).Need_Contact__c) || (tempLead.Visit_Dealer__c == true && tempLead.Visit_Dealer__c != trigger.oldMap.get(tempLead.Id).Visit_Dealer__c)) {
               relatedContactIds.add(tempLead.Contact__c);
               relatedUserIds.add(tempLead.Instructor__c);
               dealerIds.add(tempLead.Recommended_Dealer__c);
               mbdaLeads.add(tempLead);
           }
        }
    }
    
    if(mbdaLeads.size() > 0) {
        Map<Id, User> instructors = new Map<Id, User>([select Id, Name, MobilePhone, ContactId from User where Id in :relatedUserIds]);
        Map<Id, Account> customers = new Map<Id, Account>([select Id, PersonContactId, Name, PersonMobilePhone from Account where Id in :relatedContactIds and IsPersonAccount = true]);
        Map<Id, Account> dealers = new Map<Id, Account>([select Id, Name, Dealer_Address_CN__c from Account where Id in :dealerIds]);
        User integrationUser = getEPIntegrationUser();
        
        List<Task> newSMSTasks = new List<Task>();
        for(Lead__c tempLead : mbdaLeads) {
            // For customer
            if(tempLead.Visit_Dealer__c) {  
                //Lead_Follow_Up_To_Customer_With_Dealer
                newSMSTasks.add(createdNewSMSTaskForCustomer(tempLead, integrationUser, customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c), 'Lead_Follow_Up_To_Customer_With_Dealer'));
            }
            else if(tempLead.Need_Contact__c) {  
                //Lead_Follow_Up_To_Customer_Without_Dealer
                newSMSTasks.add(createdNewSMSTaskForCustomer(tempLead, integrationUser, customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c), 'Lead_Follow_Up_To_Customer_Without_Dealer'));
            }
            // For Instructor
            if(tempLead.Need_Contact__c)
            {  
                //Lead_Follow_Up_To_Instructor
                newSMSTasks.add(createdNewSMSTaskForInstructor(tempLead, integrationUser, instructors.get(tempLead.Instructor__c), customers.get(tempLead.Contact__c), dealers.get(tempLead.Recommended_Dealer__c)));
            }
        }
        insert newSMSTasks;
    }
    
    private Task createdNewSMSTaskForInstructor(Lead__c tempLead, User  tempIntegrationUser, User tempInstructor, Account tempAccount, Account tempDealer) {
        Task newTask = new Task(RecordTypeId = SMSTaskRecordTypeId, Subject = 'SMS', Status = 'Closed', Activity_Status__c = 'Sent');
        newTask.SMS_Content__c = getSMSContentByTitle(tempLead, tempAccount, tempInstructor, tempDealer, 'Lead_Follow_Up_To_Instructor'); //Interested_Vehicle_Class__c
        newTask.OwnerId = tempIntegrationUser.Id;
        if(tempInstructor != null) {
            newTask.Phone__c = tempInstructor.MobilePhone;//tempLead.Referal_Referee_PhoneNumber__c;
            newTask.WhoId = tempInstructor.ContactId; // PersonContactId;
        }
        newTask.WhatId = tempLead.Id;
        return newTask;
    }
    
    private Task createdNewSMSTaskForCustomer(Lead__c tempLead, User  tempIntegrationUser, Account tempCustomer, Account tempDealer, String tempTitle) {
        Task newTask = new Task(RecordTypeId = SMSTaskRecordTypeId, Subject = 'SMS', Status = 'Closed', Activity_Status__c = 'Sent');
        newTask.SMS_Content__c = getSMSContentByTitle(tempLead, tempCustomer, tempIntegrationUser, tempDealer, tempTitle); //Interested_Vehicle_Class__c
        newTask.OwnerId = tempIntegrationUser.Id;
        if(tempCustomer != null) {
            newTask.Phone__c = tempCustomer.PersonMobilePhone;//tempLead.Referal_Referee_PhoneNumber__c;
            newTask.WhoId = tempCustomer.PersonContactId;
        }
        newTask.WhatId = tempLead.Id;
        
        return newTask;
    }
    
    private String getSMSContentByTitle(Lead__c tempLead, Account tempCustomer, User tempInstructor, Account tempDealer, String tempTitle) {
        String result = '';
        result = ReservationMessageTemplate.getSMSContent(tempLead, tempCustomer, tempInstructor, tempDealer, tempTitle);
        return result;
    }
    
    private User getEPIntegrationUser() {
        User epUser;
        List<User> epUsers = [select Id, Name from User where Name = 'ep.user1' and Profile.Name = 'IntegrationAPI' and IsActive = true limit 1];
        if(epUsers.size() > 0)
        {
            epUser = epUsers[0];
        }
        return epUser;
    }
    //getSMSContent(Lead tempLead, Account tempCustomer, User tempInstructor, String templateTitle)
}