/*
    Type:       test class
    Purpose:    YearlyTargetController test class
    User Story: Release 1.2 Retail Campaign
    Used By:    YearlyTargetController  
    10-Jun-2014 Sinow    Created
*/
@isTest 
public class YearlyTargetControllerTest {

    public static testMethod void testYearlyTargetController() {
    
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        Test.startTest();
        YearlyTargetController controller = new YearlyTargetController();
        controller.goRequestedPage();
        controller.previous();
        controller.next();
        controller.first();
        controller.last();
        boolean test1 = controller.hasPrev;
        boolean test2 = controller.hasNext;
        controller.initForAS();
        Test.stopTest();
        System.assertEquals(test1,false);
        System.assertEquals(test2,false);
    }
}