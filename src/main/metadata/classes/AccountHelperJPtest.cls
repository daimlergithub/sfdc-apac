/*
    Type:      class
    Purpose:   Test class for AccountHelperJP
    Create By: Sudhir Kumar Acharya
*/

@isTest
public with sharing class AccountHelperJPtest 
{
    private static Account personAcc;
    private static User user1;
    private static Address__c address;
    private static List<Account> accountlist = new List<Account>();
    Private static map<id,Account> accountMap =  new map<id,Account>();
    private static Profile profile = [select Id from Profile where Name = 'System Administrator'];
    private static string en_US='en_US';
    Private static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    //Create Test data
	public static void createTestData()
   {       
	   //Create Custom Settings	
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
       insert updatecustomsettings;
       
       personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                    Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '0801801010',
                                    Area_code__c = '0101',
                               		MD__c = 'JP',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c= System.Label.Zipcode,
                               		Mobile__c = '023482832',
                               		Mobile2__c = '035456232',
									Primary_Email__c = 'Email3',
                               		Primary_Fax__c = 'FAX2',
                               		Primary_Phone__c ='Other2',
                                    RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc;
       accountlist.add(personAcc);
       
    address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=personAcc.id;
        insert address;     
   }
    public static void createuserrecord()
     {
     user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichaof',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US,Market__c = 'JP');
        insert user1;               
     }
    public static testmethod void testupdateAccountFieldsupdate()
    {
		createuserrecord();
        createTestData();
        accountMap.putAll(accountlist);
        system.runAs(user1)
        {
        test.startTest();
        personAcc.Mobile__c = '054323424';
        personAcc.Mobile2__c = '054234423';
        personAcc.Individual_Home_Phone__c = '06585855';
        personAcc.Home_Phone_2__c = '06742354';
        personAcc.Work_Phone__c = '04564785';
        personAcc.Phone = '02346643';
        personAcc.Email__c = 'test123@test.com';
        personAcc.Email2__c = 'testemail222@test.com';
        personAcc.Email3__c = 'testemail333@test.com';
        personAcc.Primary_Fax__c = 'FAX1';
        personAcc.Primary_Email__c = 'Email2';
        personAcc.Primary_Phone__c = 'Work Mobile';
        update personAcc;
        test.stopTest();
            
        personAcc = [select Primary_Phone_Display__c,Mobile2__c from Account ];
        system.assertEquals(personAcc.Primary_Phone_Display__c, personAcc.Mobile2__c);
    	}
    }    
    public static testmethod void testupdatePrimaryAddressdisplay()
    {
        createuserrecord();
        createTestData();
        system.runAs(user1)
        {
        test.startTest();
        personAcc.Primary_Address_Reference__c=address.id;
        update personAcc;
        test.stopTest();
        
        personAcc = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        system.assertEquals(personAcc.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
    	}
    }   
    public static testmethod void testupdatePrimaryContactInformation()
    {
        createuserrecord();
        createTestData();
        accountMap.putAll(accountlist);
        system.runAs(user1)
        {
        test.startTest();
        personAcc.Primary_Fax__c = 'FAX2';
        personAcc.Primary_Email__c = 'Email1';
        personAcc.Primary_Phone__c = 'Home Phone';
        update personAcc;
        test.stopTest();
        personAcc = [select Primary_Email_Display__c,Email__c from Account ];
        system.assertEquals(personAcc.Primary_Email_Display__c, personAcc.Email__c);
        }
    }    
}