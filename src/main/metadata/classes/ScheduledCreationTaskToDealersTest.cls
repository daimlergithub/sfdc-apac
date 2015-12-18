/*
    Type:       Test Class
    Purpose:    Test the ScheduledCreationTaskToDealers class
    1. Shuang Li created on 2014-05-13
*/
@isTest
public With Sharing class ScheduledCreationTaskToDealersTest{
    
    static testMethod void testScheduledCreationTaskToDealers()
    {
     /*Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.Enable__c=true;
        cls.name='Community Enabled';
        insert cls;*/
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            User testUser;
            Test.startTest();
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;

            //Create User
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr){
               testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
               update testUser;
            }              
            String CRON_EXP = '0 0 0 1 1 ? 2025';  
            String jobId = System.schedule('ScheduledCreationTaskToDealersTest', CRON_EXP, new ScheduledCreationTaskToDealers() );
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression); 
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
            
            List<Task> testTask = [Select Id,OwnerId From Task];
            if(!testTask.isEmpty()){
                try {
                        system.assertEquals(testUser.Id, testTask[0].OwnerId);
                    }
                catch (DMLException e) {
                    System.debug('Exception message is :' + e.getDMLMessage(0));
                }
            }
        }
    }
}