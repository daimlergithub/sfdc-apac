@isTest
public class createRetailCopyTRTest {
    
    private static List<Account> accountlist = new List<Account>();
    private static Account account;
    private static Address__c address;
    private static Account personAcc;
    private static Account companyacc;
    public static Account dealer;
    public static Contact con ;
    public static user user_Obj; 
    public static user usr; 
    private static List<Account_Link__c> alkList = new List<Account_Link__c>();
    private static Id alkIndividualRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    
    
    Public static void personAccountTestData()
    {
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
         user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        system.runAs(user_Obj){   
            dealer = (Account)UtilTestData.createSobject(new Account(market__c='TR'), UtilTestData.ACCOUNT_RT_DEALER);
            personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                    Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '0801801110',
                                    Area_code__c = '0101',
                                    MD__c = 'TR',
                                    Market__c = 'TR',
                                    LastName = '刈乾冠寒刊勘',
                                    FirstName = '刈乾冠寒刊勘',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    data_source__c='Past Data',
                                    ZipCode__c= '12347',
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
            account.market__c='TR';
            account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
            
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='test1';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.market__c='TR';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=personAcc.id;
            address.TitleOfHonor__c = 'To Person';  
            
            
            insert address;
            Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c='TR',ToRole__c = personAcc.id,fromrole__c=account.id, ReCordTypeId = RetailPerson);
            insert acclnk; 
            
        }
    }     
    
    
    Public static void createCompanyAccTestData()
    {
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
         user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        system.runAs(user_Obj){   
            dealer = (Account)UtilTestData.createSobject(new Account(market__c='TR'), UtilTestData.ACCOUNT_RT_DEALER);
            
            companyacc = new Account(Dealer_Default_Flag__c=false,
                                     Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                     Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                     City__c='Beijing',
                                     Gender__c = 'Male',
                                     Phone = '0801801010',
                                     Area_code__c = '0101',
                                     MD__c = 'TR',
                                     Market__c = 'TR',
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
                                     RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            
            insert companyacc;
            //accountlist.add(companyacc);
            
            // insert accountlist;  
            
            
            account= new Account();
            account.Phone='09844650654';
            account.FirstName = 'Test';
            account.Mobile__c = '+905778963214';
            account.Market__c = 'TR';
            account.Data_Source__c  = 'Test4';
            account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
            account.market__c='TR';
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='test1';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.market__c='TR';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=companyacc.id;
            address.TitleOfHonor__c = 'To Person';  
            
            
            insert address;
            
            Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            Account_Link__c acclnkcom = new Account_Link__c(Name = 'Test Name', market__c='TR',ToRole__c = companyacc.id,fromrole__c=account.id, ReCordTypeId = RetailCompany);
            insert acclnkcom;
            
        }
    }
    
    
    
    //TR specific methods
   
        
        
         public static testMethod void PersonAccTestDataTR()
        {
             
        personAccountTestData();
        system.runas(user_Obj){
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',personAcc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
        ApexPages.currentPage().getParameters().put('idselected',address.id);   
        createRetailCopy  add=new createRetailCopy (sc);
        add.getSelectedAddress();
        add.getDealer();       
        add.CreateRetailCopy();
        test.StopTest();
        system.assertNotEquals(personAcc,null);
		}
    }
    
    public static testMethod void CompanyAccTestDataTR()
    {
        
        createCompanyAccTestData();
		system.runas(user_Obj){
        test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',companyacc.id);
        ApexPages.currentPage().getParameters().put('idselected',address.id);   
        ApexPages.StandardController sc = new ApexPages.StandardController(companyacc);
        createRetailCopy  add=new createRetailCopy (sc);
        add.getSelectedAddress();
        add.getDealer();       
        add.CreateRetailCopy();
        test.StopTest();
        system.assertNotEquals(companyacc,null);
		}
    }
    
    
    public static testMethod void DealerTestTR()
    {
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        userrole ur = [select id,name from userrole WHERE Name='Daimler APAC'];  
         user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',userroleid=ur.id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        system.runAs(user_Obj){  
        // create a Dealer
        dealer = (Account)UtilTestData.createSobject(new Account(market__c='TR'), UtilTestData.ACCOUNT_RT_DEALER);
        
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Turkey_Partner_User', market__c='TR',LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Id p = [SELECT Id FROM Profile WHERE usertype='PowerPartner' limit 1].id;
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            
            FirstName = 'firstname',
            ProfileId = p,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            Market__c='TR',
            ContactId=con.id
        );
        
        insert usr;
        
        }
        System.runAs (usr) {
            
            //Insert company Account
            companyacc = new Account(Dealer_Default_Flag__c=false,
                                     Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '023482322',
                                     Status__c='Prospect',Email__c = 'testemail@test.com',
                                     City__c='Ankara', 
                                     Phone = '0801801010',
                                     Area_code__c = '0101',
                                     MD__c = 'TR',
                                     Market__c='TR',
                                     name = 'test company name',
                                     //Salutation = 'Unknown',      
                                     Province__c = 'Ayas',
                                     ZipCode__c= '10035',
                                     Mobile__c = '024482832',
                                     //Mobile2__c = '034456232',
                                     Primary_Email__c = 'Email2',
                                     //Primary_Fax__c = 'FAX2',
                                     Primary_Phone__c ='Other2',
                                     Company__c=dealer.id,
                                     Main_Dealer__c = dealer.Id,
                                     RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
            
            insert companyacc;
            
            
            //  Insert Address Record 
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='Ayas';
            address.City__c='Ankara';
            address.District__c='Ayas';
            //address.Block__c='test3';
            address.Address_Line_1__c='testaddressone';
            address.Address_Line_2__c='testaddresstwo';
            address.Customer__c=companyacc.id;
            address.Market__c='TR';
            //address.TitleOfHonor__c = 'To Person';  
            
            
            insert address;
            
            Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', market__c='TR',ToRole__c = companyacc.id,fromrole__c=dealer.id, ReCordTypeId = RetailPerson);
            insert acclnk;
            Account_Link__c Indacclnk = new Account_Link__c(Name = 'Test Name',Primary__c=True,market__c='TR', ToRole__c = companyacc.id,System__c='My Mercedes',fromrole__c=dealer.id, ReCordTypeId = alkIndividualRecordTypeId);
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
        
        
    }
    /*public static testMethod void DealerTestPersonTR()
    {
        
        // create a Dealer
        dealer = (Account)UtilTestData.createSobject(new Account(market__c='TR'), UtilTestData.ACCOUNT_RT_DEALER);
        
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Turkey_Partner_User', market__c='TR',LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        // User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Id p = [SELECT Id FROM Profile WHERE usertype='PowerPartner' limit 1].id;
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            
            FirstName = 'firstname',
            ProfileId = p,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            Market__c='TR',
            ContactId=con.id
        );
        
        insert usr;
        
        
        System.runAs (usr) {
            
            //Insert Person Account
           personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                    Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '0801801110',
                                    Area_code__c = '0101',
                                    MD__c = 'TR',
                                    Market__c = 'TR',
                                    LastName = '刈乾冠寒刊勘',
                                    FirstName = '刈乾冠寒刊勘',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    data_source__c='Past Data',
                                    ZipCode__c= '12347',
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
            account.market__c='TR';
            account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
            
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='test1';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.market__c='TR';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=personAcc.id;
            address.TitleOfHonor__c = 'To Person';  
            
            
            insert address;
            Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', Market__c='TR',ToRole__c = personAcc.id,fromrole__c=account.id, ReCordTypeId = RetailPerson);
            insert acclnk; 
            test.StartTest();
            ApexPages.currentPage().getParameters().put('Id',PersonAcc.id);
            ApexPages.currentPage().getParameters().put('idselected',address.id);   
            ApexPages.StandardController sc = new ApexPages.StandardController(PersonAcc);
            createRetailCopy  add=new createRetailCopy (sc);
            add.getSelectedAddress();
            add.getDealer();       
            add.CreateRetailCopy();
            system.assertEquals(createRetailCopy.AccId,PersonAcc.id);       
            system.assertNotEquals(PersonAcc,null);    
            test.StopTest();
            
        }
        
        
    }*/
    }