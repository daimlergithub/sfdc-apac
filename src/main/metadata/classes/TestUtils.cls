/*******************************************************************************************
* Class:                TestUtils
* Description:          Utility class used by all test classes to create data for testing
* ------------------------------------------------------------------------------------------
* Date                  Name                        Modification Description
* 17-May-2017           Shruthi Aipanjiguly         Created
* 25-May-2017           Sarath                      Created IntegrationAPI user for phone formatIssue
==========================================================================================*/

@istest
public class TestUtils {
    
    /* Creation of users for different roles  - Begin */
    // Admin User Creation
     public static User createAdminUser(){               
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User u = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusr@daimler.com',Market__c = 'TH');
        insert u;
        return u;
    }
 
    // After Sales Manager User Creation
    public static User createAfterSalesManager(){       
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        UserRole role= [Select Id,name From UserRole Where name ='AfterSalesManager'];
        User user1 = new User(LastName='User',UserRoleId = role.id,country='Australia',firstName='BCI',ProfileId=p.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='aftersalesmanager@testing.com',UserName='aftersales@test.com');
        insert user1;
        return user1;
    }
    
    // Country specific user - TH Dealer Delegate Admin Creation
    public static User createDDAdminUSer(id con){       
        Profile p2 = [select id from profile where Name='Thailand Dealer Delegate Admin'];
        User userB = new User(alias = 'test123', email='test123@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p2.id, country='Australia',IsActive =true,
                              ContactId = con,
                              timezonesidkey='America/New_York', username='UserBAHTH1@noemail.com');
        Insert userB;
        return userB;
    }
    
    // Integration API user - Phone Formatting 
    public static User IntegrationAPIUser(){       
        Profile p3 = [select id from profile where Name='IntegrationAPI'];
        User userC = new User(alias = 'test123', email='test123@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p3.id, country='Thailand',IsActive =true,
                              timezonesidkey='America/New_York', username='UserBAHTH2@noemail.com');
        Insert userC;
        return userC;
    }
    
    /* Creation of users for different roles - End */
    
    
    /* Creation of test records in various objects  - Begin  */
    // Creation of a person account
     public static Account createPersonAccountAsUserAsOwner(user U){      
        Account a = new Account(FirstName = u.FirstName,LastName = u.LastName);
        a.Dealer_Default_Flag__c   = false;
        a.Dealer_DMS_SR_Code__c    = 'test code 2';
        a.Home_Phone_2__c          = '02202123626';
        a.Work_Phone__c            = '+6612123799';
        a.Status__c                = 'NoCustomer';
        a.Email__c                 = 'testmail@test.com';
        a.Email2__c                = 'teemail2@test.com';
        a.Email3__c                = 'temail3@test.com';
        a.City__c                  = 'Beijing';
        a.Gender__c                = 'Male';
        a.Phone                    = '0802101110';
        a.Individual_Home_Phone__c = '+6612323789';
        a.Area_code__c             = '0101';
        a.MD__c                    = 'TH';
        a.Postal_Opt_Out__c        = True;
        a.Province__c              = 'Shanghai';
        a.ZipCode__c               = '32703';
        a.Primary_Email__c         = 'Email1';
        a.Primary_Fax__c           = 'FAX2';
        a.Primary_Phone__c         = 'Other2';
        a.PersonDoNotCall          = True;
        a.ownerid                  = u.id;
        a.PersonHasOptedOutOfEmail = true;
        a.Opt_In_Email__c          = true;
       
        a.PersonBirthdate          = date.today();
        a.Foundation_Date__c       = date.today()+1;
        a.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert a;
        return a;
    }
    
    
    
// Creation of a company account (B2B)
    public static Account createCompanyAccount(User U){             
        Account a = new Account(Name = u.LastName);
        a.Dealer_Default_Flag__c=false;
        a.Dealer_DMS_SR_Code__c='test code 2';
        a.Home_Phone_2__c = '02202123626';
        a.Work_Phone__c ='+6612123799';
        a.Mobile__c ='+66121237993';
        a.Mobile2__c ='+66121238003';
        a.Status__c='NoCustomer';
        a.Email__c = 'testmail@test.com';
        a.Email2__c = 'teemail2@test.com';
        a.Email3__c = 'temail3@test.com';
        a.City__c='Beijing';
        a.Gender__c = 'Male';
        a.Phone = '0802101110';
        a.Individual_Home_Phone__c='+6612323789';
        a.Area_code__c = '0101';
        a.MD__c = 'TH';
        a.Postal_Opt_Out__c=True;  
        a.Province__c = 'Shanghai';
        a.ZipCode__c= '32703';
        a.Primary_Email__c = 'Email1';
        a.Primary_Fax__c = 'FAX2';
        a.Primary_Phone__c ='Other2';
        a.PersonDoNotCall=false;
        a.ownerid=u.id;
        a.PersonHasOptedOutOfEmail=false;
        a.Opt_In_Email__c=true;
        a.Foundation_Date__c=date.today()+1;
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        insert a;
        return a;
    }
    
    //update account
    public static Account UpdateAccount(Id AccID){
        Account Acc = new Account();
        Acc.ID = AccId;
        Acc.Home_Phone_2__c = '03202244644';
        Acc.Work_Phone__c ='+6656123000';
        Acc.Phone = '0802109999';
        Acc.Email__c = 'UpdatedEmail@test.com';
        update Acc;
        Return Acc;
    }
    
    // Creation of Contact
    public static Contact createContact(String name, Id acc){           
        Contact con = new Contact(LastName =name,AccountId = acc);
        insert con;
        return con;
    }
    
    // Creation of Contract
    public static Contract createContract(Id acc){                      
        Contract contr=new Contract(AccountId=acc,StartDate=date.today(),ContractTerm=4,Status='Draft');
        insert contr;
        return contr;
    }
    
    // Creation of Account Link
    public static Account_Link__c createAccLink(String rectype, Id AccId){          
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(rectype).getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = AccId, ReCordTypeId = RetailPerson);
        insert acclnk;
        return acclnk;
    }
    
    // Creation of Address
    public static Address__c createAddress(Id AccId){                   
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '32703';
        address.Customer__c=AccId;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='TH';
        insert address;
        return address;
    }
    
    
    /* Creation of test records in various objects  - End */
}