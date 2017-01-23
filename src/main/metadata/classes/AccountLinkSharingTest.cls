@isTest
private class AccountLinkSharingTest {
    private static Account dealer;
    
    private static Vehicle__c vehicle;      
    Private static String accountLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilTestData.accountLink_Contact2Contact).getRecordTypeId(); 
    Private static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(); 
    Private static String contact2ContactType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(); 
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
   
    
    
    static { 

        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
        
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContact2Contact() {
        Test.startTest();  
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'contact2Contact', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        List<SharingWrapper> testSharingWrapC2C = wrapService.wrapContact2Contact(new List<Account_Link__c>{contact2Contact});
        Test.stopTest();
        system.assertNotEquals(null, testSharingWrapC2C);
    }
    
    @isTest 
    static void testWrapExternalLink() {
        Test.startTest();
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'externalLink', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        List<SharingWrapper> testSharingWrapEl =    wrapService.wrapExternalLink(new List<Account_Link__c>{externalLink});
        Test.stopTest();
        system.assertNotEquals(null, testSharingWrapEl);
    }
    
    @isTest 
    static void testWrapContactSector() {
        Test.startTest();
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = contact2ContactType, Name = 'contactSector', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        List<SharingWrapper> testSharingWrapCs = wrapService.wrapContactSector(new List<Account_Link__c>{contactSector});
        Test.stopTest();
        system.assertNotEquals(null, testSharingWrapCs);
    }

    @isTest
    static void testWrapAccountLinks() {
        Test.startTest();
        Account_Link__c contactSector = new Account_Link__c(RecordTypeId = accountLinkType, Name = 'contactSector', Vehicle__c = vehicle.Id);
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'externalLink', Vehicle__c = vehicle.Id);
        Account_Link__c contact2Contact = new Account_Link__c(RecordTypeId = contact2ContactType, Name = 'contact2Contact', Vehicle__c = vehicle.Id);
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        List<SharingWrapper> testSharingWrapAlrt = wrapService.wrapAccountLinksByRecordTypes(new List<Account_Link__c>{contactSector, externalLink, contact2Contact});
        Test.stopTest();
        system.assertNotEquals(null, testSharingWrapAlrt);
    }
    

}