/**
 * An apex page controller that takes the user to
  the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesSelfRegConfirmControllerTest {
private static CommunitiesSelfRegConfirmController controller;
    @IsTest public static void testCommunitiesSelfRegConfirmController() {
        // Instantiate a new controller with all parameters in the page
        Test.startTest();
        controller = new CommunitiesSelfRegConfirmController();
        Test.stopTest();
        system.assertNotEquals(null,controller);
      }    
}