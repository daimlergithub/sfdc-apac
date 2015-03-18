/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateMonthlyDealerOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateMonthlyDealerOBEmailsTest{
    
    static testMethod void testScheduleCreateMonthlyDealerOBEmails(){

        Test.startTest();
        System.schedule('ScheduleCreateMonthlyDealerOBEmailsTest', '0 0 13 * * ?', new ScheduleCreateMonthlyDealerOBEmails());
        Test.stopTest();
    }
}