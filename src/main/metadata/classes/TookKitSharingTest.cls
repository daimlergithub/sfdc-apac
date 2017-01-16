@isTest
private class TookKitSharingTest {
        
    private static Account dealer;
    private static User thirdPartyUser;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com', Dealer_Marketing_Manager__c = true);
        insert dealerContact;

        Profile venderProfile = [SELECT Id FROM Profile WHERE Name = 'External Marketing User' Limit 1];
        thirdPartyUser = new User(Username = 'test123456test@test.com', ProfileId = venderProfile.Id, Alias = 'test1234', Email = 'test123456@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumarm', CommunityNickname = 'test123405', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        insert thirdPartyUser;    
    }
    
    @isTest 
    static void testWrapToolKits() {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		 insert updatecustomsettings;
        Test.startTest();
        Tool_Kit__c toolKit = new Tool_Kit__c(Dealer_Name__c = dealer.Id, Vendor_Employee__c = thirdPartyUser.Id);
        insert toolKit;
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        List<SharingWrapper> wrapToolKits =wrapService.wrapToolKits(new List<Tool_Kit__c>{toolKit});
        List<SharingWrapper> wrapToolKitsFor3rdPartyUsers =wrapService.wrapToolKitsFor3rdPartyUsers(new List<Tool_Kit__c>{toolKit});
        Test.stopTest();
        system.assertNotEquals(null, wrapToolKits);
        system.assertNotEquals(null, wrapToolKitsFor3rdPartyUsers);
        
    }
    
}