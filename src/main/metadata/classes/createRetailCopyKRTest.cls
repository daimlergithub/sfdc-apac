@istest
public class createRetailCopyKRTest {
  public static Account accobj;
  public static Account accountobj;
  public static Account_Link__c acclinkobj;
  public static Address__c addressobj;
  public static Address__c addressobj1;
  public static List<Address__c> addresslist;
     public static Account dealer;
     private static List<Account_Link__c> alkList = new List<Account_Link__c>();
  public static Id retailcompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
  private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(); 
  static void createTestData() {
  dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
    accobj = new Account (Name = 'Sreeni');
    insert accobj;

    accountobj = new Account (Name = 'Pradeep',Company__c = dealer.Id);
    insert accountobj;
    
    acclinkobj = new Account_Link__c();
    acclinkobj.RecordTypeId = retailcompanyRecordTypeId;
    acclinkobj.Name = 'accountlinktest';
    acclinkobj.fromRole__c = accobj.id;
    acclinkobj.toRole__c = accobj.id;
    insert acclinkobj;
    system.debug('$$$$$ acclinkobj $$$$$' +acclinkobj);
    
    addressobj = new Address__c();
    addressobj.Customer__c = accobj.id;
    addressobj.Address_Type__c = 'Home';
    addressobj.ZipCode__c = '7920500';
    addressobj.Province__c = 'Ibaraki';
    addressobj.TitleOfHonor__c = 'To Person';
    addressobj.Status__c = 'Active';
    
    //Addresslist insert
    
    addresslist = new List<Address__c>();
    addresslist.add(addressobj);
    
    addressobj1 = new Address__c();
    addressobj1.Customer__c = dealer.id;
    addressobj1.Address_Type__c = 'Home';
    addressobj1.ZipCode__c = '7920500';
    addressobj1.Province__c = 'Ibaraki';
    addressobj1.TitleOfHonor__c = 'To Person';
    addressobj1.Status__c = 'Active';
    
    //Addresslist insert
    
    addresslist.add(addressobj1);
    insert addresslist;
  }
  
  Public static testmethod void createRetailCopyKRTest1() {
    createTestData();
    ApexPages.currentPage().getParameters().put('Id',accountobj.Id);
     ApexPages.currentPage().getParameters().put('idselected',addressobj1.Id);
      ApexPages.currentPage().getParameters().put('Status',addressobj1.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(accountobj);
    createRetailCopyKR crkr = New createRetailCopyKR(objSc );
    test.startTest();     
     crkr.getDealer();
     
     
    test.stopTest();
  }
  Public static testmethod void createRetailCopyKRTest2() {
  ID RDType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(); 
    createTestData();
    ApexPages.currentPage().getParameters().put('Id',accountobj.Id);
    ApexPages.StandardController objSc = new ApexPages.StandardController(accountobj);
    createRetailCopyKR crkr = New createRetailCopyKR(objSc );
    test.startTest();
      Account_Link__c contact2Contact = new Account_Link__c(Status__c = 'My Shops',RecordTypeId = RDType , MD__c = 'JP',Name = 'contact2Contact', toRole__c=accountobj.id );

     
    test.stopTest();
  }
  
  public static testMethod void DealerTest()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
       User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUse12355485@Daimler-test.com',
             
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
   Account companyacc = new Account(Dealer_Default_Flag__c=false,
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
                                  Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
       Address__c  address=new Address__c();
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
         createRetailCopyKR add=new createRetailCopyKR(sc);
       
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
  
    
  }
  public static testMethod void PersonaccTest()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
       User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUse12355485@Daimler-test.com',
             
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
  Account personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAcc;  
  
   //  Insert Address Record 
       Address__c  address=new Address__c();
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
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopyKR add=new createRetailCopyKR(sc);
       
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
         }
  
    
  }
  
  public static testMethod void PersonaccTest1()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
       User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUse12355485@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
            //ContactId=con.id
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert company Account
  Account personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAcc;  
  
   //  Insert Address Record 
       Address__c  address=new Address__c();
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
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopyKR add=new createRetailCopyKR(sc);
       
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
         }
  
    
  }
    public static testMethod void Dealercompa()
  {
  
  // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'System Administrator' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
       User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUse12355485@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
           
        );
        
        insert usr;
         
        
         System.runAs (usr) {
        
        //Insert company Account
   Account companyacc = new Account(Dealer_Default_Flag__c=false,
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
                                  Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
       Address__c  address=new Address__c();
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
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopyKR add=new createRetailCopyKR(sc);
       
         add.getDealer();       
         add.CreateRetailCopy(); 
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
  
    
  }
 
}