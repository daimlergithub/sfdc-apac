/*
    Type:       Test Class
    Purpose:    Test the ScheduledUpdateCommunityUsers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest(seeAllData=true)
public class ScheduledUpdateCommunityUsersTest{
    
    static testMethod void testScheduledUpdateCommunityUsers(){
        User testUser;
        
        Test.startTest();
        //Create a Community User:
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // testUser = (User)UtilTestData.createPortalUser('Dealer', 'Dealer Delegate Admin');
           // update testUser;
        }
        
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduledUpdateCommunityUsersTest', CRON_EXP, new ScheduledUpdateCommunityUsers() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}