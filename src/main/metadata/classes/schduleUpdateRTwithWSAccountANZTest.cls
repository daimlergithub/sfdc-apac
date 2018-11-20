@istest
public class schduleUpdateRTwithWSAccountANZTest {
      public static Account dealer;
	  public static User usr;
      public static Address__c address;
      public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
      public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
      public Static testmethod void testMethod1()
      { 
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
		usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert usr;
         System.runAs(usr)
      {     
          
        //inserting person account
        Account a = new Account(FirstName ='FirstName',LastName = 'LastName');
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
        a.MD__c                    = 'AU';  
        a.Market__c                = 'AU';  
        a.Data_Source__c           = 'MBT Event'; 
        a.Postal_Opt_Out__c        = True;
        a.Province__c              = 'Shanghai';
        a.ZipCode__c               = '3273'; 
        a.Primary_Email__c         = 'Email1';
        a.Primary_Fax__c           = 'FAX2';
        a.Primary_Phone__c         = 'Other2';
        a.PersonDoNotCall          = True;
        a.PersonHasOptedOutOfEmail = true;
        a.Opt_In_Email__c          = true;
        a.ID_Number__c             = '1234567891011';  
        a.ID_Type__c = 'National ID';
        a.PersonBirthdate          = date.newInstance(1991,03,18); // Modified By laqshay Arora
        a.Foundation_Date__c       = date.today();
        a.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert a;
        
        // inserting dealer account
        dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        // inserting company account
        Account c = new Account(Name = 'testcompanyAccount');
        c.Dealer_Default_Flag__c=false;
        c.Dealer_DMS_SR_Code__c='test code 2';
        c.Home_Phone_2__c = '02202123626';
        c.Work_Phone__c ='+6612123799';
        c.Mobile__c ='+66121237993';
        c.Mobile2__c ='+66121238003';
        c.Status__c='NoCustomer';
        c.Email__c = 'testmail@test.com';
        c.Email2__c = 'teemail2@test.com';
        c.Email3__c = 'temail3@test.com';
        c.City__c='Beijing';
        c.Gender__c = 'Male';
        c.Corporate_Category__c='Rental';
        c.Phone = '0802101110';
        c.Individual_Home_Phone__c='+6612323789';
        c.Area_code__c = '0101';
        c.MD__c = 'AU'; // Modified by Laqshay Arora
        c.Postal_Opt_Out__c=True;  
        c.Province__c = 'Shanghai';
        c.ZipCode__c= '3270';
        c.Primary_Email__c = 'Email1';
        c.Primary_Fax__c = 'FAX2';
        c.Primary_Phone__c ='Other2';
        c.PersonDoNotCall=false;
        c.PersonHasOptedOutOfEmail=false;
        c.Opt_In_Email__c=true;
        c.Foundation_Date__c=date.today()-1;
        c.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        c.ID_Type__c = '';
        c.ID_Number__c='';
        insert c;
        
       // inserting person account link
        Account_Link__c acclnkPerson = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = a.id,fromrole__c=dealer.id, ReCordTypeId = alkPerson_RecordTypeId);
        insert acclnkPerson;      

       // inserting company account link
        Account_Link__c acclnkCompany = new Account_Link__c(Name = 'Test Name', Market__c = 'AU', ToRole__c = c.id,fromrole__c=dealer.id, ReCordTypeId = alkCompany_RecordTypeId);
        insert acclnkCompany;
        
       // insering address
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Shanghai';
        address.City__c='bangalore';
        address.District__c='test';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.ZipCode__c = '3271';
        address.Customer__c = a.id;
        address.TitleOfHonor__c ='To Person';  
        address.preferred__c=True;
        address.Opt_In_Hardcopy__c=True;
        address.MD__c='AU';   
        address.State_City__c = 'VIC';
        address.Country__c='Australia';
        insert address;
         
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
   
          test.startTest();
          schduleUpdateRTwithWSAccountANZ sh1 = new schduleUpdateRTwithWSAccountANZ();
         // sch = '0 0 22 * * ?';
          system.schedule('schduleUpdateRTwithWSAccountANZ - Everyday 10PM', '0 0 22 * * ?', sh1);
          Test.stopTest(); 
        
    }
}
}