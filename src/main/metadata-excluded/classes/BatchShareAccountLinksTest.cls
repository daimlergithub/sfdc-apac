@isTest
private class BatchShareAccountLinksTest {
    
    private static Account dealer;
    private static User dealerUser;
    private static Vehicle__c vehicle;
    private static Account personAccount;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Gold Partner User' Limit 1];
        dealerUser= new User(Username = 'test12345test@test.com', ContactId = dealerContact.Id, ProfileId = portalProfile.Id, Alias = 'test123', Email = 'test12345@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test12345', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        insert dealerUser;
        /**
        personAccount= (Account)UtilTestData.createSobject(new Account(), 
                    UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        */            
        vehicle = new Vehicle__c();
        insert vehicle;        
    }

    @isTest
    static void testWrapAccountLinks() {
        Test.startTest();
        RecordType accountLinkType = [select Id from RecordType where SObjectType = 'Account_Link__c' and DeveloperName = 'ContactSector' limit 1];
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = accountLinkType.Id, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        RecordType externalLinkType = [select Id from RecordType where SObjectType = 'Account_Link__c' and DeveloperName = 'ExternalLink' limit 1];
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType.Id, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        RecordType contact2ContactType = [select Id from RecordType where SObjectType = 'Account_Link__c' and DeveloperName = 'Contact2Contact' limit 1];
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = contact2ContactType.Id, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        List<Account_Link__c> accountLinks = new List<Account_Link__c>();
        accountLinks.add(contactSector);
        accountLinks.add(externalLink);
        accountLinks.add(contact2Contact);
        insert accountLinks;
        BatchShareAccountLinks batchJob = new BatchShareAccountLinks();
        Database.executeBatch(batchJob);
        Test.stopTest();
    }
}