/*
    Type:       Trigger on SMS Replay History
    Purpose:    Send next SMS according to the user reply.
    User Story: 
    ---------------------------------------------------------------
    History:
    
    1. Justin Created on 2013-11-28
    2. Justin Updated on 2014-03-21
*/
trigger TriggerSMSReplyHistoryBeforeInsert on SMSReplyHistory__c (before insert) {
    
    /**
     * ------Section 1-------: lookup the related records 
     */
    Set<String> taskIds = new Set<String>();
    Set<String> templateIds = new Set<String>();
    
    for(SMSReplyHistory__c reply : Trigger.new){
		taskIds.add(reply.TaskID__c);
    	templateIds.add(reply.Template__c);
    }
    
    // Finds the templates
    Map<String, Template__c> templateMap;
    templateMap = new Map<String, Template__c>([select Name, AnalyzeRequired__c, ValidTimeHrs__c, Message_Detail__c, Template_ID__c,
    											Closure_SMS__c, 
    											ErrorSMS__c, ErrorSMS__r.Id, ErrorSMS__r.Message_Detail__c, ErrorSMS__r.Template_ID__c,
    											ErrorSMS__r.RecordType.Name,
                   								(select SMSCode__c, Description__c, OBTaskSubject__c, SendClosureSMS__c, RecordType.Name, 
                   								NextMMSTemplate__c, NextMMSTemplate__r.Template_ID__c, NextMMSTemplate__r.Type__c,
                   								NextSMSTemplate__c, NextSMSTemplate__r.Message_Detail__c
							                    from SMSCodes__r order by SMSCode__c) 
							                    from Template__c where Id in :templateIds or ErrorSMS__c in :templateIds]);
    
    // Finds the closure mms template and Smart Template
    Set<String> closureMmsTemplateIds = new Set<String>();
    for(Template__c template : templateMap.values()){
    	if(!String.isBlank(template.Closure_SMS__c) && template.Closure_SMS__c.trim().startsWith('a1S')){
    		closureMmsTemplateIds.add(template.Closure_SMS__c.trim());
    	}
    }
    Map<String, Template__c> closureMmsTemplateMap = new Map<String, Template__c>();
    for(Template__c template : [select Id, Template_ID__c, Type__c from Template__c where Id in :closureMmsTemplateIds]){
    	closureMmsTemplateMap.put(String.valueOf(template.Id).left(15), template);
    }
                    
    // Finds the related tasks and customers
    Map<String, Task> taskMap;
    taskMap = new Map<String, Task>([select Id, Subject, WhoId, WhatId, SMSTemplateID__c, SMS_Response_Required__c, OwnerId, Phone__c,
    								SMS_Content__c, Activity_Status__c, RecordTypeId, Priority__c, Related_Task_Id__c, Campaign_Name__c, 
    								AccountId, Account.SMSOptOut__pc, Status
    								from Task where Id in :taskIds]);

    // Finds the first valid reply
    Set<String> taskIdsWithFirstValidReply = new Set<String>();
    for(SMSReplyHistory__c reply : [select TaskID__c, IsFirstValid__c from SMSReplyHistory__c where TaskID__c in:taskIds]){
    	if(reply.isFirstValid__c){
    		taskIdsWithFirstValidReply.add(reply.TaskID__c);
    	}
    }
    
    /**
     * ------Section 2-------: business logics. 
     */
    // Analyzes the replies
    SMSReplyHistoryHelper.analyzeReply(Trigger.new, templateMap, closureMmsTemplateMap, taskMap, taskIdsWithFirstValidReply);
}