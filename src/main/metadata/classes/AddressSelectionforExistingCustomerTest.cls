/***********************************************************************************
Created By          :    Venky    
Created Date        :    22.12.2016
Company             :    NTT Data,Inc.
Usage               :    This class written to cover the test code covergae for  AddressSelectionforExistingCustomer class

MODIFICATION DETAILS:

1. Modified By      :    Venky
   Modifide Date    :    25.1.2017
   Deatils          :Fixed test class failure and improved code coverage.
2. Modified By      :    Versha
   Modifide Date    :    28.3.2018
   Deatils          :Fixed test class failure and improved code coverage.
                          
************************************************************************************/

@isTest
public class AddressSelectionforExistingCustomerTest {
 
    private static List<Account> accountlist = new List<Account>();
    private static Account account;
    private static Address__c address;
    private static Account personAcc;
    private static Account companyacc;
    public static Account dealer;
    public static Contact con ;
    public static user usr; 
    private static List<Account_Link__c> alkList = new List<Account_Link__c>();
    private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void DealerTest1()
    {
      // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
       // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest1'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,
            Market__c='MY'
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
     personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'MY',
                               LastName = '刈乾冠寒刊勘',
                               FirstName = '刈乾冠寒刊勘',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=accPerson_RecordTypeId);
                                                   
       insert personAcc;  
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.md__c='MY';    
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
             // system.debug(')))))))))))))))))))))))'+personAcc.id);    
             ApexPages.currentPage().getParameters().put('id',personAcc.id);
             ApexPages.currentPage().getParameters().put('idselected',address.id);     
             //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
             AddressSelectionforExistingCustomer add1=new AddressSelectionforExistingCustomer();
             add1.account=personAcc;    
             add1.getSelectedAddress();
             add1.getDealer();       
             add1.CreateRetailCopy();
             add1.cancel();
             add1.did = personAcc.id;
             add1.DealerID = dealer;
         test.StopTest();
        system.assertNotEquals(personAcc,null);
         }
    }
       
  
 
 public static testMethod void DealerTest()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,
            Market__c='MY'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert company Account
   companyacc = new Account(Dealer_Default_Flag__c=false,
                            Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                            Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                            City__c='Beijing', 
                            Phone = '0801801010',
                            Area_code__c = '0101',
                            MD__c = 'MY',
                            name = 'tes company name',
                            //Salutation = 'Unknown',      
                            Province__c = 'Shanghai',
                            ZipCode__c= '1003465',
                            Mobile__c = '024482832',
                            Mobile2__c = '034456232',
                            Primary_Email__c = 'Email2',
                            Primary_Fax__c = 'FAX2',
                            Primary_Phone__c ='Other2',
                            Company__c=dealer.id,
                            Main_Dealer__c = dealer.Id,
                            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
             
      insert companyacc;
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=companyacc.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
       ApexPages.currentPage().getParameters().put('idselected',address.id); 
         AddressSelectionforExistingCustomer add=new AddressSelectionforExistingCustomer();
          add.account=companyacc;    
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         add.cancel();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
    }
  public static testMethod void DealerTest2()
  {
      // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
       // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username ='ASECDTest2'+ System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,
            Market__c='TH'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
     personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                               LastName = '刈乾冠寒刊勘',
                               FirstName = '刈乾冠寒刊勘',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '10023',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=accPerson_RecordTypeId);
                                                   
       insert personAcc;  
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.md__c='TH';    
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        system.debug(')))))))))))))))))))))))'+personAcc.id);    
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
        ApexPages.currentPage().getParameters().put('idselected',address.id);     
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         AddressSelectionforExistingCustomer add2=new AddressSelectionforExistingCustomer();
          add2.getSelectedAddress();
         add2.getDealer();       
         add2.CreateRetailCopy();
         add2.cancel();
         add2.did = personAcc.id;
         add2.DealerID = dealer;
         test.StopTest();
        system.assertNotEquals(personAcc,null);
         }
    }
     
public static testMethod void DealerTest3()
  {
      // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
       // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest3'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //ContactId=con.id,
            Market__c='TH'
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
     personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
                               LastName = '刈乾冠寒刊勘',
                               FirstName = '刈乾冠寒刊勘',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '10023',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=accPerson_RecordTypeId);
                                                   
       insert personAcc;  
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.md__c='TH';    
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
       // system.debug(')))))))))))))))))))))))'+personAcc.id);    
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
        ApexPages.currentPage().getParameters().put('idselected',address.id);     
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         AddressSelectionforExistingCustomer add2=new AddressSelectionforExistingCustomer();
          add2.getSelectedAddress();
         add2.getDealer();     
         add2.did = personAcc.id;
         add2.DealerID = dealer;
         add2.account.Main_Dealer__c = dealer.Id;
         add2.CreateRetailCopy();
         add2.cancel();
         test.StopTest();
        system.assertNotEquals(personAcc,null);
         }
    }     
 public static testMethod void DealerTest4()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest4'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //ContactId=con.id,
            Market__c='MY'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert company Account
   companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', 
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'MY',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Company__c=dealer.id,
                                Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=companyacc.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
       ApexPages.currentPage().getParameters().put('idselected',address.id); 
         AddressSelectionforExistingCustomer add=new AddressSelectionforExistingCustomer();
         add.getSelectedAddress();
         add.getDealer();   
         add.account.Main_Dealer__c = dealer.Id;
         add.CreateRetailCopy();
         add.cancel();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
    }     
     
   public static testMethod void DealerTest5()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest5'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,
            Market__c='TH'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert company Account
   companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', 
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'TH',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '10034',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Company__c=dealer.id,
                                Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=companyacc.id;
        address.TitleOfHonor__c = 'To Person';  
        address.MD__c='TH'; 

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
       ApexPages.currentPage().getParameters().put('idselected',address.id); 
         AddressSelectionforExistingCustomer add=new AddressSelectionforExistingCustomer();
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         add.cancel();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
    }     
    
    public static testMethod void DealerTest6()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username ='ASECDTest6'+ System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //ContactId=con.id,
            Market__c='MY'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert person Account
   personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'MY',
                               LastName = '刈乾冠寒刊勘',
                               FirstName = '刈乾冠寒刊勘',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '10023',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=accPerson_RecordTypeId);
                                                   
       insert personAcc;  
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
       //  ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
       ApexPages.currentPage().getParameters().put('idselected',address.id); 
         AddressSelectionforExistingCustomer add=new AddressSelectionforExistingCustomer();
         add.getSelectedAddress();
         add.getDealer();   
         add.account.Main_Dealer__c = dealer.Id;
         add.CreateRetailCopy();
         add.cancel();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
         }
    }  
     public static testMethod void DealerTest7()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = 'ASECDTest7'+System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            //ContactId=con.id,
            Market__c='TH'
            
        );
        
        insert usr;
         
        
         System.runAs (usr) {
             
        
        //Insert company Account
   companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', 
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'TH',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '13465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Company__c=dealer.id,
                                Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=companyacc.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       //  ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
       ApexPages.currentPage().getParameters().put('idselected',address.id); 
         AddressSelectionforExistingCustomer add=new AddressSelectionforExistingCustomer();
         add.getSelectedAddress();
         add.getDealer();   
         add.account.Main_Dealer__c = dealer.Id;
         add.CreateRetailCopy();
         add.cancel();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
    }     
  
 }