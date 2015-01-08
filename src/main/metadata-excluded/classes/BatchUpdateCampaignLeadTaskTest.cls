/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class BatchUpdateCampaignLeadTaskTest {

    public static testMethod void testMyController() {

        Id cca_RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign

        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=cca_RecordTypeId);
        
        insert TestData_CCA;

        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
            
        Account customer = new Account(
            FirstName = 'Test-',
            LastName =  DateTime.now().formatLong(),
            PersonMobilePhone = '13011111111',
            PersonOtherPhone = '13022222222', 
            Phone = '1234567', 
            PersonHomePhone = '1234567', 
            PersonAssistantPhone = '1234567'
        );
        customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        Lead__c ld = new Lead__c(
            Assigned_Dealer__c = dealer.Id,
            Contact__c = customer.Id
        );
        insert ld;
        
        Campaign_Lead__c cl = new Campaign_Lead__c(Campaign__c = TestData_CCA.Id, Lead__c = ld.Id);
        insert cl;
        
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        for(integer i = 0; i < 201; i++) {
            tasks.add(new Task(RecordTypeId = SMSRTID, WhatId = cl.Id, Activity_Status__c='Need Verification'));
        }
        Insert tasks;

        Test.startTest();
        
        String queryStr = 
            'Select Id From Campaign_Lead__c Where Id = \'' + cl.Id + '\'';
            
        BatchUpdateCampaignLeadTask batcher = new BatchUpdateCampaignLeadTask(queryStr);
        Database.executeBatch(batcher, 300);
        
        Test.stopTest();

    }
}