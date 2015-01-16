/*
    Type:       Test Class
    Purpose:    Test the ScheduledDeleteTaskToDealers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest(seeAllData=true)
public class ScheduledDeleteTaskToDealersTest{
    
    static testMethod void testScheduledDeleteTaskToDealers(){

        Test.startTest();
        System.schedule('ScheduledDeleteTaskToDealersTest', '0 0 13 * * ?', new ScheduledDeleteTaskToDealers());
        Test.stopTest();
    }
}