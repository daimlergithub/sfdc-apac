/*
    Type:       Test Class
    Purpose:    Test Class for ViewTaskController
    User Story: Data Sharing V1.0
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-06-11
*/
@isTest
public class ViewTaskControllerTest {

    
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Account personAccount;
    public static Task historicalActivity1;
    public static Task historicalActivity2;
    public static Case cas;
    public static testMethod void testMyController() 
    {
    	
       
        createTestData();
        
        
       
        // Test Start from here
         Test.startTest();
            ViewTaskController con = new ViewTaskController(
        	new ApexPages.StandardController(personAccount));
        // Validate if 2 historical activity records have been found.
        Test.stopTest();
        System.assertEquals(historicalActivity1.Status, 'Closed');
        System.assertEquals(historicalActivity2.Status, 'Closed');
        System.assertEquals(con.wraps.size(), 2);
	}
    
    static void createTestData()
    {
         // Create Person Account
        personAccount = new Account();

        personAccount.RecordTypeId = personAccRecordTypeId; 
        personAccount.FirstName = 'Customer';
        personAccount.Gender__c = '0=Male';
        personAccount.ZipCode__c = '200235';
        personAccount.LastName = 'lastname';
        personAccount.Salutation = 'Unknown';
        personAccount.Individual_Home_Phone__c = '98958';
        personAccount.Email__c = 'abc@wrw.com';
        
        insert personAccount;
        
        // Prepare for the historical activity record
        // Create an activity for personAccount
        historicalActivity1 = new Task(WhatId = personAccount.Id);
        UtilTestData.createSobject(historicalActivity1, UtilTestData.TASK_RT_EDM);
        historicalActivity1.Status = 'Closed';
        update historicalActivity1;
        // Create Case
        cas = (Case)UtilTestData.createSobject(new Case(AccountId = personAccount.Id), UtilTestData.CASE_RT_MB_COMPLAINT);
        // Prepare for the second historical activity record
        //  Connect the case to activity record
        historicalActivity2 = new Task(WhatId = cas.Id);
        UtilTestData.createSobject(historicalActivity2, UtilTestData.TASK_RT_EDM);
        
        historicalActivity2.Status = 'Closed';
        update historicalActivity2;
    }
}