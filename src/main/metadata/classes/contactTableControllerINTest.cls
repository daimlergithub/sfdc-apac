/*
Type:    Test class
Purpose: Test Class for ContactTableController for India covering IN specific methods only in contactTableControllerIN class.
---------------------------------------------------------------   
1. Created on 16-Mar-2017  
2: Created by Prem Kumar
*/
@istest
public class contactTableControllerINTest {
    public static Account objAccount; 
    public static User usr;
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Profile profile;
    private static UserRole role;
    public static string teststring='test';
    
    static void createTestData() {        
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code one';
        objAccount.Individual_Home_Phone__c = '+911234567890';
        objAccount.Home_Phone_2__c = '+911234567890';
        objAccount.Work_Phone__c = '+911234567890';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '+911234567890';
        objAccount.Fax = '+911234567890';
        objAccount.Area_code__c = '010';
        objAccount.MD__c = 'IN';
        objAccount.LastName = 'galaxy one';
        objAccount.FirstName = 'First Name';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '100234';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '+911234567890';
        objAccount.Mobile2__c = '+911234567891';
        objAccount.Primary_Email__c = 'EmailOther';
        objAccount.Primary_Fax__c = 'FAX';
        objAccount.Primary_Phone__c ='Other';
        insert objAccount; 
    }    
    
    static void createTestData1() {        
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code two';
        objAccount.Individual_Home_Phone__c = '';
        objAccount.Home_Phone_2__c = '';
        objAccount.Work_Phone__c = '';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '';
        objAccount.Fax = '';
        objAccount.Area_code__c = '010';
        objAccount.MD__c = 'IN';
        objAccount.LastName = 'galaxy two';
        objAccount.FirstName = 'First Name one';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '100234';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '+911234567890';
        objAccount.Mobile2__c = '';
        objAccount.Primary_Email__c = 'EmailOth';
        objAccount.Primary_Fax__c = 'FAXTwo';
        objAccount.Primary_Phone__c ='OtherTwo';
        insert objAccount; 
    } 
    
    static void createTestData2() {        
        objAccount = new Account();
        objAccount.RecordTypeId = personAccRecordTypeId;
        objAccount.Dealer_DMS_SR_Code__c='test code three';
        objAccount.Individual_Home_Phone__c = '';
        objAccount.Home_Phone_2__c = '';
        objAccount.Work_Phone__c = '';
        objAccount.Status__c='NoCustomer';
        objAccount.Email__c = 'testemail@test.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Email3__c = 'testemail3@test.com';
        objAccount.City__c='Beijing';
        objAccount.Gender__c = 'Male';
        objAccount.Phone = '';
        objAccount.Fax = '';
        objAccount.Area_code__c = '010';
        objAccount.MD__c = 'IN';
        objAccount.LastName = 'galaxythree';
        objAccount.FirstName = 'First Name three';
        objAccount.Salutation = 'Unknown';
        objAccount.Province__c = 'Shanghai';
        objAccount.ZipCode__c= '100234';
        objAccount.MBK_Data_Source__c='Email';
        objAccount.Mobile__c = '1234567890';
        objAccount.Mobile2__c = '';
        objAccount.Primary_Email__c = 'Emailthree';
        objAccount.Primary_Fax__c = 'FAXthree';
        objAccount.Primary_Phone__c ='Otherthree';
        insert objAccount; 
    } 
    
    public static testMethod void PhoneNumberFormatTest() {
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatIN();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'+911234567890');
        
    }
    
    public static testMethod void PhoneNumberFormatTest1() {
        createTestData1();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatIN();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'');
        
    }
    
    public static testMethod void UpdateAccountTest() {
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.PhoneNumberFormatIN();
        ctc.UpdateAccountIN();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'+911234567890');
    }
    
    public static testMethod void UpdateAccountTest1() {
        createTestData1();
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        ContactTableController ctc = new ContactTableController(sc);
        test.startTest();
        ctc.UpdateAccountIN();
        test.stoptest();
        system.assertEquals(objAccount.Individual_Home_Phone__c,'');
    }

}