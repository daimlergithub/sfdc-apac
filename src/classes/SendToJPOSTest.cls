/***********************************************************************************
Created By          :    Venky    
Created Date        :    15.12.2016
Company             :    NTT Data,Inc.
Usage               :    This class written to cover the test code covergae for  SendToJPOS class

MODIFICATION DETAILS:

1. Modified By      :    Venky
   Modifide Date    :    18.1.2017
   Deatils          :Fixed test class failure and improved code coverage.
                          
************************************************************************************/

@isTest
 public class SendToJPOSTest {
 
  private static List<Account> accountlist = new List<Account>();
  private static List<Account_Link__c> alkList = new List<Account_Link__c>();
  private static Account account;
  private static Address__c address;
  private static Account personAcc;
  private static Account companyacc;
  public static Account dealer;
  public static Contact con ;
  public static user usr;  
  public static user Salesconusr;
  public static account DealerAcc;
  public String MyMercedesID;
  public static Profile DealerUserId = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
  Public Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
  public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];
  public static Profile JapanUserprofile = [select Id from Profile where Name = 'Japan Data Management' limit 1];  
  private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
  
  
  
  
  
  public static testMethod void DealerUserTest()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
         //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = JapanUserprofile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            DMS_UserID__c='venky4'
        );
        
               
  }
  insert usr; 
  system.debug('#$#$#$#$$# usr'+usr);
   //  Insert person Account 
   personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
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
                               Company__c=dealer.id,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
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
        
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True,Retail_Sales_Consultant__c=usr.id, ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         SendToJPOS spo=new SendToJPOS(sc);
         spo.SendToJPOS();
         spo.getDealer();
         spo.getSelected();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
  
  }
  
  public static testMethod void CompanyTest()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
         //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = JapanUserprofile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            DMS_UserID__c='venky4'
        );
        
               
  }
  insert usr; 
  system.debug('#$#$#$#$$# usr'+usr);
   //  Insert person Account 
   personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
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
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
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
        
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True,Retail_Sales_Consultant__c=usr.id, ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         SendToJPOS spo=new SendToJPOS(sc);
         spo.SendToJPOS();
         spo.getDealer();
         spo.getSelected();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
  
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
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
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
            ContactId=con.id
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
                                MD__c = 'JP',
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
        
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         SendToJPOS spo=new SendToJPOS(sc);
         spo.SendToJPOS();
         spo.getDealer();
         spo.getSelected();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
  
  }
  
   public static testMethod void DealerPersonAccTest()
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
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
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
            DMS_UserID__c='venky'
        );
        
        insert usr;
        
         System.runAs (usr) {
        
   //  Insert person Account 
  account  personAccount = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
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
                               Company__c=dealer.id,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAccount;  
  
  
  
   //  Insert Address Record 
       address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAccount.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
      //  Profile DealerUserId = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
      
        
         
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = personAccount.id,Retail_Sales_Consultant__c=usr.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
       //string AssignedDealerUserID=acclnk.Retail_Sales_Consultant__r.id;
        system.debug('$%$$$%%$ acclnk'+acclnk);
       //user u=[SELECT Market__c,IsPortalEnabled,DMS_UserID__c,contactid,Id FROM User WHERE Id = :AssignedDealerUserID];
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = personAccount.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAccount.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAccount);
         SendToJPOS spo=new SendToJPOS(sc);
         spo.SendToJPOS();
         spo.getDealer();
         spo.getSelected();
         test.StopTest();
         system.assertNotEquals(personAccount,null);
         }
  
  }
  
  
 }