/*
    Type:       Test Class
    Purpose:    Test the ScheduleCreateConversionRateOBEmails class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. venky created on 2015-03-13
*/
@isTest(seeAllData=true)
public class ScheduleCreateConversionRateOBEmailsTest{
    
    static testMethod void testScheduleCreateConversionRateOBEmails(){

        Test.startTest();
        System.schedule('ScheduleCreateConversionRateOBEmailsTest', '0 0 13 * * ?', new ScheduleCreateConversionRateOBEmails());
        Test.stopTest();
    }
}