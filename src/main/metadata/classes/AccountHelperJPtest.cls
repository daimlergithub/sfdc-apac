@isTest
public with sharing class AccountHelperJPtest 
{
    private static Account personAcc;
    private static Address__c address;
    private static List<Account> accountlist = new List<Account>();
    Private static map<id,Account> accountMap =  new map<id,Account>();
    Private static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
	public static void createTestData()
   {       
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
       insert updatecustomsettings;
       
       personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                    Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '0801801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='七七七七七七七',
                               		Mobile__c = '023482832',
                               		Mobile2__c = '035456232',
									Primary_Email__c = 'Email1',                               
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
     public static testmethod void testupdateAccountFieldsinsert()
     {
         createTestData();
         
         test.startTest();
		 personAcc.Primary_Email__c = 'Email1';         
         AccountHelperJP.updateAccountFields(accountlist, accountMap, true,false);
         AccountHelperJP.updatePrimaryContactInformation(accountlist, accountMap, true,false);
         test.stopTest();
         system.assertEquals(accountlist[0].SMS_Last_Modified_By__c,Userinfo.getName());
         
     }
    public static testmethod void testupdateAccountFieldsupdate()
    {
        createTestData();
        accountMap.putAll(accountlist);
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
        update personAcc;
        //AccountHelperJP.updateAccountFields(accountlist, accountMap, false,true);
        test.stopTest();
    }
    public static testmethod void testupdatePrimaryAddressdisplay()
    {
        createTestData();
        test.startTest();
        personAcc.Primary_Address_Reference__c=address.id;
        update personAcc;
        test.stopTest();
    }
    
}