/*
    Type:       test class
    Purpose:    YearlyTargetController test class
    User Story: Release 1.2 Retail Campaign

    Used By:    YearlyTargetController 
    ---------------------------------------------------------------
    History:

    10-Jun-2014 Sinow    Created
*/
@isTest
public class YearlyTargetControllerTest {
    public static testMethod void testYearlyTargetController() {
        YearlyTargetController controller = new YearlyTargetController();
        controller.goRequestedPage();
        controller.previous();
        controller.next();
        controller.first();
        controller.last();
        system.assertNotEquals(null, controller);
    }
}