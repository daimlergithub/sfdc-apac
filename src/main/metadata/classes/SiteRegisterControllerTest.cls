/**
 * Class containing tests for SiteRegisterController
 */
@IsTest public with sharing class SiteRegisterControllerTest {
    @IsTest  static void testRegistration() {
    Test.startTest();
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        System.assert(controller.registerUser() == null);          
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        Test.stopTest();
        System.assert(controller.registerUser() == null);  
    }
}