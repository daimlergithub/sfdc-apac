/*
    Type:       Test Class
    Purpose:    Test the ScheduledDeleteTaskToDealers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest
public class ScheduledDeleteTaskToDealersTest{
    
    static testMethod void testScheduledDeleteTaskToDealers(){
        Test.startTest();
         Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
        Task testTask = new Task();
        testTask.ActivityDate=system.today().addDays(-1);
        testTask.RecordTypeId=cpRecordTypeMap.get('General Task').getRecordTypeId();
         testTask.Subject = 'Welcome Call';    
        
        
            insert testTask;
        
        system.debug('General Task Id :' +testTask.ActivityDate);
        system.debug('General Task Id :' +testTask.RecordTypeId);
        String CRON_EXP = '0 0 0 1 1 ? 2025';
        String jobId = System.schedule('ScheduledDeleteTaskToDealersTest', CRON_EXP, new ScheduledDeleteTaskToDealers() );
     
          CronTrigger ct = [select id, CronExpression,State, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
          Test.stopTest();
         //Assert for the Task Delete:
          
          List<Task> taskList = [Select Id, IsDeleted  From Task Where RecordTypeId = :cpRecordTypeMap.get('General Task').getRecordTypeId() And ActivityDate < :System.today()];
          system.debug('Deleted Tasks Size:' +taskList.size());
          system.assertEquals(0, taskList.size());
          System.assertEquals(CRON_EXP, ct.CronExpression); 
          System.assertEquals(0, ct.TimesTriggered);
          System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
         
    }
}