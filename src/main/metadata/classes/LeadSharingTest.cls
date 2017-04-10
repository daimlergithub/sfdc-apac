@isTest
private With Sharing class LeadSharingTest {
    
    private static Account dealer;
    private static Account contact;
    private static Lead__c lead;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com', Dealer_Marketing_Manager__c = true);
        insert dealerContact;
        
        contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
        lead = new Lead__c(Assigned_Dealer__c = dealer.Id, Contact__c = contact.Id, RecordTypeId = retailLeadType.Id);
        insert lead;
    }
    
    @isTest 
    static void testWrapLeads() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        Test.startTest();
        LeadSharingWrapService wrapService = new LeadSharingWrapService();
        List<SharingWrapper> wrapLeads=wrapService.wrapLeads(new List<Lead__c>{lead});
        Test.stopTest();
        system.assertNotEquals(null, wrapLeads);
    }
    
}