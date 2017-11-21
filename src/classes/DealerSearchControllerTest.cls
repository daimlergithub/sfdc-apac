@isTest
public class DealerSearchControllerTest
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void testDealerSearch_QueryException()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
        Test.startTest();
        // Test DealerSearch
        PageReference pr  = new PageReference('/apex/DealerSearch');
        Test.setCurrentPage(pr);
        DealerSearchController dealerSearch = new DealerSearchController(new ApexPages.StandardController(new Account()));
        Test.stopTest();
        System.assert(dealerSearch.dealer.Province__c == null);
        System.assert(dealerSearch.dealer.City__c == null);
    }
    
    public static testMethod void testDealerSearch()
    {
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
        // Create dealer
        Account dealer = new Account(Name = 'Shanghai test',
                                     Province__c = 'Shanghai',
                                     City__c = 'Xuhui district,',
                                     Dealer_Sales_Type__c = 'Smart',
                                     MBK_Data_Source__c = 'Email',
                                     Dealer_Service_Codes__c = 'Sales;Parts');
        dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Person Account
        Account personAccount = new Account(RecordTypeId = personRecordtypeid, Province__c = 'Shanghai',
                                            City__c = 'Xuhui district,');
        //personAccount = (Account)UtilTestData.createSobject(personAccount,UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        // Start Test
        Test.startTest();
        // Test DealerSearch
        PageReference pr  = new PageReference('/apex/DealerSearch?Id=' + personAccount.Id);
        Test.setCurrentPage(pr);
        DealerSearchController dealerSearch = new DealerSearchController(new ApexPages.StandardController(personAccount));
        // Change name
        dealerSearch.name = 'Shanghai';
        dealerSearch.query();
        // Change Dealer_Sales_Type__c
        dealerSearch.dealer.Province__c = null;
        dealerSearch.query();
        // Change Dealer_Sales_Type__c
        dealerSearch.dealer.Dealer_Sales_Type__c = 'Smart';
        dealerSearch.query();
        // Change Dealer_Service_Codes__c
        // Service is in 'Sales;Parts'
        dealerSearch.dealer.Dealer_Service_Codes__c = 'Service';
        dealerSearch.query();
        // Stop Test
        Test.stopTest();
        System.assert(dealerSearch.dealers.size() == 0, 'Searched Dealers Size != 0');
        System.assertEquals(dealerSearch.dealer.Dealer_Service_Codes__c, 'Service');
    }
}