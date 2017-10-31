@isTest
private class ContactHelperTest {
    
    public static Account account;
    public static Contact contact;
    public static String testEmail = 'test@test.com';
    public static List<Contact> contacts;
    
    public static testMethod void ValidateGateKeepersAndManagerTest() { 
        Trigger__c TriggerContact = new Trigger__c(Name='ContactHandler',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        upsert TriggerContact;
        // Create Dealer 
        
        createTestData();
        test.startTest();        
         ContactHelper.copyAftersalesManagerInfoToDealer(new String[]{contact.Id});       
        ContactHelper.CopyComplaintManagerInfoToDealer(contacts);        
        test.stopTest();
        system.assertNotEquals(null,contact.id);
    }
    
     Public static testMethod void CopyPresalesInfoToDealerTest()
      {
      Trigger__c TriggerContact = new Trigger__c(Name='ContactHandler',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        upsert TriggerContact;
         // Create Dealer         
          createTestData();
          test.startTest();
          Contact con2 = new Contact(AccountId = account.Id, LastName = 'b', Phone = '12123131', email = 's@s.s1', Dealer_Complaint_Gate_Keeper__c = true);       
         insert con2;              
        con2.LastName='a';
          update con2;
           ContactHelper.CopyPresalesInfoToDealer(contacts);
           test.stopTest();
            System.assert(!contacts.isempty());
      }
      
        Public static testMethod void CopyCRMManagerInfoToDealerTest()
      {
       Trigger__c TriggerContact = new Trigger__c(Name='ContactHandler',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        upsert TriggerContact;
         // Create Dealer         
          createTestData();
          test.startTest();
          Contact con3 = new Contact(AccountId = account.Id, LastName = 'b', Phone = '12123132', email = 's@s.s2', Dealer_Complaint_Manager__c = true);        
          insert con3;
           ContactHelper.CopyCRMManagerInfoToDealer(contacts);
           test.stopTest();
           system.assertEquals(con3.Dealer_Complaint_Manager__c,true);
      }
      
       Public static testMethod void copyMarketingManagerInfoToDealerTest()
      {
       Trigger__c TriggerContact = new Trigger__c(Name='ContactHandler',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        upsert TriggerContact;
         // Create Dealer         
          createTestData();
          test.startTest();
           ContactHelper.copyMarketingManagerInfoToDealer(contacts);
           test.stopTest();
           System.assert(!contacts.isempty());
      }
      
    private static testMethod void CopyContactInfoToDealerTest() {
     Trigger__c TriggerContact = new Trigger__c(Name='ContactHandler',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        upsert TriggerContact;
       
        createTestData();
        Test.StartTest();
        Account dealer = [SELECT Dealer_Marketing_Manager_Email__c, Dealer_CRM_Manager_Email__c, Dealer_Complaint_Manager__c, Dealer_Complaint_Manager_Email__c, Dealer_Presales__c, Dealer_Presales_Email__c FROM Account WHERE Id = :account.Id];
         Test.StopTest();
       
        // Assert updated Dealer Presales Email of
        //  Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_Presales_Email__c == testEmail);
        
        // Assert updated Dealer crm manager Email
        //  of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_CRM_Manager_Email__c == testEmail);
        
        // Assert updated Dealer marketing manager 
        // Email of Dealer is eqauals with contact's email
        System.assert(dealer.Dealer_Marketing_Manager_Email__c == testEmail);
    }
    
    
    static void createTestData()
    {
        account = new Account();
        account.Name = 'account name';
        account.Phone = '012310086';
        account.Area_Code__c = '010';
        account.Fax = '012310086';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.Dealer_Presales_Email__c=testEmail;
        account.Dealer_CRM_Manager_Email__c =testEmail;
        account.Dealer_Marketing_Manager_Email__c=testEmail;
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.Dealer_Complaint_Manager__c='true';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
        
        contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = testEmail;
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = account.Id;
        contact.Dealer_Presales__c = true;
       // insert contact;
        
         contacts = new List<Contact>();
        contacts.add(contact);    
        insert contacts;
        
        
    }
    
    
}