/*
    Type:       Test class
    Purpose:    Test the SMSReplyHistoryHelper class and the TriggerSMSReplyHistoryBeforeInsert trigger
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Justin Created on 2013-12-05
*/
@isTest public class SMSReplyHistoryHelperTest{
    
    private static SMSReplyHistory__c objSrh;
    private static list<SMSReplyHistory__c> lstSrh=new list<SMSReplyHistory__c>();
    private static Task objTask;
    private static id SMS_REC_ID=Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static id ERROR_REC_ID=Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Children SMS Template').getRecordTypeId();
    private static id ERROR_REC_ID_MMS=Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Children MMS Template').getRecordTypeId();
    private static id smsRecordTypeId = Schema.SObjectType.SMS_Code__c.getRecordTypeInfosByName().get('Generate Downstream SMS').getRecordTypeId();
    private static Template__c objTemp;
    private static Template__c objTempSMS;
    private static Template__c objTempError;
    private static SMS_Code__c objSC;
    private static Template__c objTempErrorMMS;
    /*@isTest public static void testTriggerSMSReplyHistoryBeforeInsert(){
        Template__c template = getTemplate();
        
        Template__c errorTemplate = template.clone();
        errorTemplate.RecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Children SMS Template').getRecordTypeId();
        errorTemplate.Message_Detail__c = 'Error template';
        insert errorTemplate;
        
        Template__c ibCSRTemplate = template.clone();
        ibCSRTemplate.Name = 'IB SMS IVR';
        ibCSRTemplate.ErrorSMS__c = errorTemplate.Id;
        insert ibCSRTemplate;
        
        createSMSCode(ibCSRTemplate, errorTemplate);
        
        Task task = getSMSTask();
        task.SMSTemplateID__c = ibcSRTemplate.Id;
        insert task;
        
        Test.startTest();
        SMSReplyHistory__c reply = new SMSReplyHistory__c(
            RespondTime__c = System.now(),
            IsValid__c = true,
            ResponseContent__c = '1',
            SMSSentTime__c = System.now(),
            TaskID__c = task.Id,
            Template__c = ibCSRTemplate.Id
        );
        insert reply;
        Test.stopTest();
        system.assertEquals(task.SMSTemplateID__c,ibcSRTemplate.Id);
        system.assertEquals(reply.Template__c,ibCSRTemplate.Id);
        system.assertEquals(ibCSRTemplate.ErrorSMS__c,errorTemplate.Id);      
        system.assertEquals(errorTemplate.RecordTypeId,Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('Children SMS Template').getRecordTypeId());        
        system.assert(task!=Null);
        system.assert(getSMSTask()!=Null);
        system.assert(getTemplate()!=Null);
      
    }
    
    private static Template__c getTemplate()
    {
        Template__c template = new Template__c(
            Active__c = true,
            AnalyzeRequired__c = true,
            Closure_SMS__c = 'a1S',
            Message_Detail__c = 'standard template',
            Subject__c = 'Standard',
            Type__c = 'Upstream & Downstream',
            ValidTimeHrs__c = 24
        );
        return template;
    }
    
    private static Task getSMSTask()
    {
        Task task = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId(),
            Subject = 'SMS',
            Status = 'Closed',
            Activity_Status__c = 'Sent',
            Priority__c = 'General',
            Phone__c = '12100001111'
        );
        return task;
    }
    
    private static void createSMSCode(Template__c template, Template__c nextTemplate)
    {
        String smsRecordTypeId = Schema.SObjectType.SMS_Code__c.getRecordTypeInfosByName().get('Generate Downstream SMS').getRecordTypeId();
        String obTaskRecordTypeId = Schema.SObjectType.SMS_Code__c.getRecordTypeInfosByName().get('Generate OB Task').getRecordTypeId();
        String campaignRecordTypeId = Schema.SObjectType.SMS_Code__c.getRecordTypeInfosByName().get('Register Campaign').getRecordTypeId();
        
        SMS_Code__c smsCode = new SMS_Code__c(Template__c = template.Id, RecordTypeId = smsRecordTypeId);
        SMS_Code__c smsCode1 = smsCode.clone();
        smsCode1.SMSCode__c = '1';
        smsCode1.Description__c = '1.Satisfaction';
        smsCode1.SendClosureSMS__c = true;
        insert smsCode1;
        SMS_Code__c smsCode2 = smsCode.clone();
        smsCode2.SMSCode__c = '2';
        smsCode2.Description__c = '2.Not satisfied';
        smsCode1.SendClosureSMS__c = false;
        smsCode2.NextSMSTemplate__c = nextTemplate == null ? null : nextTemplate.Id;
        insert smsCode2;
    }*/
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert()
    {
    	Test.startTest();
    	createTemplate_Closure_SMS();
    	createTemplate_Error_SMS();
    	createTemplate(objTempError.Id);
    	createTask();
    	SMSReplyHistory__c obj=createSMSReplyHistory();
    	obj.ResponseContent__c='MS';
    	insert obj;
    	Test.stopTest();
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL()
    {
    	Test.startTest();
    	createTemplate_Closure_SMS();
    	createTemplate_Error_SMS();
    	createTemplate(objTempError.Id);
    	createSMSCode();
    	createTask();
    	SMSReplyHistory__c obj=createSMSReplyHistory();
    	obj.Template__c=null;
    	insert obj;
    	Test.stopTest();
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL1()
    {
    	Test.startTest();
    	createTemplate_Closure_SMS();
    	createTemplate_Error_SMS();
    	createTemplate(objTempError.Id);
    	createSMSCode();
    	createTask();
    	SMSReplyHistory__c obj=createSMSReplyHistory();
    	obj.TaskID__c='testtstt';
    	insert obj;
    	Test.stopTest();
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL2()
    {
    	Test.startTest();
    	createTemplate_Closure_SMS();
    	createTemplate_Error_MMS();
    	createTemplate(objTempErrorMMS.Id);
    	createSMSCode();
    	createTask();
    	SMSReplyHistory__c obj=createSMSReplyHistory();
    	obj.TaskID__c='testtstt';
    	insert obj;
    	Test.stopTest();
    }
    
    static SMSReplyHistory__c createSMSReplyHistory()
    {
    	objSrh = new SMSReplyHistory__c();
        objSrh.RespondTime__c = System.now();
        objSrh.IsValid__c = true;
        objSrh.IsFirstValid__c=true;
        objSrh.ResponseContent__c = ' ';
        objSrh.SMSSentTime__c = System.now();
        objSrh.TaskID__c = objTask.Id;
        objSrh.Template__c = objTemp.Id;
        objSrh.SMSCode__c=' ';
        return  objSrh;
    }
    
    static void createTask()
    {
    	objTask = new Task();
        objTask.RecordTypeId = SMS_REC_ID;
        objTask.Subject = 'SMS';
        objTask.Status = 'Closed';
        objTask.Activity_Status__c = 'Sent';
        objTask.Priority__c = 'General';
        objTask.Phone__c = '12100001111';
        objTask.SMS_Content__c='test';
        insert objTask;
    }
    
    static void createTemplate(id tempid)
    {
        objTemp = new Template__c();
        objTemp.Active__c = true;
        objTemp.AnalyzeRequired__c = true;
        objTemp.Closure_SMS__c = objTempSMS.Id;
        objTemp.Message_Detail__c = 'standard template';
        objTemp.Subject__c = 'Standard';
        objTemp.Type__c = 'Upstream & Downstream';
        objTemp.ValidTimeHrs__c = 24;
        objTemp.ErrorSMS__c=tempid;
        insert objTemp;
    }
    
    static void createTemplate_Closure_SMS()
    {
        objTempSMS = new Template__c();
        objTempSMS.Active__c = true;
        objTempSMS.AnalyzeRequired__c = true;
        objTempSMS.Closure_SMS__c = 'a1S';
        objTempSMS.Message_Detail__c = 'standard template';
        objTempSMS.Subject__c = 'Standard';
        objTempSMS.Type__c = 'Upstream & Downstream';
        objTempSMS.ValidTimeHrs__c = 24;
        insert objTempSMS;
    }
    
    static void createTemplate_Error_SMS()
    {
        objTempError = new Template__c();
        objTempError.Active__c = true;
        objTempError.AnalyzeRequired__c = true;
        objTempError.Closure_SMS__c = 'a1S';
        objTempError.Message_Detail__c = 'standard template';
        objTempError.Subject__c = 'Standard';
        objTempError.Type__c = 'Upstream & Downstream';
        objTempError.ValidTimeHrs__c = 24;
        objTempError.RecordTypeId=ERROR_REC_ID;
        insert objTempError;
    }
    static void createTemplate_Error_MMS()
    {
        objTempErrorMMS = new Template__c();
        objTempErrorMMS.Active__c = true;
        objTempErrorMMS.AnalyzeRequired__c = true;
        objTempErrorMMS.Closure_SMS__c = 'a1S';
        objTempErrorMMS.Message_Detail__c = 'standard template';
        objTempErrorMMS.Subject__c = 'Standard';
        objTempErrorMMS.Type__c = 'Upstream & Downstream';
        objTempErrorMMS.ValidTimeHrs__c = 24;
        objTempErrorMMS.RecordTypeId=ERROR_REC_ID_MMS;
        insert objTempErrorMMS;
    }
    
    static void createSMSCode()
    {
    	objSC = new SMS_Code__c(Template__c = objTemp.Id, RecordTypeId = smsRecordTypeId,SMSCode__c='MS',SendClosureSMS__c=true);
    	insert objSC;
    }
}