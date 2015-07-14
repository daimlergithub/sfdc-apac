@isTest
public with sharing class SSIBatchVinMatchTest 
{
	private static id recordTypeID = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    public static Profile userProfile = [select Id from Profile where Name = 'CAC SSI SV' limit 1];
    public static user usr;
    public static Task tsk;
   
    public static testMethod void testcontroller()
    {
        id SSitID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        id vechID = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        
        Vehicle__c vehc1 = new Vehicle__c();
        vehc1.Vehicle_Name__c ='Test1';
        vehc1.UsVIN__c ='abc';
        vehc1.RecordTypeId = vechID;
        insert vehc1;
        
        SSI__c ssi1 = new SSI__c();
        ssi1.CustomerName__c='Cust1';
        ssi1.VehicleUSvin__c = 'abc';
        ssi1.HomeMobilePhone__c ='74389594303';
        ssi1.Status__c = 'Matched';
        insert ssi1;
        
        Account acc1 = new Account();
        acc1.LastName ='testaccount';
        acc1.Mobile__c ='74389594303';
        acc1.Mobile2__c ='74389594303';
        acc1.FirstName ='batch';
        acc1.Email__c ='ssibatch@test.com';
        acc1.RecordTypeId = SSitID;
        acc1.Salutation ='Brother';
        insert acc1;	
        
        acc1 =[Select Id, PersonContactId From Account Where Id =: acc1.Id];
        usr = new User(
            Username = System.now().millisecond() +math.random()+ '987654321test12345@test.com',
            FirstName = 'firstname',
            ProfileId = userProfile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert usr;
     
        tsk = new Task(recordtypeid = recordTypeID,
            Subject = 'SSI Task',
            WhatId = acc1.Id,
            WhoId = acc1.PersonContactId,
            Status = 'Open'
        );
        insert tsk;
        
        string ssi = 'Select Id,CustomerName__c,VehicleUSvin__c,HomeMobilePhone__c from SSI__c';
        test.startTest();
        SSIBatchVinMatch ssiclass = new SSIBatchVinMatch(ssi);
        Database.executeBatch(ssiclass); 
        test.stopTest();
        system.assertEquals(vehc1.UsVIN__c, ssi1.VehicleUSvin__c);
        system.assertEquals(vehc1.UsVIN__c, ssi1.VehicleUSvin__c, tsk);
    }
}