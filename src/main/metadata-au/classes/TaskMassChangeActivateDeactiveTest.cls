/*
    Type:       Test Class
    Purpose:    Test the TaskMassChangeActivateDeactive class
   1. Barney lai created on 2014-3-4
*/
//TODO Active_Inactive_Flag__c commented as part of SFDCAU-57 for now.
@isTest
public class TaskMassChangeActivateDeactiveTest {

    static testMethod void testTaskMassChangeActivateDeactive1(){

        Id welcomeCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        User usr1 = UtilTestData.createUser('Remarketing Team Lead','Customer Retention');
        usr1.Active__c=true;
        update usr1;      
        system.runAs(usr1){
        Account personAccount1 = new Account(
            LastName = 'Test-Customer1',
            Phone = '1234567', 
            FirstName = 'aa',
            Salutation = 'Attorney',
            Recordtypeid = paid,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
        );
        insert personAccount1;
        
        Task task1 = new Task(
            RecordTypeId = welcomeCallRT,
            WhatId = personAccount1.Id,
            WhoId = personAccount1.PersonContactId,
            Status = 'Not Started'
        );
        insert task1;
       
       
        User usr = [select id from User where isActive = true limit 1];
        task1.ownerId = usr.id;
        update task1;
        
        Test.startTest();
        PageReference taskMassChangeActivateDeactive = Page.TaskMassChangeActivateDeactive;
       taskMassChangeActivateDeactive.getParameters().put('objIds', task1.id);
       Test.setCurrentPage(taskMassChangeActivateDeactive);
        TaskMassChangeActivateDeactive controller = new TaskMassChangeActivateDeactive();
        controller.task = task1;
        controller.Activate();
        controller.Deactivate();
         usr = [select id, Active__c from User where id = :usr.id];
        System.assertEquals(usr.Active__c, false);        
        Test.stopTest();
        }
    }
    
    static testMethod void testTaskMassChangeActivateDeactive2(){
           Id AnnualCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Annual Call').getRecordTypeId();
         Id EOCCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('EOC Call').getRecordTypeId();
        Id welcomeCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        User usr1 = UtilTestData.createUser('Remarketing Team Lead','Customer Retention');
        usr1.Active__c=true;
        update usr1;      
        system.runAs(usr1){
        Account personAccount1 = new Account(
            LastName = 'Test-Customer1',
            Phone = '1234567', 
            FirstName = 'aa',
            Salutation = 'Attorney',
            Recordtypeid = paid,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
        );
        insert personAccount1;
        
        Task task1 = new Task(
            RecordTypeId = AnnualCallRT,
            WhatId = personAccount1.Id,
            WhoId = personAccount1.PersonContactId,
            Status = 'Not Started'
        );
        insert task1;
        
        User usr = [select id, Active__c from User where isActive = true limit 1];
        system.debug('>>>> usr >>>'+usr);
        task1.ownerId = usr.id;
        update task1;
        
        Test.startTest();
        PageReference taskMassChangeActivateDeactive = Page.TaskMassChangeActivateDeactive;
        taskMassChangeActivateDeactive.getParameters().put('objIds', task1.id);
        Test.setCurrentPage(taskMassChangeActivateDeactive);
        TaskMassChangeActivateDeactive controller = new TaskMassChangeActivateDeactive();
        controller.Activate();
        controller.task = task1;
        controller.Deactivate(); 
        Test.stopTest();
        usr = [select id, Active__c from User where id = :usr.id];
        System.assertEquals(usr.Active__c, false); 
        }
    }
}