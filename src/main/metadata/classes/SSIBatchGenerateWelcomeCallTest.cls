@isTest
public with sharing class SSIBatchGenerateWelcomeCallTest {
    private static id recordTypeID = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();

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
            recordtypeid =  recordTypeID,
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
            recordtypeid =  recordTypeID,
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
        string  jobId= System.schedule(jobName, cron, schClass);
        Test.stopTest();
        CronTrigger listCronTrigger = [select Id, CronExpression, EndTime, NextFireTime, OwnerId, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey 
           from CronTrigger where Id =:jobId ];
        
        system.assertEquals(listCronTrigger.state, 'WAITING');

       
    }
}