/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateWeeklyDealerOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateWeeklyDealerOBEmailsTest{
    
    static testMethod void testScheduleCreateWeeklyDealerOBEmails(){

        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduleCreateWeeklyDealerOBEmailsTest', CRON_EXP, new ScheduleCreateWeeklyDealerOBEmails() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}