/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class SiteLoginControllerTest {
    @IsTest  global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        Test.startTest();
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        Test.stopTest();
        System.assertEquals(controller.login(),null);                           
    }    
}