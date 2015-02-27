/*
    Type:       Trigger
    Purpose:    1. Auto create QC records when task.Generate QC is changed to true.
                2. Auto update task's campaign name when this task related to an campaign
                3. Auto create a SMS task record when a task insert.
    User Story: US-QC-002, US-QC-001, US-SMSS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Sinow Zhang (NTTData)  Created
    03-May-2013 Chris Huang (Breakingpoint) Update Add task fields auto update function   
    07-June-2013 Sinow Zhang (NTTData) Update Add task  ib call type field auto update function
    2014-03-04 updated by Justin Yu
*/
trigger TaskBeforeInsertUpdate on Task (before update, before insert){
    if (!UtilCustomSettings.isEnabled('TaskBeforeInsertUpdate')) {
        return;
    }
    
    String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    String WelcomeCallRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
    String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    // By Shuang Li US-smart_SSI-008---- start -- TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code
    //String SMARTSSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('smart SSI Task').getRecordTypeId();
    // By Shuang Li US-smart_SSI-008---- end
    String SMSTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    String MMSTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
    String GeneralTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId();
    List<Task> taskforGenerateQC = new List<Task>();
    List<Task> taskforGenerateSSIQC = new List<Task>();
    List<Task> newTaskWithCase = new List<Task>();
    
    // By Justin -- for replace the content merge fields
    Set<String> contactIds = new Set<String>();
    Set<String> templateIds = new Set<String>();
    Set<Id> taskOwnerIds = new Set<Id>();
    Map<Id, String> userIdNames = new Map<Id, String>();
    
    // Add By Chaos for MBDA START
    String mbdaTaskRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('MBDA Survey').getRecordTypeId();
    // This set will store all relate order ids.
    Set<Id> relatedOrderIds = new Set<Id>(); 
    List<User> assignedUsers = [select Id from User where Profile.Name = 'CAC SSI SV' and IsActive = true limit 1];
    Id assignedUserId = null;
    if(assignedUsers.size() > 0) {
        assignedUserId = assignedUsers[0].Id;
    }
    // Add By Chaos for MBDA END
    
    // Update Activity Status after new records created
    TaskTriggerHandler.taskFieldsUpdate(Trigger.new, Trigger.oldMap);
    
    if(Trigger.isInsert) {
        for(Task t : Trigger.new) {            
            // By Justin -- for replace the content merge fields
            if(t.RecordTypeId == SMSTaskRecordTypeId || t.RecordTypeId == MMSTaskRecordTypeId){
                contactIds.add(t.WhoId);
                templateIds.add(t.SMSTemplateID__c);
            }
            if(t.Subject == 'Your annual plan has been approved' || 
            t.Subject == 'Submit your annual plan needs to be adjusted to' || 
            t.Subject == 'Your project has been approved' || 
            t.Subject == 'After adjusting your project needs to resubmit' || 
            t.Subject == 'Withdraw your application as it has been approved by activity' || 
            t.Subject == 'Withdraw your application as it has been rejected by activity' || 
            t.Subject == 'Your feedback has been approved' || 
            t.Subject == 'Your feedback needs to be adjusted to resubmit' || 
            t.Subject == 'Your Toolbox application has been approved' || 
            t.Subject == 'Your Toolbox applications need to be adjusted to resubmit' || 
            t.Subject == 'Your Toolbox revocation request has been approved' || 
            t.Subject == 'Your Toolbox revocation request has been rejected' || 
            t.Subject == 'Your Toolbox feedback has been approved' || 
            t.Subject == 'You need to adjust Toolbox feedback to resubmit' || 
            t.Subject == 'Toolbox has been produced' ){
                t.RecordTypeId = GeneralTaskRecordTypeId;
            }
            // Add By Chaos for MBDA START
            if(t.Subject == 'MBDA Survey Task Temp'){
                t.Subject = 'MBDA Survey Task';
                t.RecordTypeId = mbdaTaskRecordTypeId;
                t.OwnerId = assignedUserId;
                relatedOrderIds.add(t.WhatId);
            }
            // Add By Chaos for MBDA END
        }
        // Add By Chaos for MBDA START
        List<Account> orderList = 
            [Select (Select Id From Orders), (Select Id From Contacts) 
                From Account 
                where Id in (select accountId from Order where Id in :relatedOrderIds)];
        Map<Id, Id> OrderIdContactIdMap = new Map<Id, Id>();
        
        for(Account ac : orderList){
            for(Order ord : ac.Orders){
                OrderIdContactIdMap.put(ord.Id, ac.Contacts[0].Id);
            }
        }
        
        for(Task t : Trigger.new) {  
            if(OrderIdContactIdMap.ContainsKey(t.WhatId)) {
                t.WhoId = OrderIdContactIdMap.get(t.WhatId);
            }
        }
        // Add By Chaos for MBDA END
    }
    
    if(Trigger.isUpdate) {
        for(Task t : Trigger.new) {   
            //When Generate QC is true, insert IB/OB QC records.
            if(t.Generate_QC__c && !Trigger.oldMap.get(t.Id).Generate_QC__c && t.QC_ID__c == null) {
                taskforGenerateQC.add(t);
            }
            
            //When Activity Status is Successful, insert SSI QC records.
           /*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code  
		   if(t.Activity_Status__c == 'Successful' && Trigger.oldMap.get(t.Id).Activity_Status__c != 'Successful' 
            && (t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId) && t.QC_ID__c == null) */
			
			if(t.Activity_Status__c == 'Successful' && Trigger.oldMap.get(t.Id).Activity_Status__c != 'Successful' 
            && t.RecordTypeId == SSITaskRecordTypeId && t.QC_ID__c == null) 
			{
                taskforGenerateSSIQC.add(t);
            }
            
            // By Shuang Li BRD-AS-CAC-007
			/*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
            if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId) && t.Status == 'Closed' && Trigger.oldMap.get(t.Id).Status != 'Closed')
			*/
			
			if (t.RecordTypeId == SSITaskRecordTypeId && t.Status == 'Closed' && Trigger.oldMap.get(t.Id).Status != 'Closed') 
			{
                taskOwnerIds.add(t.OwnerId);
            }
            
            // By Sinow HLD-CAC-003
			/*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
            if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == SMARTSSITaskRecordTypeId || t.RecordTypeId == OBTaskRecordTypeId || t.RecordTypeId == WelcomeCallRecordTypeId) && t.Status == 'Closed' && Trigger.oldMap.get(t.Id).Status != 'Closed') 
			*/
			
			if ((t.RecordTypeId == SSITaskRecordTypeId || t.RecordTypeId == OBTaskRecordTypeId || t.RecordTypeId == WelcomeCallRecordTypeId) && t.Status == 'Closed' && Trigger.oldMap.get(t.Id).Status != 'Closed') 
			{
                t.SentTime__c = DateTime.now();
            }
        }
    }
    
    if(taskOwnerIds.size() > 0) {
        for(User currentUser : [Select Id, Name From User Where Id in :taskOwnerIds]) {
            userIdNames.put(currentUser.Id, currentUser.Name);
        }
    }
    
    // Create QC for IB/OB
    if(taskforGenerateQC.size() > 0) {
        TaskHelper.GenerateQCs(taskforGenerateQC);
    }
    
    // Create QC for SSI
    if(taskforGenerateSSIQC.size() > 0) {
        TaskHelper.GenerateSSIQCs(taskforGenerateSSIQC);
    }

    // By Justin ---- Adds "Reply TD unsubscribe" for each SMS content
    for(Task task : Trigger.new){
        if(!Trigger.isUpdate || trigger.oldMap.get(task.Id).Activity_Status__c != 'Sent'){
            if(task.Subject == 'SMS' 
            && task.Activity_Status__c == 'Sent' 
            && !String.isBlank(task.SMS_Content__c) 
            && task.SMS_Content__c.indexOf('Reply TD unsubscribe') == -1){
                task.SMS_Content__c = task.SMS_Content__c + ' Reply TD unsubscribe';
            }
        }
        
        // By Shuang Li BRD-AS-CAC-007
		/*** TODO commented as part of kernel testing defect - Defect_10993 Validate with Sinow and delete the code 
        if (Trigger.isUpdate && (task.RecordTypeId == SSITaskRecordTypeId || task.RecordTypeId == SMARTSSITaskRecordTypeId) && task.Status == 'Closed' 
            && userIdNames.containsKey(task.OwnerId) && Trigger.oldMap.get(task.Id).Status != 'Closed') 
		*/
		
		if (Trigger.isUpdate && task.RecordTypeId == SSITaskRecordTypeId && task.Status == 'Closed' 
            && userIdNames.containsKey(task.OwnerId) && Trigger.oldMap.get(task.Id).Status != 'Closed') 
			{
            task.Executed_CSR__c = userIdNames.get(task.OwnerId);
			}
    }
    
    // By Justin --
    if(contactIds.size() > 0) {
        Map<String, Contact> contacts = new Map<String, Contact>([select Name, Account.Gender__c, SMSOptOut__c from Contact where Id in :contactIds]);
        if(!contacts.isEmpty()){
            // Prevents the sms task from saving when the SMS Opt Out of contact is checked
            TaskHelper.preventTaskFromCreating(Trigger.new, contacts);
            
            // Replaces the merge fields from templates before task saved
            TaskHelper.replaceMergeFields(Trigger.new, contacts);
        }
    }
    
    if(templateIds.size() > 0) {
        Map<String, Template__c> templates = new Map<String, Template__c>([select Type__c from Template__c where Id in :templateIds]);
        if(!templates.isEmpty()){
            // Checks the SMS Response Required field of task
            TaskHelper.checkResponseRequired(Trigger.new, templates);
        }
    }
    /**
     * 2014-3-4 added by Justin Yu -- fill in the Campaign Name based on the related to object.
     */
    Set<String> caseIds = new Set<String>();
    Set<String> campaignIds = new Set<String>();
    Set<String> campaignLeadIds = new Set<String>();
    
    for(Task task : trigger.new){
        if((Trigger.isInsert || (Trigger.isUpdate && task.WhatId != Trigger.oldMap.get(task.Id).WhatId)) && task.WhatId != null){
            String relatedId = task.WhatId;
            if(relatedId.startsWith('500')){
                caseIds.add(task.WhatId);
            }
            else if(relatedId.startsWith('701')){
                campaignIds.add(task.WhatId);
            }
            else if(relatedId.startsWith('a0c')){
                campaignLeadIds.add(task.WhatId);
            }
        }
    }
    
    if(caseIds.size() + campaignIds.size() + campaignLeadIds.size() > 0){
        TaskHelper.copyCampaignNameFromRelatedToObject(caseIds, campaignIds, campaignLeadIds, trigger.new);
    }
    if(caseIds.size() > 0){
        TaskHelper.copyIBCallTypeFromCase(caseIds, trigger.new);
    }
}