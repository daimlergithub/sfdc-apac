@isTest
private with sharing class SSITriggerHandlerTest {

 private static Account customer;
    private static string SubjectValue = 'Welcome Call';
    private static string ActivityStatusValue ='Successful';
    private static string ActivityStatus ='Valid';
    private static string ActivityStatusInvalid ='Invalid';
    private static User ssi_sv;
    
    
     static{
          customer = new Account(
                FirstName = 'Test-',
                LastName =  DateTime.now().formatLong(),
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234567', 
                PersonAssistantPhone = '1234567'
            );
        
    }

    
    static testMethod void myUnitTest1() {
        
        ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
        
        System.runAs ( ssi_sv ) {
                    
           
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;
            
            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched');
            insert ssi;
            
            Test.startTest();

            // create ssi task related to ssi record
            Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = 'Welcome Call');
            insert ssiTask;
            
            ssiTask = [Select Id,Subject, OwnerId From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.OwnerId, ssi_sv.Id);
            
           
            ssiTask = [Select Id, OwnerId From Task Where Id=:ssiTask.Id];
            ssi.Need_2nd_Survey__c = true;         
            
            ssiTask = [Select Id, Status,Subject From Task Where WhatId=:ssi.Id And recordtypeid =:recordtype];
            Test.stopTest();
            System.assertEquals(ssiTask.Subject, 'Welcome Call');

            
       }    
        
    }
    
    
    static testMethod void myUnitTest2() {
        
          ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
        
        System.runAs ( ssi_sv ) {
                    
            
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;

            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched');
            insert ssi;
            
            // cover TriggerTask.trigger    
            Id ibrtid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
            Id obrtid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
            Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
            
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = SubjectValue);
            insert ssiTask;

            Test.startTest();

            ssiTask.recordtypeid = ibrtid;
            ssiTask.CallType = 'Inbound';
            ssiTask.Activity_Status__c = ActivityStatus;
            ssiTask.IB_Status__c = ActivityStatus;
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, IB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, ActivityStatus);
            
            ssitask.recordtypeid = recordtype;
            ssiTask.CallType = '';
            ssiTask.Activity_Status__c = ActivityStatusValue;
            ssiTask.OB_Status__c = 'Invalid';
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, ActivityStatusValue);
            
            ssiTask.recordtypeid = obrtid;
            ssiTask.CallType = 'Outbound';
            ssiTask.Activity_Status__c = ActivityStatusInvalid;
            ssiTask.OB_Status__c = 'Invalid';
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, ActivityStatusInvalid);
            
            ssi.DealerCheck_Status__c = 'Accept';
            ssi.CarModelCheck_Status__c = 'Accept';
            ssi.Comments__c = 'OK';
            update ssi;      
            Test.stopTest();
       }    
        
    }
        static testMethod void fieldsValidationRule() {
        
         ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
        
        System.runAs ( ssi_sv ) {                   
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;

            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched',DealerCheck_Status__c = ActivityStatus,CarModelCheck_Status__c = ActivityStatus);
            insert ssi;            
            
            // cover TriggerTask.trigger                
           Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();            
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = SubjectValue);            
             Test.startTest();
             insert ssiTask;      
             Test.stopTest();            
             ssiTask = [Select Id, Subject, OB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Subject, SubjectValue);
        }    
        
    }
}