@isTest
public class ContactHelperMYTest {
    public static Account account;
    public static Contact contact;
    public static Contact contact1;
    public static String testEmail = 'test@test.com';
    public static List<Contact> contacts;
    public static User portaluser;
    public static User portaluser1;
    public static User user2;
    public static User user1;
    
    static void createTestData()
    {
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        
        System.runAs (user1) {
            Trigger__c TriggerContact = new Trigger__c(Name='ContactTriggerMY',Trigger_Name__c='ContactTrigger',Trigger_Handler__c='ContactTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
            upsert TriggerContact;
            
            PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
            
            CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            insert sea;
            
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
      
            user2 = UtilTestData.createPersornaUser(ps, p1);
            user2.userroleid = portalRole.id;
            insert user2;
        }
        
        System.runAs(user2){
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
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
            contact1.AccountId = account.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;
            
            Id p = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1].id;
            portaluser = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[0].Id,
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
            
            portaluser1 = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[1].Id,
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser1;
            
      }
    }
    
    Public static testMethod void assignGateKeeperToDealerTest()
      {
          createTestData();
          test.startTest();
          System.runAs(user2){
              Contact con3 = new Contact(id = contacts[0].Id, Dealer_Lead_Gate_Keeper__c = true);        
              update con3;
          }
          test.stopTest();
      }
    
    Public static testMethod void assignGateKeeperToDealerTest2()
      {
          createTestData();
          test.startTest();
          System.runAs(user2){
              Contact con3 = new Contact(id = contacts[0].Id, Dealer_Lead_Gate_Keeper__c = true);        
              update con3;
              con3.Dealer_Lead_Gate_Keeper__c = false;
              update con3;
              Contact newcon = new Contact(id = contacts[1].Id, Dealer_Lead_Gate_Keeper__c = true);
              update newcon;
          }
          test.stopTest();
      }
}