/* Type:       test class
    Purpose:    RetailCampaignCalendarController test class
    User Story: Release 1.2 Retail Campaign
    Used By:    RetailCampaignCalendarController
    History:10-Jun-2014 Sinow    Created
*/
@isTest
public class RetailCampaignCalendarControllerTest {
Public static List<Retail_Campaign__c> testData;
Public static RetailCampaignCalendarController RC;
    public static testMethod void testRetailCampaignCalendarController() {
        Test.startTest();
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        testData = RetailCampaignCalendarController.queAfterSalesCamps('2013', '2014', 'a', 'b');        
        testData = RetailCampaignCalendarController.queSMMediaCamps('2013', '2014', 'a');
        testData = RetailCampaignCalendarController.queSMEventCamps('2013', '2014', 'a');
        RC=new RetailCampaignCalendarController();
        Test.stopTest();
        System.assert(testData.isEmpty());
    }
}