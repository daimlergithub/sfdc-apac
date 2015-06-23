/*
    Type:       Test class of ContactHelper
    Purpose:    1. Copy contact name, phone, email to Dealer.
                2. There should only be one contact with "Dealer Lead Gate Keeper" selected or "Dealer Complaint Gate Keeper" selected in one Dealer.
                3. There should only be one contact with "Dealer Complaint Manager" selected or "Dealer Presales" selected in one Dealer.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-28
    2. Justin Updated on 2013-07-31 for adding testCopyAftersalesManagerInfoToDealer method.
*/
@isTest
private class ContactHelperTest {
    
    public static Account account;
    public static Contact contact;
    private static testMethod void ValidateGateKeepersAndManagerTest() {
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Contact
        Contact conComplaint = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
        insert conComplaint;
        Contact conSales = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Lead_Gate_Keeper__c = true, Dealer_Complaint_Manager__c = true);
        insert conSales;
        
        Contact con2 = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true);
        
        // When insert/update an other complaint gate keeper contact, it will show a error message
        try {
            insert con2;
        }
        catch(Exception ex) {
            String errorMessage = ex.getMessage();
            system.assert(errorMessage.indexOf('The Dealer already has a Dealer Complaint Gate Keeper.') != -1);
        }
        
        Contact con3 = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Manager__c = true);
        
        // When insert/update an other lead gate keeper contact, it will show a error message
        try {
            insert con3;
        }
        catch(Exception exc) {
            String errorMessage = exc.getMessage();
            system.assert(errorMessage.indexOf('The Dealer already has a Dealer Complaint Manager.') != -1);
        }
    }
    
    private static testMethod void CopyContactInfoToDealerTest() {
        // Create Dealer
        // 
        // 
        createTestData();
        contact.Dealer_Complaint_Manager__c = true;
        contact.Dealer_Presales__c = true;
        contact.Dealer_CRM_Manager__c = true;
        contact.Dealer_Marketing_Manager__c = true;
        update contact;
      /*  
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        // Create Contact
        Contact con = new Contact(AccountId = dealer.Id, FirstName = 'a', LastName = 'b', Name_English__c = 'c', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Manager__c = true);
        insert con;

        Contact con2 = new Contact(AccountId = dealer.Id, FirstName = 'a', LastName = 'b', Name_English__c = 'c', Phone = '1212313', email = 's@s.s', Dealer_Presales__c = true);
        insert con2;
        
        Contact con3 = new Contact(AccountId = dealer.Id, FirstName = 'a', LastName = 'b', Name_English__c = 'c', Phone = '1212313', email = 's@s.s', Dealer_CRM_Manager__c = true);
        insert con3;
        
        Contact con4 = new Contact(AccountId = dealer.Id, FirstName = 'a', LastName = 'b', Name_English__c = 'c', Phone = '1212313', email = 's@s.s', Dealer_Marketing_Manager__c = true);
        insert con4;*/
        
        Account dealer = [SELECT Dealer_Marketing_Manager_Email__c, Dealer_CRM_Manager_Email__c, Dealer_Complaint_Manager__c, Dealer_Complaint_Manager_Email__c, Dealer_Presales__c, Dealer_Presales_Email__c FROM Account WHERE Id = :account.Id];
        
        // Assert updated Dealer Complaint Manager of Dealer is eqauals with contact's firstname, lastname, englishname and phone
        System.assert(dealer.Dealer_Complaint_Manager__c == 'a b<br>c<br>1212313');
        
        // Assert updated Dealer Complaint Manager Email of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_Complaint_Manager_Email__c == 'test@test.com');
        
        // Assert updated Dealer Presales of Dealer is eqauals with contact's firstname, lastname, englishname and phone
        System.assert(dealer.Dealer_Presales__c == 'a b<br>c<br>1212313');
        
        // Assert updated Dealer Presales Email of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_Presales_Email__c == 'test@test.com');
        
        // Assert updated Dealer crm manager Email of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_CRM_Manager_Email__c == 'test@test.com');
        
        // Assert updated Dealer marketing manager Email of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_Marketing_Manager_Email__c == 'test@test.com');
    }
    
    @isTest
    public static void testCopyAftersalesManagerInfoToDealer()
    {
        createTestData();
        test.startTest();
        ContactHelper.copyAftersalesManagerInfoToDealer(new String[]{contact.Id});
        test.stopTest();
    }
    
    
    public static  testmethod void test_CopyComplaintManagerInfoToDealer()
    {
        createTestData();
        List<Contact> contacts = new List<Contact>();
        contacts.add(contact);
        test.startTest();
        
        ContactHelper.CopyComplaintManagerInfoToDealer(contacts);
        test.stopTest();
        //system.assertEquals('test@test.com', account.Dealer_Complaint_Manager_Email__c);
    }
    
    
    static void createTestData()
    {
        account = new Account();
        account.Name = 'account name';
        account.Phone = '10086';
        account.Area_Code__c = '010';
        account.Fax = '10086';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
        
        contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = 'test@test.com';
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = account.Id;
        insert contact;
        
        
    }
    
    
}