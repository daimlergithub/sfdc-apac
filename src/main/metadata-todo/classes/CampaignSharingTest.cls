@isTest
private class CampaignSharingTest {
        
    private static Account dealer;
    private static User dealerUser;
    private static Campaign campign;
    private static Participating_Dealer__c participatingDealer;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Dealer Community User' Limit 1];
        dealerUser= new User(Username = 'test12345test@test.com', ContactId = dealerContact.Id, ProfileId = portalProfile.Id, Alias = 'test123', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        insert dealerUser;
        
        campign = new Campaign(IsActive = true, Name = 'top', Status = 'Started', StartDate = System.today(), EndDate = System.today(), RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS BMBS Campaign').getRecordTypeId());
        insert campign;

        participatingDealer = new Participating_Dealer__c(Dealer__c = dealer.Id, Campaign__c = campign.Id);
        insert participatingDealer;
    }

    @isTest 
    static void testWrapCampaigns() {
        Test.startTest();
        CampaignSharingWrapService wrapService = new CampaignSharingWrapService();
        wrapService.wrapASCampaigns(new List<Participating_Dealer__c>{participatingDealer});
        Test.stopTest();    
    }
}