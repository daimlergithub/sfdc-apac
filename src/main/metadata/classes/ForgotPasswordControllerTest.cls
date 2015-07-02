/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest public with sharing class ForgotPasswordControllerTest {
     @IsTest  public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        Test.startTest();
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
     Test.stopTest();
        System.assertEquals(controller.forgotPassword(),null); 
    }
}