@isTest
private with sharing class SSITriggerHandlerTest {
 private static Account customer;
    private static string SubjectValue = 'Welcome Call';
    private static string ActivityStatusValue ='Successful';
    private static string ActivityStatus ='Valid';
    private static string ActivityStatusInvalid ='Invalid';
    private static User ssi_sv;
    public static Profile CACSSISVID = [select Id from Profile where Name = 'CAC SSI SV' limit 1];
    
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
        
        ssi_sv = UtilTestData.createUser('SSI Supervisor','System Administrator');
        
        System.runAs ( ssi_sv ) {
                    
           
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;
            
            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched');
            insert ssi;
            
            Test.startTest();
   
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          insert updatecustomsettings;
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
        
          ssi_sv = UtilTestData.createUser('SSI Supervisor','System Administrator');
        
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
   List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          insert updatecustomsettings;
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
    static testMethod void myUnitTest3() {
        
          ssi_sv = UtilTestData.createUser('SSI Supervisor','System Administrator');
        
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
            
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = '2nd Survey Call');
            insert ssiTask;
            Test.startTest();
   List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
          insert updatecustomsettings;
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
            //ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
            ssi_sv = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = CACSSISVID.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        insert ssi_sv;
   system.runAs(ssi_sv)
   {
    customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
    String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;
    // create new ssi record
    SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched',DealerCheck_Status__c = ActivityStatus,CarModelCheck_Status__c = ActivityStatus,Need_2nd_Survey__c = false);
    insert ssi;            
    
    // cover TriggerTask.trigger                
      Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();            
         
     Test.startTest();
     List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
     insert updatecustomsettings;
     Map<Id,SSI__c> oldmap = new Map<Id,SSI__c>();
     oldmap.put(ssi.Id, ssi);
     Task ssiTask = new Task(recordtypeid = recordtype, Subject = '2nd Survey Call'); 
     insert ssiTask;
     ssi.Need_2nd_Survey__c = true;
     update ssi;
     ssiTask.WhatId = ssi.Id;
     update ssiTask;
     List<Task> generatetask = new List<Task>();
     Map<Id,SSI__c> updateMap = new Map<Id,SSI__c>();
     updateMap.put(ssi.Id, ssi);
     generatetask.add(ssiTask);
     Test.stopTest(); 
   }   
                    
    }
}