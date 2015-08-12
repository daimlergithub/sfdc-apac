@isTest
private class TaskMassChangeOwnerTest {

    static testMethod void myUnitTest1() {        
        User ob_sv = UtilTestData.createUser('OB TL','CAC OB TL');        
        User ob_csr = UtilTestData.createUser('OB CSR','CAC OB CSR');
        
       System.runAs ( ob_sv ) {
            Test.startTest();
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            
            Id wcrtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
            Task task1 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task1;
            Task task2 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task2;
            
            PageReference pr = new PageReference('/apex/TaskMassChangeOwner?objIds=' + task1.Id + ',' + task2.Id);
            Test.setCurrentPage(pr);
            
            TaskMassChangeOwner controller = new TaskMassChangeOwner();
            controller.assignToOwnerClick();
            controller.task.OwnerId = ob_csr.Id;
            controller.assignToOwnerClick();
            // Test Stop
            Test.stopTest();
            System.assertEquals(controller.task.OwnerId, ob_csr.Id);
       }
    }
}