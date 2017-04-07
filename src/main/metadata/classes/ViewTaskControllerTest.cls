/*
    Type:       Test Class
    Purpose:    Test Class for ViewTaskController
    User Story: Data Sharing V1.0
    Used By:History: 
    1. Chaos Created on 2014-06-11
*/
@isTest
public class ViewTaskControllerTest {

Private static string Closed='Closed';
    public static testMethod void testMyController() 
    {
        Test.startTest();
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;
        // Create Person Account
        Account personAccount = (Account)UtilTestData.createSobject(new Account(Mobile__c='09865231450'), 
            UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        // Prepare for the historical activity record
        // Create an activity for personAccount
        Task historicalActivity1 = new Task(WhatId = personAccount.Id);
        UtilTestData.createSobject(historicalActivity1, UtilTestData.TASK_RT_EDM);
        historicalActivity1.Status = Closed;
        update historicalActivity1;
        // Prepare for the second historical activity record
        // Create Case
        Case cas = (Case)UtilTestData.createSobject(new Case(AccountId = personAccount.Id), UtilTestData.CASE_RT_MB_COMPLAINT);
        // Connect the case to activity record
        Task historicalActivity2 = new Task(WhatId = cas.Id);
        UtilTestData.createSobject(historicalActivity2, UtilTestData.TASK_RT_EDM);
        historicalActivity2.Status =Closed;
        update historicalActivity2;
        // Test Start from here
        ViewTaskController con = new ViewTaskController(
            new ApexPages.StandardController(personAccount));
        // Validate if 2 historical activity records have been found.
        Test.stopTest();
        System.assertEquals(historicalActivity1.Status, 'Closed');
        System.assertEquals(historicalActivity2.Status, 'Closed');
        System.assertEquals(con.wraps.size(), 2);
    }
}