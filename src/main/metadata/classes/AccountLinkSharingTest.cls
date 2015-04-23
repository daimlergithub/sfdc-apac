@isTest
private class AccountLinkSharingTest {
    private static Account dealer;
    private static Vehicle__c vehicle;      
    Private static String accountLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId(); 
    Private static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ExternalLink').getRecordTypeId(); 
    Private static String contact2ContactType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(); 
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    static {   
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
        vehicle = new Vehicle__c();
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContact2Contact() {
        Test.startTest();  
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        wrapService.wrapContact2Contact(new List<Account_Link__c>{contact2Contact});
        Test.stopTest();
    }
    
    @isTest 
    static void testWrapExternalLink() {
        Test.startTest();
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        wrapService.wrapExternalLink(new List<Account_Link__c>{externalLink});
        Test.stopTest();
    }
    
    @isTest 
    static void testWrapContactSector() {
        Test.startTest();
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = contact2ContactType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        wrapService.wrapContactSector(new List<Account_Link__c>{contactSector});
        Test.stopTest();
    }

    @isTest
    static void testWrapAccountLinks() {
        Test.startTest();
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = contact2ContactType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        wrapService.wrapAccountLinksByRecordTypes(new List<Account_Link__c>{contactSector, externalLink, contact2Contact});
        Test.stopTest();
    }
    
    @isTest
    static void testAccountLinkTrigger() {
    	Test.startTest();
        SharingWrapper service = new SharingWrapper();    
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id); 
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = contact2ContactType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        insert new List<Account_Link__c>{contactSector, externalLink, contact2Contact};
        Test.stopTest();
    }
}