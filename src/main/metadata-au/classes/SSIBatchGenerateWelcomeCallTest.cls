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
public class SSIBatchGenerateWelcomeCallTest {

    public static testMethod void testMyController() {
        
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        
        Account dms1 = new Account(
            LastName = 'Test-Customer1',
            Phone = '1234567', 
            Area_Code__c = '010',
            ZipCode__c = '123456',
            firstname='test acme',
            Salutation='Brother',
            Recordtypeid = paid,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
        );
        insert dms1;

        Account dms2 = new Account(
            LastName = 'Test-Customer2',
            Phone = '1234567', 
            Area_Code__c = '010',
            ZipCode__c = '123456',
            firstname='test acme',
            Salutation='Brother',
            Recordtypeid = paid,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
        );
        
        insert dms2;
        dms2= [Select Id, PersonContactId From Account Where Id =: dms2.Id];

        Task t1 = new Task(
            recordtypeid =  Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId(),
            Subject = 'Welcome Call',
            WhatId = dms2.Id,
            WhoId = dms2.PersonContactId,
            Status = 'Open'
        );
        insert t1;        
        
        dms2= [Select Id, PersonContactId, 
            (select subject from PersonActivityHistories), 
            (select subject from PersonOpenActivities), 
            (select subject from ActivityHistories), 
            (select subject from OpenActivities) 
            From Account Where Id =: dms2.Id];
        System.debug('--------------dms2.PersonActivityHistories--------------->'+dms2.PersonActivityHistories.size());
        System.debug('--------------dms2.PersonOpenActivities--------------->'+dms2.PersonOpenActivities.size());
        System.debug('--------------dms2.ActivityHistories--------------->'+dms2.ActivityHistories.size());
        System.debug('--------------dms2.OpenActivities--------------->'+dms2.OpenActivities.size());
        
        Account dms3 = new Account(
            LastName = 'Test-Customer3',
            Phone = '1234567', 
            Area_Code__c = '010',
            ZipCode__c = '123456',
            firstname='test acme',
            Salutation='Brother',
            Recordtypeid = paid,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413' 
        );
        insert dms3;
        dms3 = [Select Id, PersonContactId From Account Where Id =: dms3.Id];
        
        Task t2 = new Task(
            recordtypeid =  Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId(),
            Subject = 'Welcome Call',
            WhatId = dms3.Id,
            WhoId = dms3.PersonContactId,
            Status = 'Closed'
        );
        
        insert t2;
        
        Test.startTest();
        SSIScheduleWelcomeCallEscalation schClass = 
            new SSIScheduleWelcomeCallEscalation();
        Date nextMonth = System.today().addMonths(1);    
        String cron = '0 0 13 ' + nextMonth.day() + ' '
                                + nextMonth.month() + ' ? ' 
                                + nextMonth.year();
        String jobName = 'Create Generate Welcome Call Weekly Schedule ' + 
            Math.rint(Math.random() * 1000000);
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
       
    }
}