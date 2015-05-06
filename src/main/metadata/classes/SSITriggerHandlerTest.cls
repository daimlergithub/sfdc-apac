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
private class SSITriggerHandlerTest {

    static testMethod void myUnitTest1() {
        
        User ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
        
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_sv ) {
                    
            Account customer = new Account(
                FirstName = 'Test-',
                LastName =  DateTime.now().formatLong(),
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234567', 
                PersonAssistantPhone = '1234567'
            );
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
            
            ssiTask = [Select Id, OwnerId From Task Where Id=:ssiTask.Id];
            //System.assertEquals(ssiTask.OwnerId, ssi_sv.Id);
            
            // change ssi record owner
            // ssi.OwnerId = ssi_csr.Id;
            // update ssi;
            
            ssiTask = [Select Id, OwnerId From Task Where Id=:ssiTask.Id];
            //System.assertEquals(ssiTask.OwnerId, ssi_csr.Id);

            // update need 2nd survey
            ssi.Need_2nd_Survey__c = true;
            update ssi;
            update ssi;
            
            ssiTask = [Select Id, Status From Task Where WhatId=:ssi.Id And recordtypeid =:recordtype And Subject='2nd Survey Call'];
            System.assertEquals(ssiTask.Status, 'Open');

            Test.stopTest();
        }    
        
    }

    static testMethod void myUnitTest2() {
        
        User ssi_sv = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
        
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_sv ) {
                    
            Account customer = new Account(
                FirstName = 'Test-',
                LastName =  DateTime.now().formatLong(),
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234567', 
                PersonAssistantPhone = '1234567'
            );
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            String customerName = [Select Name From Account Where Id = :customer.Id][0].Name;

            // create new ssi record
            SSI__c ssi = new SSI__c(CustomerName__c = customerName, DealerName__c = 'Test Dealer', Status__c = 'Matched');
            insert ssi;
            
            // cover TriggerTask.trigger    
            Id ibrtid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
            Id obrtid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
            Id recordtype = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
            
            Task ssiTask = new Task(recordtypeid = recordtype, WhatId = ssi.Id, Subject = 'Welcome Call');
            insert ssiTask;

            Test.startTest();

            ssiTask.recordtypeid = ibrtid;
            ssiTask.CallType = 'Inbound';
            ssiTask.Activity_Status__c = 'Successful';
            ssiTask.IB_Status__c = 'Valid';
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, IB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, 'Valid');
            
            ssitask.recordtypeid = recordtype;
            ssiTask.CallType = '';
            ssiTask.Activity_Status__c = 'Successful';
            ssiTask.OB_Status__c = 'Invalid';
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, 'Successful');
            
            ssiTask.recordtypeid = obrtid;
            ssiTask.CallType = 'Outbound';
            ssiTask.Activity_Status__c = 'Successful';
            ssiTask.OB_Status__c = 'Invalid';
            update ssiTask;
            ssiTask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:ssiTask.Id];
            System.assertEquals(ssiTask.Activity_Status__c, 'Invalid');
            
            ssi.DealerCheck_Status__c = 'Accept';
            ssi.CarModelCheck_Status__c = 'Accept';
            ssi.Comments__c = 'OK';
            update ssi;
            
            ssi.DealerCheck_Status__c = 'Valid';
            ssi.CarModelCheck_Status__c = 'Valid';
            try{
                update ssi;
            }catch(Exception ex){
                system.debug('ex>>>>'+ex.getMessage());
            }

            Test.stopTest();
        }    
        
    }
}