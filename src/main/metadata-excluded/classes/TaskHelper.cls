/*
    Type:       Utility for TaskBeforeInsertUpdate, TaskAfterUpdate
    Purpose:    1. Auto create multiple QC records when task.QC Quantity is updated with a number.
                2. Auto create QC records when task.Generate QC is changed to true.
                3. Auto update task's campaign name when this task related to an campaign
                4. Auto create a SMS task record when a task insert.
    User Story: US-QC-015, US-QC-002, US-QC-001, US-SMSS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-28
    2. 17-July-2013 Sinow Zhang (NTTData) When a task ucid is not null, update interactionIds from Avato. US-CTI-001
*/
public class TaskHelper {
    // Get Task record type ids
    private static String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
    private static String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    private static String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    private static String smartSSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('smart SSI Task').getRecordTypeId();
    private static String SMS_TASK_RECORDTYPEID = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    
    // Get QC__c record type ids
    private static String IBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('IB QC').getRecordTypeId();
    private static String OBQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('OB QC').getRecordTypeId();
    private static String SSIQCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    private static List<QueueSobject> QCSVQueues = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'QC__c' and Queue.Name = 'SSI QC' limit 1];
    
    private static Map<String, String> srRecordTypeSubjects = new Map<String, String>{'1st Survey Result'=>'1st Survey Call', '2nd Survey Result'=>'2nd Survey Call', 'Welcome Call + 1st Survey Result'=>'Welcome Call + 1st Survey Call', 'Welcome Call Result'=>'Welcome Call'};
    
    private static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('DMLException Exception: ' + e);
        }
    }
    
    private static void insertSobjects(List<Sobject> sos) {
        try {
            insert sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('DMLException Exception: ' + e);
        }
    }
    
    /**
     * By Justin - replaces the merge fields.
     */
    public static String replaceMergeField(Contact contact, String content){
        String nameMergeField = '{CONTACT_NAME}';
        String salutationMergeField = '{CONTACT_SALUTATION}';
        
        if(contact.Name != null){
            content = content.replace(nameMergeField, contact.Name);
        }
        
        String salutation;
        if(contact.Account.Gender__c == 'Male'){
            salutation = '先生';
        }
        else if(contact.Account.Gender__c == 'Female'){
            salutation = '女士';
        }
        else{
            salutation = '阁下';
        }
        content = content.replace(salutationMergeField, salutation);
        
        return content;
    }
    
    /**
     * By Justin - replaces the merge fields from templates before task saved.
     */
    public static void replaceMergeFields(List<Task> tasks, Map<String, Contact> contacts){
        for(Task task : tasks){
            Contact contact = contacts.get(task.WhoId);
            if(task.SMS_Content__c != null && contact != null){
                task.SMS_Content__c = replaceMergeField(contact, task.SMS_Content__c);
            }
        }
    }
    
    /**
     * By Justin - Checks the SMS Response Required of task
     */
    public static void checkResponseRequired(List<Task> tasks, Map<String, Template__c> templates){
        for(Task task : tasks){
            Template__c template = templates.get(task.SMSTemplateID__c);
            if(template != null && template.Type__c == 'Upstream & Downstream'){
                task.SMS_Response_Required__c = true;
            }
        }
    }
    
    /**
     * By Justin - Prevents the sms task from saving when the SMS Opt Out of contact is checked.
     */
    public static void preventTaskFromCreating(List<Task> tasks, Map<String, Contact> contacts){
        for(Task task : tasks){
            Contact contact = contacts.get(task.WhoId);
            if(contact != null && contact.SMSOptOut__c){
                task.addError('You can not create a sms/mms task for SMS Opt Out is checked.');
            }
        }
    }
    
    public static void GenerateQCs(List<Task> updateTasks) {        
        //new qc list for insert
        List<QC__c> newQCs = new List<QC__c>();
        QC__c qc;
        
        //connect task ids which to generate qc
        Set<Id> taskIds = New Set<Id>();
        
        for(Task t : updateTasks) {   
            qc = new QC__c();
            qc.CSR_Name__c = t.OwnerId;
            qc.Status__c = 'New';
            qc.Task_ID__c = t.Id;
            if(t.recordTypeId == IBTaskRecordTypeId) {
                qc.RecordTypeId = IBQCRecordTypeId;
                newQCs.add(qc);
            }
            if(t.recordTypeId == OBTaskRecordTypeId) {
                qc.RecordTypeId = OBQCRecordTypeId;
                newQCs.add(qc);
            }
            taskIds.add(t.Id);
        }
        if(newQCs.size() > 0) {
            insertSobjects(newQCs);
        }
        UpdateQCLink(taskIds, updateTasks);
    }
    
    public static void GenerateSSIQCs(List<Task> updateTasks) {
        //new qc list for insert
        List<QC__c> newQCs = new List<QC__c>();
        QC__c qc;
        
        //connect task ids which to generate qc
        Set<Id> taskIds = New Set<Id>();
        Set<String> SRTaskIds = New Set<String>();
        
        for(Task t : updateTasks) {
            system.debug('t++++++++++' + t.id +'t++++1111'+t);
            SRTaskIds.add(String.valueOf(t.Id).subString(0, 15));
        }

        // Added by Chris Huang, 20131209, update Task_Successful__c to 'True' when QC generated.
        List<Survey_Result__c> srs = new List<Survey_Result__c>();

        for(Survey_Result__c sr : [Select id, NA_Number__c, TaskId__c, Task_Successful__c From Survey_Result__c Where TaskId__c In :SRTaskIds]) {
            for(Task t : updateTasks) {
                if(t.Id == sr.TaskId__c && (sr.NA_Number__c == null || sr.NA_Number__c < 5)) {
                    qc = new QC__c();
                    qc.CSR_Name__c = t.OwnerId;
                    qc.Status__c = 'New';
                    qc.RecordTypeId = SSIQCRecordTypeId;
                    if(t.RecordTypeId == SSITaskRecordTypeId) {
                        qc.SSI__c = t.WhatId;
                    } else {
                        qc.smart_SSI__c = t.WhatId;
                    }
                    qc.Survey_Result__c = sr.Id;
                    sr.Task_Successful__c = true;
                    srs.add(sr);
                    if(QCSVQueues.size() > 0) {
                        qc.OwnerId = QCSVQueues[0].QueueId;
                        qc.Task_ID__c = t.Id;
                        newQCs.add(qc);
                        taskIds.add(t.Id);
                    }
                } 
            }
        }

        if(newQCs.size() > 0) {
            insertSobjects(newQCs);
        }

        if (srs.size() > 0) {
            update srs;
        }

        UpdateQCLink(taskIds, updateTasks);
    }
    
    public static void GenerateMultipleQCs(List<Task> updateTasks) {
        List<QC__c> QCForInsert = new List<QC__c>();
        QC__c qc;
        for(Task t : updateTasks) {
            for(Integer i=0; i<t.QC_Quantity__c; i++) {
                qc = new QC__c();
                qc.CSR_Name__c = t.OwnerId;
                qc.Status__c = 'New';
                qc.Calibration__c = true;
                qc.Task_ID__c = t.Id;
                if(t.recordTypeId == IBTaskRecordTypeId) {
                    qc.RecordTypeId = IBQCRecordTypeId;
                    QCForInsert.add(qc);
                }
                if(t.recordTypeId == OBTaskRecordTypeId) {
                    qc.RecordTypeId = OBQCRecordTypeId;
                    QCForInsert.add(qc);
                }
            }
        }
        if(QCForInsert.size() > 0) {
            insertSobjects(QCForInsert);
        }
    }
    
    public static void copyCampaignNameFromRelatedToObject(Set<String> caseIds, Set<String> campaignIds, Set<String> campaignLeadIds, List<Task> tasks){
        Map<String, Case> cases = new Map<String, Case>();
        Map<String, Campaign> campaigns = new Map<String, Campaign>();
        Map<String, Campaign_Lead__c> campaignLeads = new Map<String, Campaign_Lead__c>();
        
        if(caseIds.size() > 0){ 
            cases = new Map<String, Case>([select Id, Campaign__r.Name from Case where Id in :caseIds]);
        }
        if(campaignIds.size() > 0){ 
            campaigns = new Map<String, Campaign>([select Id, Name from Campaign where Id in :campaignIds]);
        }
        if(campaignLeadIds.size() > 0){  
            campaignLeads = new Map<String, Campaign_Lead__c>([select Id, Campaign__r.Name from Campaign_Lead__c where Id in :campaignLeadIds]);
        }   

        for(Task task : tasks){
            String relatedId = task.WhatId;
            if(relatedId.startsWith('500')){
                task.Campaign_Name__c = cases.get(relatedId).Campaign__r.Name;
            }
            else if(relatedId.startsWith('701')){
                task.Campaign_Name__c = campaigns.get(relatedId).Name;
            }
            else if(relatedId.startsWith('a0c')){
                task.Campaign_Name__c = campaignLeads.get(relatedId).Campaign__r.Name;
            }
        }
    }
    
    public static void copyIBCallTypeFromCase(Set<String> caseIds, List<Task> tasks) {
        Map<String, Case> cases = new Map<String, Case>([select Id, RecordType.Name from Case where Id in :caseIds]);
        
        for(Task t : tasks) {
            if(cases.containsKey(t.WhatId) && t.RecordTypeId == IBTaskRecordTypeId && t.CallType == 'Inbound') {
                t.IB_Call_Type__c = cases.get(t.WhatId).RecordType.Name;
            }
        }
    }
    
    private static void UpdateQCLink(Set<Id> taskIds, List<Task> tasks) {
        //map task id and new generate qc id
        Map<Id, Id> taskIdqcIdMap = new Map<Id, Id>();
        
        taskIds.remove(null);
        for(QC__c newQc : [select Id, Task_ID__c from QC__c where Task_ID__c in :taskIds and Task_ID__c != null and Task_ID__c != '' 
                           and (RecordTypeId = :IBQCRecordTypeId or RecordTypeId = :OBQCRecordTypeId or RecordTypeId = :SSIQCRecordTypeId) 
                           and CreatedDate > :Date.Today().addDays(-30) limit 10000]) {
            taskIdqcIdMap.put(newQc.Task_ID__c, newQc.Id);
        }
            
        for(Task t : tasks) {
            if(taskIdqcIdMap.containsKey(t.Id)) {
                t.QC_ID__c = taskIdqcIdMap.get(t.Id);
            }
        }
    }
    
    // Creat new SMS Task 
    // --- Modified by Justin on 2013-12-10
    public static void createSMSTaskAfterIBCall(List<Task> tasks) {
        Template__c ivrTemplates = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR'];
        Template__c smartTemplate = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR Smart'];
        Template__c mbTemplate = [select Message_Detail__c from Template__c where RecordType.Name = 'SMS' and Name = 'IB SMS IVR MB'];
        
        Set<String> contactIds = new Set<String>();
        for(Task t : tasks) {
            contactIds.add(t.WhoId);
        }
        Map<ID, Contact> contacts = new Map<ID, Contact>([select SMSOptOut__c from Contact where Id in :contactIds]); 
         
        List<task> smsTasks = new List<Task>();      
        for(Task t : tasks) {
            Contact contact = contacts.get(t.WhoId);
            if(contact != null && contacts.get(t.WhoId).SMSOptOut__c){
                continue;
            }
            Task smsTask = new Task();
            smsTask.Subject = 'SMS'; 
            smsTask.Status = 'Closed';    
            smsTask.Activity_Status__c = 'Sent';      
            smsTask.RecordTypeId = SMS_TASK_RECORDTYPEID;
            smsTask.Related_Task_Id__c = t.Id;
            smsTask.WhatId = t.WhatId;
            smsTask.WhoId = t.WhoId;
            smsTask.OwnerId = t.OwnerId;
            smsTask.IB_Status__c = t.IB_Status__c;
            smsTask.Phone__c = t.Phone__c;
            if(t.Called__c == '4291'){
                smsTask.SMSTemplateID__c = smartTemplate.Id;
                smsTask.SMS_Content__c = smartTemplate.Message_Detail__c;
            }
            else if(t.Called__c == '4290' || t.Called__c == '4292'){
                smsTask.SMSTemplateID__c = mbTemplate.Id;
                smsTask.SMS_Content__c = mbTemplate.Message_Detail__c;
            }
            else{
                smsTask.SMSTemplateID__c = ivrTemplates.Id;
                smsTask.SMS_Content__c = ivrTemplates.Message_Detail__c;
            }
            smsTasks.add(smsTask);
        }
        
        if(smsTasks.size() > 0) {
            insertSobjects(smsTasks);
        }
    }
    
    public static void UpdateCaseVoiceRecordlink(Map<Id, String> caseIdInteractionIds) {
        List<Case> caseForUpdate = new List<Case>();
        
        List<App_Setting__c> appSettings = [select Name, Value__c from App_Setting__c where Name = 'Voice Recording Location'];
    
        for(Case c : [select Id, Voice_Record_Link__c from Case where Id in :caseIdInteractionIds.keySet()]) {
            if((c.Voice_Record_Link__c != null || c.Voice_Record_Link__c != '') && appSettings.size() == 1) {
                c.Voice_Record_Link__c = appSettings[0].Value__c + caseIdInteractionIds.get(c.Id);
                caseForUpdate.add(c);
            }
        }
        
        if(caseForUpdate.size() > 0) {
            updateSobjects(caseForUpdate);
        }
    }
    
    //US-CTI-001
    @Future(CallOut=True)
    public static void updateInteractionIds(Map<Id, String> taskIdUCIds) {
        List<Task> tasks = new List<Task>();
        for(Task t : [select Id, CreatedDate, InteractionIds__c from Task where Id in :taskIdUCIds.keySet()]) {
            t.InteractionIds__c = AvatoHelper.getInteractionIds( taskIdUCIds.get(t.Id), t.CreatedDate);
            tasks.add(t);
        }
        
        if(tasks.size() > 0) {
            updateSobjects(tasks);
        }
    }
    // By Shuang Li BRD-AS-CAC-007---- strart
    @future(CallOut=True)
    public static void autoUpdateSSITask(Set<Id> userIds){
        Profile CACSSISV = [select Id from Profile where Name = 'CAC SSI SV'];
        Id SSITaskRTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        List<Task> taskSSI = [SELECT ownerId FROM Task WHERE ownerId in :userIds AND RecordTypeId= :SSITaskRTId];
        Id SMARTSSITaskRTId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('smart SSI Task').getRecordTypeId();
        List<Task> taskSmartSSI = [SELECT ownerId FROM Task WHERE ownerId in :userIds AND RecordTypeId= :SMARTSSITaskRTId];
        if(taskSSI.size() > 0){
            User ssiSvUser = [Select id From User Where ProfileId = :CACSSISV.id and IsActive = true limit 1];
            for(Task tk : taskSSI){
                tk.ownerId = ssiSvUser.id;
            }
            try {
                    update taskSSI;
                }
                catch (DMLException e) {
                    trigger.new[0].addError(e.getDMLMessage(0));
                    System.debug('DMLException Exception: ' + e);
                }
       }
       if(taskSmartSSI.size() > 0){
            User ssiSvUser = [Select id From User Where ProfileId = :CACSSISV.id and IsActive = true limit 1];
            for(Task tk : taskSmartSSI){
                tk.ownerId = ssiSvUser.id;
            }
            try {
                    update taskSmartSSI;
                }
                catch (DMLException e) {
                    trigger.new[0].addError(e.getDMLMessage(0));
                    System.debug('DMLException Exception: ' + e);
                }
       }
    }
    // By Shuang Li BRD-AS-CAC-007---- end
}