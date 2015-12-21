/*
    Type:       Test Class
    Purpose:    Test the ScheduledDeleteTaskToDealers class
    User Story:  
    History: 
    1. Shuang Li created on 2014-05-13
*/
@isTest 
public class ScheduledDeleteTaskToDealersTest{
    
    static testMethod void testScheduledDeleteTaskToDealers(){
        Test.startTest();
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        Task testTask = (Task)UtilTestData.createSobject(new Task(), 'General Task');
        system.debug('General Task Id :' +testTask);
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduledDeleteTaskToDealersTest', CRON_EXP, new ScheduledDeleteTaskToDealers() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        Test.stopTest();
        
        //Assert for the Task Delete:
         Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
         List<Task> taskList = [Select Id, IsDeleted  From Task Where RecordTypeId = :cpRecordTypeMap.get('General Task').getRecordTypeId() And ActivityDate < :System.today()];
         system.debug('Deleted Tasks Size:' +taskList.size());
         system.assertEquals(0, taskList.size());
         System.assertEquals(CRON_EXP, ct.CronExpression); 
         
    }
}