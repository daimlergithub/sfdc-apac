@isTest
public class CampaignOfferingHelperTest
{
    private static Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
    private static string en_US='en_US';
    static testmethod void testGenerateCampaignOfferingHistoryLOG(){
        
		List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
		insert updatecustomsettings;
        Test.startTest();

      // Data Prepared
        Campaign TestData_CCA = UtilTestData.dataPreparation();
        Campaign_Offering__c co = new Campaign_Offering__c(Name='TEST CAMPAIGN OFFERING999',
                                                           Campaign__c=TestData_CCA.Id);
        
        insert co;
        co.Description__c = '123';
        update co;
        delete co;
        //Handler for JP
        TriggerCampaignOfferingTriggerHandlerJP CampaignOfferingHandlerJP = new TriggerCampaignOfferingTriggerHandlerJP();
        CampaignOfferingHandlerJP.handleTrigger(false, false, false, false, false);
        CampaignOfferingHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
         Test.stopTest();
        System.assertEquals(TestData_CCA.Id,co.Campaign__c);
        System.assertEquals('123',co.Description__c);

    }    
          
}