@istest
public class createRetailCopyJPTEST
{
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
  
  
  Public static void personAccountTestData()
  {
   dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
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
                               Main_Dealer__c = dealer.Id,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
       insert personAcc;  
        
      
       
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '023482832';
        account.Data_Source__c  = 'Test4';
       
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = personAcc.id,fromrole__c=account.id, ReCordTypeId = RetailPerson);
        insert acclnk; 
  
  }
 
 
  Public static void createCompanyAccTestData()
 {
 
      dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
       
        companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '023482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                 Main_Dealer__c = dealer.Id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
      insert companyacc;
      //accountlist.add(companyacc);
        
     // insert accountlist;  
      
       
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';
        account.Mobile__c = '023482832';
        account.Data_Source__c  = 'Test4';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person';  
         

        insert address;
        
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Account_Link__c acclnkcom = new Account_Link__c(Name = 'Test Name', ToRole__c = companyacc.id,fromrole__c=account.id, ReCordTypeId = RetailCompany);
        insert acclnkcom;
 
 }
 
  public static testMethod void PersonAccTestData()
  {
  
      
        personAccountTestData();
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(personAcc,null);
  }
  
 public static testMethod void CompanyAccTestData()
  {
  
        createCompanyAccTestData();
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
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
        
          Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
        insert acclnk;
         Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True, ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
        alkList.add(Indacclnk) ;
        
        insert alkList;
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
         createRetailCopy  add=new createRetailCopy (sc);
          add.getSelectedAddress();
         add.getDealer();       
         add.CreateRetailCopy();
         test.StopTest();
         system.assertNotEquals(companyacc,null);
         }
  
    
  }
  
}