@isTest
private class BatchShareRetailTaskContractsTest {
	private static Account dealer;
    private static User dealerUser;
    private static Vehicle__c vehicle;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Gold Partner User' Limit 1];
        dealerUser= new User(Username = 'test12345test@test.com', ContactId = dealerContact.Id, ProfileId = portalProfile.Id, Alias = 'test123', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        insert dealerUser;

        vehicle = new Vehicle__c();
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContract() {
        Test.startTest();
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;
        BatchShareRetailTaskContracts contractBatch = new BatchShareRetailTaskContracts();
        Database.executeBatch(contractBatch);
        Test.stopTest();
    }	
}