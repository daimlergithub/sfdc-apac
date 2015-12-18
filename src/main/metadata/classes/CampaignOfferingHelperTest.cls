@isTest
public class CampaignOfferingHelperTest
{
    static testmethod void testGenerateCampaignOfferingHistoryLOG(){
        
		List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
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
        Test.stopTest();
        System.assertEquals(TestData_CCA.Id,co.Campaign__c);
        System.assertEquals('123',co.Description__c);
    }
}