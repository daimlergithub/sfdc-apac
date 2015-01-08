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

        Test.startTest();
        System.schedule('ScheduledCreationTaskToDealersTest', '0 0 13 * * ?', new ScheduledCreationTaskToDealers());
        Test.stopTest();
    }
}