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
    
    @isTest public static void testTriggerSMSReplyHistoryBeforeInsert(){
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
    
    private static Template__c getTemplate(){
        Template__c template = new Template__c(
            Active__c = true,
            AnalyzeRequired__c = true,
            Closure_SMS__c = 'Closure SMS',
            Message_Detail__c = 'standard template',
            Subject__c = 'Standard',
            Type__c = 'Upstream & Downstream',
            ValidTimeHrs__c = 24
        );
        return template;
    }
    
    private static Task getSMSTask(){
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
    
    private static void createSMSCode(Template__c template, Template__c nextTemplate){
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
    }
}