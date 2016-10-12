@istest
public class LeadHelperJPTest 
{
  public Static Account objAccount;
  public static Account objAccount2;  
  public static Account objAccount3; 
  public Static Account DealerAccount;
  public static Lead__C lead1;
  public static Lead__C lead2;
  public static Lead__c lead3;  
  public static Account_Link__c AccLink;
  public static list<Lead__c> leadList = new list<Lead__c>(); 
  public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    
    
    public static testMethod void test_updateCustomerStage1()
    {  
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        System.runAs(u) {
            createTestData();
            test.startTest();
            lead3.CAC_Lead_Status__c = 'Approved';
            update lead3;
            lead1.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            
            update lead1;
            
            Account testAcc = [Select Customer_Lifecycle_Phase__c from Account Where Id =:objAccount2.Id];
            TriggerLeadTriggerHandlerJP TriggerLeadHandlerJP = new TriggerLeadTriggerHandlerJP();
            TriggerLeadHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
            test.stopTest();
            system.assertEquals('Sales Lead', testAcc.Customer_Lifecycle_Phase__c);
        }
        
    }
    public static testMethod void test_updateCustomerStage2()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        System.runAs(u) {
            createTestData();
            test.startTest();
            lead1.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            lead2.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
            update lead1;
            update lead2;            
            Account testAcc = [Select Customer_Lifecycle_Phase__c from Account Where Id =:objAccount.Id];
            test.stopTest();
            system.assertEquals('Care', testAcc.Customer_Lifecycle_Phase__c);
        }
    }
    
    public static testMethod void test_createAccountLinkFromDealer()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
      User u = new User(Alias = 'standt', Email='test@mbj.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        System.runAs(u) {
        createTestData();
        test.startTest();
        lead1.Contact__c = objAccount3.id;
        lead1.CAC_Lead_Status__c = 'Approved';
        
        update lead1;
        
        
        Account_Link__c testAccLink = [Select id from Account_Link__c Where fromRole__c =: objAccount3.id and toRole__c =: DealerAccount.id LIMIT 1];
        test.stopTest();
        system.assertNotEquals(null, testAccLink);
        }
        
                
    }
    
    
    
    static void createTestData()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
         DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        //inserted new address record
        Address__c addr = new Address__c(Customer__c = objAccount.id, Address_Type__c = 'Home', Province__c = 'Hokkaido');
        insert addr;
        //added address reference to address 
        Account objacc = new Account(id = objAccount.id, Primary_Address_Reference__c = addr.id); 
        update objacc;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        objAccount3= new Account();
        objAccount3.RecordtypeId=personAccRecordTypeId;
        objAccount3.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount3.Status__c='Active';
        objAccount3.Province__c='Province1';
        objAccount3.City__c='Test';
        objAccount3.ZipCode__c = '1063723';
        objAccount3.Email__c='test@mbj.com';
        objAccount3.Mobile__c ='0435488899';
        objAccount3.Phone = '08022420181';
        objAccount3.Main_Dealer__c = DealerAccount.id;
        objAccount3.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount3;
        
        
        lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        insert lead1;
        
        
        lead2 = new lead__C();
        lead2.MD__c = 'JP';
        lead2.Contact__c = objAccount.id;
        lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'New';
        insert lead2;
        
        lead3 = new lead__C();
        lead3.MD__c = 'JP';
        lead3.Contact__c = objAccount2.id;
        //lead3.Assigned_Dealer__c = DealerAccount.id;
        lead3.CAC_Lead_Status__c = 'New';
        insert lead3;
           
        
        AccLink = new Account_Link__c();
        AccLink.fromRole__c = objAccount.id;
        AccLink.toRole__c = DealerAccount.id;        
        
        insert AccLink; 
        
    }
    
    
    
    
    
}