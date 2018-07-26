@isTest
public class createRetailCopyTest {
 
   private static List<Account> accountlist = new List<Account>();
   private static Account account;
   private static Address__c address;
   private static Account personAcc;
   private static Account companyacc;
   public static Account dealer;
   public static Contact con ;
   public static user usr; 
   public static user Dealerusr;
   private static List<Account_Link__c> alkList = new List<Account_Link__c>();
    private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
	  public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
      public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
   public static Account accobj;
  public static Account accountobj;
  public static Account_Link__c acclinkobj;
  public static Address__c addressobj;
  public static Address__c addressobj1;
    public static Address__c Peraddressobj;
  public static Address__c Comaddressobj;
  public static List<Address__c> addresslist;
     //public static Account dealer;
	 
   //  private static List<Account_Link__c> alkList = new List<Account_Link__c>();
  public static Id retailcompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
  //private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId(); 
  
     Public static void CreateUserTH()   
{	// create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
       // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Dealerusr = new User(
           // Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            Username =  String.valueof(DateTime.now().getTime())+ 'testDaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
			Market__c='TH',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id
        );
        
        insert Dealerusr;
		Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
		usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TH',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert usr;
		
		}
    
  Public static void personAccountTestData()
  {
        
   dealer = (Account)UtilTestData.createSobject(new Account(Market__c='TH'), UtilTestData.ACCOUNT_RT_DEALER);
  personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
							   Market__c = 'TH',
                               LastName = 'abcd',
                               FirstName = 'efgh',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '12347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                          		Corporate_Category__c ='Business Partner',
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAcc;  
        
      
       
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '023482832';
        account.Data_Source__c  = 'Test4';
       	account.Market__c='TH';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.market__c='TH';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        address.TitleOfHonor__c = 'To Person';  
        address.Market__c='TH';
        address.State__c = 'Bangalore';
         address.ZipCode__c = '2345';
      address.Country__c = 'Thailand';
        insert address;
  }     
 
 
  Public static void createCompanyAccTestData()
 {
 
        companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'TH',
                                Market__c =  'TH',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '10034',
                                Mobile__c = '023482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Main_Dealer__c = dealer.Id,
                                 Corporate_Category__c ='Business Partner',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
      //accountlist.add(companyacc);
        
     // insert accountlist;  
      
       
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '023482832';
        account.Data_Source__c  = 'Test4';
        account.MD__c='TH';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
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
        address.Market__c='TH';
        address.State__c = 'Bangalore';
         address.ZipCode__c = '2345';
     address.Country__c = 'Thailand';
        insert address;
   }
 
  public static testMethod void PersonAccTestData()
  {
          CreateUserTH();
               System.runAs (usr) {
                   
          personAccountTestData();
                 
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
                   
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
           ApexPages.currentPage().getParameters().put('idSelected',address.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       
       }
    
        
  }
  
 public static testMethod void CompanyAccTestData()
  {
  
   CreateUserTH();
       System.runAs (usr) {
          createCompanyAccTestData();
         
           Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
           
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       ApexPages.currentPage().getParameters().put('idselected',address.id);   
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       }

        
  }
   public static testMethod void PersonAccDealTestData()
  {
          CreateUserTH();
               System.runAs (Dealerusr) {
                   
          personAccountTestData();
                 
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
                   
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
           ApexPages.currentPage().getParameters().put('idSelected',address.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       
       }
    
        
  }
  
 public static testMethod void CompanyAccDealTestData()
  {
  
   CreateUserTH();
       System.runAs (Dealerusr) {
          createCompanyAccTestData();
         
           Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
           
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       ApexPages.currentPage().getParameters().put('idselected',address.id);   
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       }

        
  }
     public static testMethod void PersonAcc11TestData()
  {
          CreateUserTH();
               System.runAs (usr) {
                   
          personAccountTestData();
                 
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
                   
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
           ApexPages.currentPage().getParameters().put('idSelected',address.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       
       }
    
        
  }
  
 public static testMethod void CompanyAcc11TestData()
  {
  
   CreateUserTH();
       System.runAs (usr) {
          createCompanyAccTestData();
         
           Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
           
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       ApexPages.currentPage().getParameters().put('idselected',address.id);   
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       }

        
  }
 
        public static testMethod void PersonAccDeal11TestData()
  {
          CreateUserTH();
               System.runAs (Dealerusr) {
                   
          personAccountTestData();
                 
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
                   
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
           ApexPages.currentPage().getParameters().put('idSelected',address.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       
       }
    
        
  }
  
 public static testMethod void CompanyAccDeal11TestData()
  {
  
   CreateUserTH();
       System.runAs (Dealerusr) {
          createCompanyAccTestData();
         
           Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
           
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
       ApexPages.currentPage().getParameters().put('idselected',address.id);   
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
       }

        
  }
 
 public static testMethod void DealerTest()
  {
      try{
          // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(Market__c='TH'), UtilTestData.ACCOUNT_RT_DEALER);
         
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management',Market__c='TH', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
       // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       
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
			Market__c='TH',
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
                                MD__c = 'TH',
                            Market__c =  'TH',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '10035',
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
		address.Market__c = 'TH';
         

        insert address;
        
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'TH', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'TH',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
        ApexPages.currentPage().getParameters().put('idselected',address.id);   
             ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
          system.assertEquals(createRetailCopy.AccId,companyacc.id);       
          system.assertNotEquals(companyacc,null);    
         test.StopTest();
        
         }
  
    
  		

      }catch(Exception e){
          
      }
  
  }
    
     static void createuserANZ() {
          Profile systemadm = [select Id from Profile where Name = 'System Administrator' limit 1];
 
	
  
      dealer = (Account)UtilTestData.createSobject(new Account(Market__c='AU'), UtilTestData.ACCOUNT_RT_DEALER);
      
    accobj = new Account (Name = 'SreeDealer',Corporate_Category__c ='Business Partner', Individual_Home_Phone__c = '+61485967485', Market__c = 'AU');
    insert accobj;
	
       Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
       usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUse12355485@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = systemadm.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            Market__c = 'AU',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
          //  ContactId=con.id
        );
        
        insert usr;
   
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Dealerusr = new User(
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
           market__c ='AU',
            ContactId=con.id
        );
      
      insert Dealerusr; 
     }

  static void createTestDataANZ() {
      
 
     companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+61485967485',Work_Phone__c = '+61485967485',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',
                                City__c='Beijing', 
                                Phone = '+61485967485',
                                MD__c = 'AU',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                ZipCode__c= '3465',
                                Mobile__c = '+61485967485',
                                Primary_Email__c = 'Email1@email.com',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Company__c=dealer.id,
                                  Main_Dealer__c = dealer.Id,
                                    Market__c ='AU', 
                                    Fax = '+61485967485',
                                    Corporate_Category__c ='Business Partner',
                                    Retail_Work_Phone__c = '+61485967485',
                                    Special_Care__c ='Test',
                                    country__c ='Australia',
                                    Salutation__c = 'Doc',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
  
  
   //  Insert Address Record 
         Comaddressobj=new Address__c();
        Comaddressobj.Address_Type__c='Home';
        Comaddressobj.Province__c='test1';
        Comaddressobj.City__c='bangalore';
        Comaddressobj.District__c='test2';
        Comaddressobj.Block__c='test3';
        Comaddressobj.Address_Line_1__c='testaddress1';
        Comaddressobj.Address_Line_2__c='testaddress2';
			Comaddressobj.State_City__c = 'ACT';
			Comaddressobj.Country__c ='Australia';
			Comaddressobj.ZipCode__c = '5478';
			Comaddressobj.market__C = 'AU';             
        Comaddressobj.Customer__c=companyacc.id;
        Comaddressobj.TitleOfHonor__c = 'To Person';  
     
        insert Comaddressobj;
		
		  //Insert company Account
   personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+61485967485',Work_Phone__c = '+61485967485',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '+61485967485',
                               MD__c = 'AU',
                                  Market__c ='AU',
                               MBK_Data_Source__c='Campaign',   
                               LastName = 'galaxy',
                               FirstName = 'FirstName',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '2347',
                               Mobile__c = '+61485967485',
							Primary_Email__c = 'Email1@email.com',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId = accPerson_RecordTypeId );
       
       insert personAcc;  
  
   //  Insert Address Record 
         Peraddressobj=new Address__c();
        Peraddressobj.Address_Type__c='Home';
        
        
        Peraddressobj.Address_Line_1__c='testaddress1';
        Peraddressobj.Address_Line_2__c='testaddress2';
        Peraddressobj.Customer__c=personAcc.id;
        Peraddressobj.TitleOfHonor__c = 'To Person';  
		Peraddressobj.State_City__c = 'NSW';
		Peraddressobj.Country__c ='Australia';
		Peraddressobj.ZipCode__c = '5478';
        Peraddressobj.market__c = 'AU';
    Peraddressobj.District__c='test2';
    Peraddressobj.State__c = 'Bangalore';
    Peraddressobj.Province__c='test1';       
        insert Peraddressobj;
		
		           //creating custom setting 
           Operation_Mapping__c om = New Operation_Mapping__c();
           om.Operation_Parameters__c = 'Account;Account_Link__c;RetailCopy';
               om.Name = 'RetailCopy';
               insert om; 
           Operation_Mapping__c om1 = New Operation_Mapping__c();
           om1.Operation_Parameters__c = 'Address__c;Account_Link__c;AddressRetailCopy';
               om1.Name = 'AddressRetailCopy';
               insert om1; 
			Operation_Mapping__c om2 = New Operation_Mapping__c();
           om2.Operation_Parameters__c = 'Account_Link__c;Address__c;AddressRetailCopy';
               om2.Name = 'AddressWholesaleCopy';
               insert om2; 
			 Operation_Mapping__c om3 = New Operation_Mapping__c();
           om3.Operation_Parameters__c = 'Account_Link__c;Account;RetailCopy';
               om3.Name = 'WholesaleCopy';
               insert om3; 
 
 
		
		
  }
    
   public static testMethod void PersonaccANZTest()
  {
  		createuserANZ();
	       
         System.runAs (usr) {
        
		createTestDataANZ();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
		ApexPages.currentPage().getParameters().put('idselected',Peraddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
  public static testMethod void PersonaccANZ1Test()
  {
  
		
        	createuserANZ();
         System.runAs (usr) {
        createTestDataANZ();
		
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
		ApexPages.currentPage().getParameters().put('idselected',Peraddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
      public static testMethod void CompanyAccANZTest()
  {
  
        createuserANZ();
         System.runAs (usr) {
        createTestDataANZ();
		
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',companyacc.id);
		ApexPages.currentPage().getParameters().put('idselected',Comaddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
    
     public static testMethod void CompanyAccANZ1Test()
  {
  
		
 createuserANZ();        
         System.runAs (usr) {
        createTestDataANZ();
		
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',companyacc.id);
		ApexPages.currentPage().getParameters().put('idselected',Comaddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
  
 public static testMethod void PersonaccANZ2Test()
  {
  
		        createuserANZ();  
         System.runAs (Dealerusr) {
        createTestDataANZ();

		
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
		ApexPages.currentPage().getParameters().put('idselected',Peraddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
  public static testMethod void PersonaccANZ3Test()
  {
  
		
        createuserANZ();  
         System.runAs (Dealerusr) {
        
		createTestDataANZ();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = personAcc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = personAcc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',personAcc.id);
		ApexPages.currentPage().getParameters().put('idselected',Peraddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
      public static testMethod void CompanyAccANZ2Test()
  {
  
		
        createuserANZ(); 
         System.runAs (Dealerusr) {
        
		createTestDataANZ();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',companyacc.id);
		ApexPages.currentPage().getParameters().put('idselected',Comaddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }
    
    
     public static testMethod void CompanyAccANZ3Test()
  {
  
		
           createuserANZ(); 
         System.runAs (Dealerusr) {
        
		createTestDataANZ();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Market__c = 'AU',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
		
        test.StartTest();
        ApexPages.currentPage().getParameters().put('id',companyacc.id);
		ApexPages.currentPage().getParameters().put('idselected',Comaddressobj.Id);
                  
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy add=new createRetailCopy(sc);
		 add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         
         }
  
    
  }  
    
}