/*
    Type:       Test Class
    Purpose:    Test the ScheduledUpdateCommunityUsers class
    User Story: 
    ---------------------------------------------------------------
    History:

    1. Shuang Li created on 2014-05-13
*/
@isTest(seeAllData=true)
public class ScheduledUpdateCommunityUsersTest{
    
    static testMethod void testScheduledUpdateCommunityUsers(){

        Test.startTest();
        System.schedule('ScheduledUpdateCommunityUsersTest', '0 0 13 * * ?', new ScheduledUpdateCommunityUsers());
        Test.stopTest();
    }
}