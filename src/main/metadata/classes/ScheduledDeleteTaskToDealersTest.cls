/*
    Type:       Test Class
    Purpose:    Test the ScheduledDeleteTaskToDealers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest(seeAllData=true)
public class ScheduledDeleteTaskToDealersTest{
    
    static testMethod void testScheduledDeleteTaskToDealers(){

        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduledDeleteTaskToDealersTest', CRON_EXP, new ScheduledDeleteTaskToDealers() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}