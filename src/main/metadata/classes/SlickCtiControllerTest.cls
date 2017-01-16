/*
    Type:       Test class
    Purpose:    Test the SlickCtiController class 
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Venky Created on 2015-18-06
*/
@isTest public class SlickCtiControllerTest{


 static testMethod void TestContactRetrieve() {
      createCustomSettings();
        Contact testContact = new Contact();
        testContact.account = setupTestAccount(); 
        testContact.firstName = 'Test Contact';
        testContact.lastName = 'Test last name';        
        test.startTest();        
        upsert testContact;        
        SlickCtiController.getRecordDetails(String.valueOf(testContact.Id));                
        test.stopTest();
        system.assertNotEquals(null,testContact.id);
    }
    
    static testMethod void TestLeadRetrieve() {
    createCustomSettings();
        Lead testLead = new Lead();
        testLead.firstName = 'Test Lead';
        testLead.lastName = 'Test Lead';
        testLead.status = 'New';
        
        test.startTest();                
        upsert testLead;
        SlickCtiController.getRecordDetails(String.valueOf(testLead.Id));                
        test.stopTest();
        system.assertNotEquals(null,testLead.id);
    } 

    static testMethod void TestAccountRetrieve() {
    createCustomSettings();
        Account testAccount = setupTestAccount();
        
        test.startTest();                        
        SlickCtiController.getRecordDetails(String.valueOf(testAccount.Id));
        test.stopTest();
         system.assertNotEquals(null,testAccount.id);
    }

    static testMethod void TestCaseRetrieve() {
        createCustomSettings();
        Contact testContact = new Contact();
        testContact.account = setupTestAccount(); 
        testContact.firstName = 'Test fname';
        testContact.lastName = 'Test lname';

        Case testCase = new Case();
        testCase.subject = 'test case';
        testCase.contact = testContact;
        testCase.account = testContact.account;

        
        test.startTest();        
        upsert testContact;
        upsert testCase;
        SlickCtiController.getRecordDetails(String.valueOf(testCase.Id));                
        test.stopTest();
         system.assertNotEquals(null,testCase.id);
    }

    
    static private Account setupTestAccount() {
        Account testAccount = new Account();
        
        testAccount.name = 'Test Account';
        upsert testAccount;
        
        return testAccount;
        
    }
    static private void createCustomSettings() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        
    }
}