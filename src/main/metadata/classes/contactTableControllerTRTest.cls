/*
Type:    Test class
Purpose: Test Class for ContactTableController for Turkey covering TR specific methods only in contactTableController class.
---------------------------------------------------------------   

*/
@istest
public class contactTableControllerTRTest {
    public static Account objAccount; 
    public static User usr;
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Profile profile;
    private static UserRole role;
    public static string teststring='test';
	 
    static void createTestData() {        
	Profile profile = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
     usr = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=profile.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
     DMLManagerService.insertAsSystem(usr);
	 system.runas(usr){
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '+905698745698';
        //objAccount.Home_Phone_2__c = '+911234567890';
        objAccount.Work_Phone__c = '+905698745698';
        objAccount.Mobile__c='+905698745698';
        objAccount.Status__c='Prospect';
        objAccount.Email__c = 'testemail@test.com';
        //objAccount.Email2__c = 'testemail2@test.com';
        //objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Ankara';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '+905234567890';
        //objAccount.Fax = '+911234567890';
        //objAccount.Area_code__c = '010';
        //objAccount.MD__c = 'TR';
		objAccount.Market__c = 'TR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Akyurt';
        objAccount.ZipCode__c= '10023';
        objAccount.Data_Source__c='MBT Event';
        
        //objAccount.Mobile2__c = '+911234567891';
        //objAccount.Primary_Email__c = 'Email1';
        //objAccount.Primary_Fax__c = 'FAX2';
        //objAccount.Primary_Phone__c ='Other2';
        insert objAccount;
	 }		
    }    
    
    static void createTestData1() {        
		Profile profile = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
		usr = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=profile.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
		
		DMLManagerService.insertAsSystem(usr);
		system.runas(usr){
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '';
        //objAccount.Home_Phone_2__c = '';
        objAccount.Work_Phone__c = '+905234567890';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        //objAccount.Email2__c = 'testemail2@test.com';
        //objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Ankara';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '';
        //objAccount.Fax = '';
        //objAccount.Area_code__c = '010';
        objAccount.MD__c = 'TR';
		objAccount.Market__c = 'TR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        //objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Akyurt';
        objAccount.ZipCode__c= '10023';
        objAccount.Data_Source__c='MBT Event';
        objAccount.Mobile__c = '+905234567890';
        //objAccount.Mobile2__c = '';
        //objAccount.Primary_Email__c = 'Email1';
        //objAccount.Primary_Fax__c = 'FAX2';
        //objAccount.Primary_Phone__c ='Other2';
        insert objAccount;
		}		
    } 
    
    static void createTestData2() {        
		Profile profile = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
		usr = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=profile.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
		
		DMLManagerService.insertAsSystem(usr);
		system.runas(usr){
		objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code 2';
        objAccount.Individual_Home_Phone__c = '';
        //objAccount.Home_Phone_2__c = '';
        objAccount.Work_Phone__c = '';
        objAccount.Status__c='Prospect';
        objAccount.Email__c = 'testemail@test.com';
        //objAccount.Email2__c = 'testemail2@test.com';
        //objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Ankara';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '';
        //objAccount.Fax = '';
        objAccount.Area_code__c = '010';
        objAccount.Market__c = 'TR';
		objAccount.MD__c = 'TR';
        objAccount.LastName = 'galaxy1';
        objAccount.FirstName = 'First Name';
        //objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Akyurt';
        objAccount.ZipCode__c= '10023';
        objAccount.Data_Source__c='Email';
        objAccount.Mobile__c = '';
        //objAccount.Mobile2__c = '';
        //objAccount.Primary_Email__c = 'Email1';
        //objAccount.Primary_Fax__c = 'FAX2';
        //objAccount.Primary_Phone__c ='Other2';
        insert objAccount;
		}		
    } 
    
    public static testMethod void PhoneNumberFormatTest() {
        createTestData();
		system.runas(usr){
		ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatTR();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'+905698745698');
        }
    }
    
    public static testMethod void PhoneNumberFormatTest1() {
        createTestData1();
		System.runas(usr){
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatTR();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'');
		}
        
    }
    
    public static testMethod void UpdateAccountTest() {
        createTestData();
		system.runas(usr){
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatTR();
        ctc.UpdateAccountTR();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'+905698745698');
		}
    }
    
    public static testMethod void UpdateAccountTest1() {
        createTestData1();
		system.runas(usr){
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.EditAccount();
        ctc.UpdateAccountTR();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'');
		}
    }
    public static testMethod void UpdateAccountTest2() {
        createTestData2();
		system.runas(usr){
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.EditAccount();
        ctc.UpdateAccountTR();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'');
		}
    }

}