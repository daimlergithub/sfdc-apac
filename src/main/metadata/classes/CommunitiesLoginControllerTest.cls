/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class CommunitiesLoginControllerTest {
    @IsTest 
    global static void testCommunitiesLoginController () {
    Test.startTest();
        CommunitiesLoginController controller = new CommunitiesLoginController();
        Test.stopTest();
        System.assertEquals(null, controller.forwardToAuthPage());       
    }    
}