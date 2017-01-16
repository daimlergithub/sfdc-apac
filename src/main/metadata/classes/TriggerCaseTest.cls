/*
  Name                 : TriggerCaseTest
  Object               : Case
  Requirement          : US-Cpn-010
  Author               : Mouse Liu
  Create Date          : 2013/7/9 
 */
@isTest
private with sharing class TriggerCaseTest {
    public static testMethod void testRollupComplaintCaseAmount_CreateCase() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
     insert updatecustomsettings;
    Test.startTest();
        // Create Test Account
        Account acc = new Account();
        UtilTestData.createSobject(acc, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // Create MB Complaint Case
        Case mbComplaintCase = new Case(AccountId = acc.Id);
        UtilTestData.createSobject(mbComplaintCase, UtilTestData.CASE_RT_MB_COMPLAINT);
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        system.debug('>>>>>>>>'+acc.Complaint_Amount__c);
        System.assert(acc.Complaint_Amount__c == 0);

        // Create Chrysler Complaint Case
        Case chryslerComplaintCase = new Case(AccountId = acc.Id);
        UtilTestData.createSobject(chryslerComplaintCase, UtilTestData.CASE_RT_CHRYSLER_COMPLAINT);
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        Test.stopTest();
        System.assert(acc.Complaint_Amount__c == 0);
    }

    public static testMethod void testRollupComplaintCaseAmount_DeleteCase() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
     insert updatecustomsettings;
    Test.startTest();
        // Create Test Account
        Account acc = new Account();
        UtilTestData.createSobject(acc, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // Create MB Complaint Case
        Case mbComplaintCase = new Case(AccountId = acc.Id);
        UtilTestData.createSobject(mbComplaintCase, UtilTestData.CASE_RT_MB_COMPLAINT);
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assert(acc.Complaint_Amount__c == 0);

        // Delete MB Complaint Case
        delete mbComplaintCase;
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        Test.stopTest();
        System.assert(acc.Complaint_Amount__c == 0);
    }

    public static testMethod void testRollupComplaintCaseAmount_UndeleteCase() {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
     insert updatecustomsettings;
    Test.startTest();
        // Create Test Account
        Account acc = new Account();
        UtilTestData.createSobject(acc, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        // Create MB Complaint Case
        Case mbComplaintCase = new Case(AccountId = acc.Id);
        UtilTestData.createSobject(mbComplaintCase, UtilTestData.CASE_RT_MB_COMPLAINT);
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assert(acc.Complaint_Amount__c == 0);

        // Delete MB Complaint Case
        delete mbComplaintCase;
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assert(acc.Complaint_Amount__c == 0);

        // Undelete MB Complaint Case
        undelete mbComplaintCase;
        acc = [SELECT Complaint_Amount__c FROM Account WHERE Id = :acc.Id];
        Test.stopTest();
        System.assert(acc.Complaint_Amount__c == 0);
    }
}