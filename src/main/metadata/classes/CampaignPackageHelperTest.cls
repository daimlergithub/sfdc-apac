@isTest
public class CampaignPackageHelperTest
{
     
   static testmethod void testGenerateCampaignPackageHistoryLOG(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;
        
        Test.startTest();
	        
        //Data Prepared
        Campaign TestData_CCA = UtilTestData.dataPreparation();
        Campaign_Package__c cp = new Campaign_Package__c(Name='TEST CAMPAIGN PACKAGE999',
                                                         Campaign__c=TestData_CCA.Id,
                                                         Package_Description__c='description');
        insert cp;
        cp.Package_Description__c = '123';
        update cp;
        delete cp;
        
        Test.stopTest();
        
        System.assertEquals(TestData_CCA.Id,cp.Campaign__c);
        System.assertEquals('123',cp.Package_Description__c);  
    }
}