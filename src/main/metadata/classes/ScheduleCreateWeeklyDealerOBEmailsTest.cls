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
        System.schedule('ScheduleCreateWeeklyDealerOBEmailsTest', '0 0 13 * * ?', new ScheduleCreateWeeklyDealerOBEmails());
        Test.stopTest();
    }
}