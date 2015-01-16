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
private class TaskMassChangeOwnerTest {

    static testMethod void myUnitTest1() {
    	
        User ob_sv = UtilTestData.createUser('OB Supervisor','CAC OB SV');
        
        User ob_csr = UtilTestData.createUser('OB CSR','CAC OB CSR');
        
        System.runAs ( ob_sv ) {
        	SSI__c ssi = new SSI__c(Status__c = 'Matched');
        	insert ssi;
        	
        	Id wcrtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
        	Task task1 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
        	insert task1;
        	Task task2 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
        	insert task2;
        	
	        Test.startTest();
			
	        PageReference pr = new PageReference('/apex/TaskMassChangeOwner?objIds=' + task1.Id + ',' + task2.Id);
	        Test.setCurrentPage(pr);
	        
	        TaskMassChangeOwner controller = new TaskMassChangeOwner();
	        controller.assignToOwnerClick();
	        
	        controller.task.OwnerId = ob_csr.Id;
	        controller.assignToOwnerClick();
			
			task1 = [Select OwnerId From Task Where Id = :task1.id];
			System.assertEquals(task1.OwnerId, ob_csr.Id);
			
			task2 = [Select OwnerId From Task Where Id = :task2.id];
			System.assertEquals(task2.OwnerId, ob_csr.Id);
	
			ssi = [Select OwnerId From SSI__c Where Id = :ssi.Id];
			System.assertEquals(ssi.OwnerId, ob_csr.Id);
	
			// Test Stop
			Test.stopTest();
        }
    }
    static testMethod void myUnitTest2() {
    	
        User ob_sv = UtilTestData.createUser('OB Supervisor','CAC OB SV');
        
        User ob_csr = UtilTestData.createUser('OB CSR','CAC OB CSR');
        
        System.runAs ( ob_sv ) {
        	smart_SSI__c ssi = new smart_SSI__c(Status__c = 'Matched');
        	insert ssi;
        	
        	Id wcrtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
        	Task task1 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
        	insert task1;
        	Task task2 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
        	insert task2;
        	
        	//task1 = [Select WhatId From Task Where Id = :task1.id];
        	//System.debug('-----------task1.WhatId----------->'+task1.WhatId);
        	
			// Test Start
	        Test.startTest();
			
	        PageReference pr = new PageReference('/apex/TaskMassChangeOwner?objIds=' + task1.Id + ',' + task2.Id);
	        Test.setCurrentPage(pr);
	        
	        TaskMassChangeOwner controller = new TaskMassChangeOwner();
	        controller.assignToOwnerClick();
	        
	        controller.task.OwnerId = ob_csr.Id;
	        controller.assignToOwnerClick();
			
			task1 = [Select OwnerId From Task Where Id = :task1.id];
			System.assertEquals(task1.OwnerId, ob_csr.Id);
			
			task2 = [Select OwnerId From Task Where Id = :task2.id];
			System.assertEquals(task2.OwnerId, ob_csr.Id);
	
			ssi = [Select OwnerId From smart_SSI__c Where Id = :ssi.Id];
			System.assertEquals(ssi.OwnerId, ob_csr.Id);
	
			// Test Stop
			Test.stopTest();
        }
    }
}