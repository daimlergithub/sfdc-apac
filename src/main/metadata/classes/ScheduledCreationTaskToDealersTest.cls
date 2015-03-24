/*
    Type:       Test Class
    Purpose:    Test the ScheduledCreationTaskToDealers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest(seeAllData=true)
public class ScheduledCreationTaskToDealersTest{
    
    static testMethod void testScheduledCreationTaskToDealers(){
    	User testUser;
        Test.startTest();
        //Create User
    	User usr = [Select id from User where Id = :UserInfo.getUserId()];
    	System.RunAs(usr){
			testUser = (User)UtilTestData.createPortalUser('Dealer', 'Dealer Delegate Admin');
	    	update testUser;
    	}
    	system.debug('@Shrinivas User:' +testUser.ContactId);
        
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('ScheduledCreationTaskToDealersTest', CRON_EXP, new ScheduledCreationTaskToDealers() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        List<Task> testTask = [Select Id,OwnerId From Task Where WhoId =: testUser.ContactId];
        if(testTask.size() > 0){
            try {
                    system.assertEquals(testUser.Id, testTask[0].OwnerId);
                }
            catch (DMLException e) {
                System.debug('Exception message is :' + e.getDMLMessage(0));
            }
        }
    }
}