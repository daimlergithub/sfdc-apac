/*
    Type:       test class
    Purpose:    RetailCampaignCalendarController test class
    User Story: Release 1.2 Retail Campaign

    Used By:    RetailCampaignCalendarController
    ---------------------------------------------------------------
    History:

    10-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class RetailCampaignCalendarControllerTest {
    public static testMethod void testRetailCampaignCalendarController() {
        List<Retail_Campaign__c> testData = RetailCampaignCalendarController.queAfterSalesCamps('2013', '2014', 'a', 'b');
        testData = RetailCampaignCalendarController.queSMMediaCamps('2013', '2014', 'a');
        testData = RetailCampaignCalendarController.queSMEventCamps('2013', '2014', 'a');
    }
}