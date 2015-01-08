@isTest
private class LeadSharingTest {
	
	private static Account dealer;
    private static User dealerUser;
    private static Account contact;
    private static Lead__c lead;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com', Dealer_Marketing_Manager__c = true);
        insert dealerContact;
        
        contact = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Gold Partner User' Limit 1];
        dealerUser = new User(Username = 'test12345test@test.com', ContactId = dealerContact.Id, ProfileId = portalProfile.Id, Alias = 'test123', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        insert dealerUser;

        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
        lead = new Lead__c(Assigned_Dealer__c = dealer.Id, Contact__c = contact.Id, RecordTypeId = retailLeadType.Id);
        insert lead;
    }
    
    @isTest 
    static void testWrapLeads() {
        Test.startTest();
        LeadSharingWrapService wrapService = new LeadSharingWrapService();
        wrapService.wrapLeads(new List<Lead__c>{lead});
        Test.stopTest();
    }
	
}