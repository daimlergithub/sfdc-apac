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
    private static String smsContent='Test Content';
    private static String standardtemplate='standard template';
    private static String standard='standard';
    private static String UpstreamDownstream='Upstream & Downstream';
   
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert()
    {      
        createTemplate_Closure_SMS();
        createTemplate_Error_SMS();
        createTemplate(objTempError.Id);
        createTask();
        Test.startTest();
        SMSReplyHistory__c obj=createSMSReplyHistory();
        obj.ResponseContent__c='MS';
        insert obj;
        Test.stopTest();
        System.assertEquals(obj.ResponseContent__c,'MS');
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL()
    {
       
        createTemplate_Closure_SMS();
        createTemplate_Error_SMS();
        createTemplate(objTempError.Id);
        createSMSCode();
        createTask();
        Test.startTest();
        SMSReplyHistory__c obj=createSMSReplyHistory();
        obj.Template__c=null;
        insert obj;
        Test.stopTest();
        System.assertNotEquals(null,objTempError.Id);
        System.assertNotEquals(null,objSrh);
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL1()
    {
        
        createTemplate_Closure_SMS();
        createTemplate_Error_SMS();
        createTemplate(objTempError.Id);
        createSMSCode();
        createTask();
        Test.startTest();
        SMSReplyHistory__c obj=createSMSReplyHistory();
        obj.TaskID__c='testtstt';
        insert obj;
        Test.stopTest();
        System.assertNotEquals(null,obj.Id);
    }
    
    public static testMethod void testTriggerSMSReplyHistoryBeforeInsert_ResponseContent_NULL2()
    {
        
        createTemplate_Closure_SMS();
        createTemplate_Error_MMS();
        createTemplate(objTempErrorMMS.Id);
        createSMSCode();
        createTask();
        Test.startTest();
        SMSReplyHistory__c obj=createSMSReplyHistory();
        obj.ResponseContent__c=null;
        obj.IsValid__c = false;
        insert obj;
        Test.stopTest();
        System.assertNotEquals(null,objTempErrorMMS.Id);
        System.assertEquals(obj.IsValid__c,false);
    }
    
    
     public static testMethod void testcreateSMSTask()
    {
     createTemplate_Closure_SMS();
        createTemplate_Error_MMS();
        createTemplate(objTempErrorMMS.Id);
        createSMSCode();
        createTask();
        Test.startTest();        
        SMSReplyHistoryHelper.createSMSTask(objTask,smsContent);
        Test.stopTest();
        System.assert(objTask!=null);
    }
    
    
     public static testMethod void testcreateMMSTask()
    {
       createTemplate_Closure_SMS();
        createTemplate_Error_MMS();
        createTemplate(objTempErrorMMS.Id);
        createTask();
        createSMSCode();
        Test.startTest();        
        SMSReplyHistoryHelper.createMMSTask(objTask,objTemp);
        Test.stopTest();
         System.assertNotEquals(null,objTask);
         System.assertNotEquals(null,objTemp);
         system.assertEquals(objTask.Subject, 'MMS');
    }
    
    public static testMethod void testcreateOBTask()
    { 
        createTemplate_Closure_SMS();
        createTemplate_Error_MMS();
        createTemplate(objTempErrorMMS.Id);
        createSMSCode();
        createTask();
        Test.startTest();  
        SMSReplyHistory__c obj=createSMSReplyHistory();
        obj.Template__c=null;
        insert obj;      
        SMSReplyHistoryHelper.createOBTask(objTask,objSrh,objSC);
        Test.stopTest();
        System.assertEquals(objSrh.IsFirstValid__c,true);
        system.assertEquals(objTask.Priority__c ,'High');
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
        objTask.Subject = 'MMS';
        objTask.Status = 'Closed';
        objTask.Activity_Status__c = 'Sent';
        objTask.Priority__c = 'High';
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
        objTemp.Message_Detail__c =standardtemplate;
        objTemp.Subject__c = standard;
        objTemp.Type__c = UpstreamDownstream;
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
        objTempSMS.Message_Detail__c = standardtemplate;
        objTempSMS.Subject__c = standard;
        objTempSMS.Type__c = UpstreamDownstream;
        objTempSMS.ValidTimeHrs__c = 24;
        insert objTempSMS;
    }
    
    static void createTemplate_Error_SMS()
    {
        objTempError = new Template__c();
        objTempError.Active__c = true;
        objTempError.AnalyzeRequired__c = true;
        objTempError.Closure_SMS__c = 'a1S';
        objTempError.Message_Detail__c = standardtemplate;
        objTempError.Subject__c = standard;
        objTempError.Type__c = UpstreamDownstream;
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
        objTempErrorMMS.Message_Detail__c =standardtemplate;
        objTempErrorMMS.Subject__c = standard;
        objTempErrorMMS.Type__c = UpstreamDownstream;
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