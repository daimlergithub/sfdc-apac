@isTest
public class ParticipatingDealerHelperTest
{
    static testmethod void testGenerateCampaignParticipatingDealerHistoryLOG(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        
        Test.startTest();
        // Data Prepared
        Campaign TestData_CCA = UtilTestData.dataPreparation();
        
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
        Account dealer = new Account(Name='TEST Dealer999', ZipCode__c='1234567', Phone='0123456789', RecordTypeId=accDealerRT);
        insert dealer;
        
       Participating_Dealer__c pd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id,
                                                                 Dealer__c=dealer.Id);
        insert pd;
        update pd;
        delete pd;
        
        Test.stopTest();    
        System.assertEquals(TestData_CCA.Id,pd.Campaign__c);
        System.assertEquals(accDealerRT,dealer.RecordTypeId);  
    }
}