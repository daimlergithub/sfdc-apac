@isTest
private class RetailCampaignSharingTest {
    
    private static Account dealer;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        List<Contact> dealerContacts = new List<Contact>();
        Contact asContact = new Contact(FirstName = 'ASTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        dealerContacts.add(asContact);
        Contact smContact = new Contact(FirstName = 'SMTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        dealerContacts.add(smContact);
        Contact adminContact = new Contact(FirstName = 'AdminTest', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        dealerContacts.add(adminContact);
        insert dealerContacts;
        
        List<User> dealerUsers = new List<User>();
        Id UserRoleId=UtilTestData.getUserRoleId('Dealer');
        Profile smProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];
        User smUser = new User(Username = 'test12345testsm@test.com',ProfileId = smProfile.Id,UserRoleId=userRoleId,Alias = 'testsm', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345m', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        Profile asProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];
        User asUser = new User(Username = 'test12345testas@test.com',ProfileId = asProfile.Id,UserRoleId=userRoleId,Alias = 'testas', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345s', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        dealerUsers.add(asUser);
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];
        User adminUser = new User(Username ='test12345testadmin@test.com',ProfileId =adminProfile.Id,UserRoleId=userRoleId,Alias = 'testadm', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345a', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        dealerUsers.add(adminUser);        
        insert dealerUsers;
        dealer.Retail_MB_Owner__c = smUser.Id;
        dealer.Retail_AS_Owner__c = asUser.Id;
        dealer.Retail_AMG_Owner__c = adminUser.Id;
        dealer.Retail_Star_Elite_Owner__c = adminUser.Id;
        update dealer;
    }

    @isTest 
    static void testWrapRetailCampaigns() {
        List<Retail_Campaign__c> retailCampaigns = new List<Retail_Campaign__c>();
        for(RecordType retailCampaignType : [select Id, DeveloperName from RecordType where SObjectType = 'Retail_Campaign__c']) {
            Retail_Campaign__c retailCampaign = new Retail_Campaign__c(Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId = retailCampaignType.Id, Brand__c = 'MB');
            retailCampaigns.add(retailCampaign);
        }
        insert retailCampaigns;
        
        Test.startTest();
        RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
        wrapService.wrapRetailCampaigns(retailCampaigns);
        Test.stopTest();    
    }
}