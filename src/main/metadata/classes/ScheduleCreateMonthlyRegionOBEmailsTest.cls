/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateMonthlyRegionOBEmails  class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateMonthlyRegionOBEmailsTest{
    
    static testMethod void testScheduleCreateMonthlyRegionOBEmails(){

        Test.startTest();
        System.schedule('ScheduleCreateMonthlyRegionOBEmailsTest', '0 0 13 * * ?', new ScheduleCreateMonthlyRegionOBEmails());
        Test.stopTest();
    }
}