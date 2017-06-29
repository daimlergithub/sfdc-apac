/*
    Type:       Helper Class
    Purpose:    For the triggers in SMS Reply History object.
    User Story: 
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2013-11-28
    2. Justin Yu Updated on 2014-03-10
    3. Justin Yu Updated on 2014-03-21
*/
public class SMSReplyHistoryHelper{
    
    static String obTaskTypeId = Schema.SobjectType.Task.getRecordTypeInfosByName().get(UtilConstant.OB_TASK).getRecordTypeId();
    static String smsRecordTypeId = Schema.SobjectType.Task.getRecordTypeInfosByName().get(UtilConstant.SMS).getRecordTypeId();
    static String mmsRecordTypeId = Schema.SobjectType.Task.getRecordTypeInfosByName().get(UtilConstant.MMS).getRecordTypeId();
    static String smsCodeType_DownstreamSMS = 'Generate Downstream SMS';
    static String smsCodeType_DownstreamMMS = 'Generate Downstream MMS';
    static String smsCodeType_OBTask = 'Generate OB Task';
    static String smsCodeType_RegisterCampaign = 'Register Campaign';
    static User[] obCSRs = [select Id from User where Profile.Name = 'CAC OB SV' and IsActive = true limit 1];
    static Set<String> templateNames = new Set<String>{
            'IB SMS IVR Smart', '2nd IB SMS IVR smart', '1st Error IB IVR SMS smart', '2nd Error IB IVR SMS smart', 
            'IB SMS IVR MB', '2nd IB SMS IVR MB', '1st Error IB IVR SMS MB', '2nd Error IB IVR SMS MB'};
    
    public static void beforeInsertEvents(list<SMSReplyHistory__c> smsreplyHistoryNew)
    {
        Set<String> taskIds = new Set<String>();
        Set<String> templateIds = new Set<String>();
        for(SMSReplyHistory__c reply : smsreplyHistoryNew)
        {
            taskIds.add(reply.TaskID__c);
            templateIds.add(reply.Template__c);
        }
        if(templateIds!=null && !templateIds.IsEmpty())
        {
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
            Schema.DescribeSObjectResult objectId = Template__c.sObjectType.getDescribe();
            string prefix=objectId.getKeyPrefix();
            for(Template__c template : templateMap.values())
            {
                if(!String.isBlank(template.Closure_SMS__c) && template.Closure_SMS__c.trim().startsWith(prefix))
                {
                    closureMmsTemplateIds.add(template.Closure_SMS__c.trim());
                }
            }
            Map<String, Template__c> closureMmsTemplateMap = new Map<String, Template__c>();
            for(Template__c template : [select Id, Template_ID__c, Type__c from Template__c where Id in :closureMmsTemplateIds])
            {
                closureMmsTemplateMap.put(String.valueOf(template.Id).left(15), template);
            }
                            
            // Finds the related tasks and customers
            Map<String, Task> taskMap;
            taskMap = new Map<String, Task>([select Id, Subject, WhoId, WhatId, SMSTemplateID__c, OwnerId, Phone__c,
                                            SMS_Content__c, Activity_Status__c, RecordTypeId, Priority__c, Related_Task_Id__c, Campaign_Name__c, 
                                            AccountId, Account.SMSOptOut__pc, Status
                                            from Task where Id in :taskIds]);
        
            // Finds the first valid reply
            Set<String> taskIdsWithFirstValidReply = new Set<String>();
            for(SMSReplyHistory__c reply : [select TaskID__c, IsFirstValid__c from SMSReplyHistory__c where TaskID__c in:taskIds])
            {
                if(reply.isFirstValid__c)
                {
                    taskIdsWithFirstValidReply.add(reply.TaskID__c);
                }
            }
            
            /**
             * ------Section 2-------: business logics. 
             */
            // Analyzes the replies
            analyzeReply(smsreplyHistoryNew, templateMap, closureMmsTemplateMap, taskMap, taskIdsWithFirstValidReply);
        }
    }
    
    
    public static void analyzeReply(List<SMSReplyHistory__c> replies, Map<String, Template__c> templateMap, 
                                    Map<String, Template__c> closureTemplateMap, Map<String, Task> taskMap, Set<String> taskIdsWithFirstValidReply){
        
        Set<String> unsubscribedContactIds = new Set<String>();
        Map<String, SMSReplyHistory__c> contactIds = new Map<String, SMSReplyHistory__c>();
        Set<String> campaignIds = new Set<String>();
        Set<String> campaignLeadIds = new Set<String>();
        List<Task> newTasks = new List<Task>();
        Map<String, Task> newOBTaskMap = new Map<String, Task>();
        
        for(SMSReplyHistory__c reply : replies){
            system.debug('reply>>>>>'+json.serializePretty(reply));
            Template__c template = getTemplate(reply.Template__c, templateMap);
            Task task = taskMap.get(reply.TaskID__c);
            
            // Error 1. No Task
            if(task == null){
                reply.IsValid__c = false;
                continue;
            }
            
            // Error 2. No Template
            if(template == null){
                if(task.SMS_Content__c.indexOf(CaseHelper.SMS_MSG_1) == -1){
                    reply.IsValid__c = false;
                }
                continue;
            }
            
            // Error 3. No Response
            if(String.isBlank(reply.ResponseContent__c)){
                reply.IsValid__c = false;
                if(template.ErrorSMS__c != null){
                    newTasks.add(createErrorTask(task, template.ErrorSMS__r));
                }
                continue;
            }
            
            // Error 4. Not the first valid reply if the template is smart or MB template.
            if(templateNames.contains(template.Name) && taskIdsWithFirstValidReply.contains(Reply.TaskID__c)){
                SMS_Code__c code = getSMSCode(reply.ResponseContent__c, template);
                if(Code == null || (template.ValidTimeHrs__c != null
                    && reply.RespondTime__c > reply.SMSSentTime__c.addHours(Integer.valueOf(template.ValidTimeHrs__c)))){
                    reply.IsValid__c = false;
                }
                continue;
            }
            
            // 1. Checks the sms opt out in person account when the reply is "TD"(unsubscribe)
            if(reply.ResponseContent__c.startsWithIgnoreCase('TD')){
                unsubscribedContactIds.add(task.WhoId);
                continue;
            }
            
            // 2. Finds the right reply and do the next step
            SMS_Code__c code = getSMSCode(reply.ResponseContent__c, template);
            if(code != null){
                // Updates the reply in the before trigger
                reply.SMSCode__c = code.SMSCode__c;
                reply.SMSContent__c = reply.ResponseContent__c.removeStartIgnoreCase(code.SMSCode__c);
                reply.SMSContent__c = String.isBlank(reply.SMSContent__c) ? code.Description__c : reply.SMSContent__c;
                
                if(template.ValidTimeHrs__c != null && reply.RespondTime__c > reply.SMSSentTime__c.addHours(Integer.valueOf(template.ValidTimeHrs__c))){
                    reply.IsValid__c = false;
                    continue;
                }
                
                // Sends the closure sms
                if(code.SendClosureSMS__c){
                    String closureSMS = template.Closure_SMS__c.trim().left(15);
                    if(closureTemplateMap.containsKey(closureSMS)){
                        newTasks.add(createMMSTask(task, closureTemplateMap.get(closureSMS)));
                    }
                    else{
                        newTasks.add(createSMSTask(task, template.Closure_SMS__c));
                    }
                }
                
                // Does something according to the sms code type
                if(code.RecordType.Name == smsCodeType_DownstreamSMS && code.NextSMSTemplate__c != null){
                    // Creates next SMS task
                    newTasks.add(createSMSTask(task, code.NextSMSTemplate__r, false));
                }
                else if(code.RecordType.Name == smsCodeType_DownstreamMMS){
                    // Creates next MMS task
                    newTasks.add(createMMSTask(task, code.NextMMSTemplate__r));
                }
                else if(code.RecordType.Name == smsCodeType_OBTask){
                    // Creates OB task
                    newOBTaskMap.put(task.WhoId, createOBTask(task, reply, code));
                }
                else if(code.RecordType.Name == smsCodeType_RegisterCampaign){
                    // Registers campaign
                    contactIds.put(task.WhoId, reply);
                    String whatId = String.valueof(task.WhatId);
                    if(whatId.startsWith('701')){
                        campaignIds.add(whatId);
                    }
                    if(whatId.startsWith('a0c')){
                        campaignLeadIds.add(whatId);
                    }
                }
            }
            system.debug('&&&*****&&&&'+reply.SMSCode__c+'>>>>'+String.isBlank(reply.SMSCode__c));
            // 3. Finds the invalid reply and sends error sms.
            if(reply.IsValid__c && String.isBlank(reply.SMSCode__c)){
                reply.IsValid__c = false;
                reply.SMSContent__c = reply.ResponseContent__c;
                if(template.ErrorSMS__c != null){
                    newTasks.add(createErrorTask(task, template.ErrorSMS__r));
                }
            }
            
            // Added on 2014-03-21 -- determines if the reply is the first valid
            if(reply.IsValid__c && !taskIdsWithFirstValidReply.contains(Reply.TaskID__c)){
                reply.IsFirstValid__c = true;
            }
        }
        
        insert newTasks;
        
        createOBTasks(newOBTaskMap);
        unsubscribeSMS(unsubscribedContactIds);
        registerCampaign(contactIds, campaignIds, campaignLeadIds);
    }
    
    // If the template is error template, no sms codes, then finds the master template and replaces it.
   @TestVisible private static Template__c getTemplate(String templateId, Map<String, Template__c> templateMap){
        Template__c result = templateMap.get(templateId);
        if(result != null && result.SMSCodes__r.size() == 0){
            for(Template__c template : templateMap.values()){
                if(template.ErrorSMS__c == templateId){
                    return template;
                }
            }
        }
        return result;
    }
    
  @TestVisible  private static SMS_Code__c getSMSCode(String content, Template__c template){
        for(SMS_Code__c code : template.SMSCodes__r){
            if(content == code.SMSCode__c || (template.AnalyzeRequired__c && content.startsWithIgnoreCase(code.SMSCode__c))){
                return code;    
            }
        }
        return null;
    }
    
  @TestVisible  private static Task createErrorTask(Task task, Template__c errorTemplate){
        Task errorTask;
        if(errorTemplate.RecordType.Name.indexOf('SMS') != -1){
            errorTask = createSMSTask(task, errorTemplate, true);
        }
        else if(errorTemplate.RecordType.Name.indexOf('MMS') != -1){
            errorTask = createMMSTask(task, errorTemplate);
        }
        return errorTask;
    }
    
   @TestVisible private static Task createSMSTask(Task task, Template__c template, Boolean isErrorTemplate){
        Task newTask = task.clone();
        newTask.Subject = 'SMS';
        newTask.RecordTypeId = smsRecordTypeId;
        newTask.Activity_Status__c = 'Sent';
        newTask.SMSTemplateID__c = template.Id;
        newTask.SMS_Content__c = template.Message_Detail__c;
        if(isErrorTemplate && !String.isBlank(task.Related_Task_Id__c)){
            newTask.Related_Task_Id__c = task.Related_Task_Id__c;
        }
        else{
            newTask.Related_Task_Id__c = task.Id;
        }
        return newTask;
    }
    
  @TestVisible  private static Task createSMSTask(Task task, String smsContent){
        Task newTask = task.clone();
        newTask.Subject = 'SMS';
        newTask.RecordTypeId = smsRecordTypeId;
        newTask.Activity_Status__c = 'Sent';
        newTask.SMS_Content__c = smsContent;
        newTask.Related_Task_Id__c = task.Id;
        return newTask;
    }
    
  @TestVisible  private static Task createMMSTask(Task task, Template__c template){
        Task newTask = task.clone();
        newTask.Subject = 'MMS';
        newTask.RecordTypeId = mmsRecordTypeId;
        newTask.Activity_Status__c = 'Sent';
        newTask.SMSTemplateID__c = template.Id;
        newTask.eDM_Template__c = template.Template_ID__c;
        newTask.Related_Task_Id__c = task.Id;
        return newTask;
    }
    
   @TestVisible private static Task createOBTask(Task task, SMSReplyHistory__c reply, SMS_Code__c smsCode){
        Task obTask = new Task(RecordTypeId = obTaskTypeId);
        obTask.Subject = smsCode.OBTaskSubject__c;
        obTask.Related_Task_Id__c = task.Id;
        obTask.WhatId = task.WhatId;
        obTask.WhoId = task.WhoId;
        obTask.OwnerId = obCSRs.size() == 0 ? task.OwnerId : obCSRs[0].Id;
        obTask.Status = 'Open';
        obTask.Activity_Status__c = 'Not Started';
        obTask.Priority = 'High';
        obTask.ActivityDate = Date.valueOf(reply.RespondTime__c);
        obTask.ReminderDateTime = reply.RespondTime__c.addMinutes(30);
        obTask.IsReminderSet = true;
        return obTask;
    }
    
  @TestVisible  private static void createOBTasks(Map<String, Task> taskMap){
        // Don't create the repetitive OB task
        for(Task task : [select WhoId, WhatId from Task where WhoId in :taskMap.keySet() and RecordTypeId = :obTaskTypeId and Status = 'Open']){
            Task newTask = taskMap.get(task.WhoId);
            if(newTask != null && newTask.WhatId == task.WhatId){
                taskMap.remove(task.WhoId);
            }
        }
        if(!taskMap.isEmpty()){
            insert taskMap.values();
        }
    }
    
  @TestVisible  private static void unsubscribeSMS(Set<String> unsubscribedContactIds){
        if(unsubscribedContactIds.size() > 0){
            Contact[] contacts = [select SMSOptOut__c from Contact where Id in :unsubscribedContactIds];
            for(Contact c : contacts){
                c.SMSOptOut__c = true;
            }
            update contacts;
        }
    }
    
  @TestVisible  private static void registerCampaign(Map<String, SMSReplyHistory__c> contactIds, Set<String> campaignIds, Set<String> campaignLeadIds){
        campaignLeadIds.remove(null);
        campaignIds.remove(null);
        contactIds.remove(null);
        for(Campaign_Lead__c cl : [select Campaign__c from Campaign_Lead__c where Id in :campaignLeadIds]){
            campaignIds.add(cl.Campaign__c);
        }
        if(contactIds.size() > 0){
            List<CampaignMember> members = [select ContactId, Status, Registration_Date__c from CampaignMember 
                                            where CampaignId in :campaignIds and ContactId in :contactIds.keySet()];
            for(CampaignMember member : members){
                member.Status = 'Registered';
                member.Registration_Date__c = Date.valueOf(contactIds.get(member.ContactId).RespondTime__c);
            }
            update members;
        }
    }
}