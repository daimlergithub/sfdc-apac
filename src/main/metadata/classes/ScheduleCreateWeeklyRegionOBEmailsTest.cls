/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateWeeklyRegionOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateWeeklyRegionOBEmailsTest{
    
    static testMethod void testScheduleCreateWeeklyRegionOBEmails(){

        Test.startTest();
        System.schedule('ScheduleCreateWeeklyRegionOBEmailsTest', '0 0 13 * * ?', new ScheduleCreateWeeklyRegionOBEmails());
        Test.stopTest();
    }
}