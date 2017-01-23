/*
    Type:    Test class
    Purpose: Test Class for ContactTableController
    ---------------------------------------------------------------   
    1. Created on 18-Jan-2017    
*/
@istest
public class ContactTableControllerTest {
  public static Account objAccount; 
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  
  static void createTestData() {
    objAccount = new Account();
    objAccount.RecordTypeId = personAccRecordTypeId;
    objAccount.Dealer_DMS_SR_Code__c='test code 2';
    objAccount.Individual_Home_Phone__c = '000-0000-9642';
    objAccount.Home_Phone_2__c = '000-0000-9642';
    objAccount.Work_Phone__c = '000-0000-9642';
    objAccount.Status__c='NoCustomer';
    objAccount.Email__c = 'testemail@test.com';
    objAccount.Email2__c = 'testemail2@test.com';
    objAccount.Email3__c = 'testemail3@test.com';
    objAccount.City__c='Beijing';
    objAccount.Gender__c = 'Male';
    objAccount.Phone = '000-0000-9642';
    objAccount.Area_code__c = '0101';
    objAccount.MD__c = 'KR';
    objAccount.LastName = 'galaxy1';
    objAccount.FirstName = 'First Name';
    objAccount.Salutation = 'Unknown';
    objAccount.Province__c = 'Shanghai';
    objAccount.ZipCode__c= '1002347';
    objAccount.MBK_Data_Source__c='Email';
    objAccount.Mobile__c = '000-0000-9642';
    objAccount.Mobile2__c = '000-0000-9642';
    objAccount.Primary_Email__c = 'Email1';
    objAccount.Primary_Fax__c = 'FAX2';
    objAccount.Primary_Phone__c ='Other2';
    insert objAccount;    
  }      
  
  public static testMethod void PhoneNumberFormatTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.PhoneNumberFormat();
    test.stoptest();
  }
  public static testMethod void UpdateAccountTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.UpdateAccount();
    test.stoptest();
  }
  public static testMethod void UpdateAccountTest1() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      objAccount.Individual_Home_Phone__c = '010-0000-9999';
      objAccount.Work_Phone__c = '010-0000-9999';
      objAccount.Mobile__c = '010-0000-9999';
      update objAccount;
      ctc.UpdateAccount();
    test.stoptest();
  }
  public static testMethod void EditAccountTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.EditAccount();
    test.stoptest();
  }
  public static testMethod void AreacodeItemsTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.getAreacodeItems();
    test.stoptest();
  }
   public static testMethod void MobileAreacodeItemsTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.getMobileAreacodeItems();
    test.stoptest();
  }
  public static testMethod void CancelUpdateTest() {
    createTestData();
    ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
    ContactTableController ctc = new ContactTableController(sc);
    test.startTest();
      ctc.CancelUpdate();
    test.stoptest();
  }
}