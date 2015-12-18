/*
    Type:       Test Class
    Purpose:    Test the ScheduledUpdateCommunityUsers class
    1. Shuang Li created on 2014-05-13
*/
@isTest
public Without Sharing class ScheduledUpdateCommunityUsersTest{
    
    static testMethod void testScheduledUpdateCommunityUsers()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
     
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            User testUser;
            Test.startTest();

            //Create a Community User:
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr){
                testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
                update testUser;
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
}