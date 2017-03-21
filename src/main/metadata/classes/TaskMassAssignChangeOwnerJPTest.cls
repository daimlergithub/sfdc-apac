@isTest
private class TaskMassAssignChangeOwnerJPTest {
  
    static testMethod void myUnitTest1() {
                   
        User ob_sv = UtilTestData.createUser('OB TL','CAC OB TL');
        
        User ob_csr = UtilTestData.createUser('OB CSR','CAC OB CSR');
        List<id> ssiIDs = new List<id>();
       
        System.runAs ( ob_sv ) {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
            Test.startTest();
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            ssiIDs.add(ssi.id);
            Id wcrtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
            Task task1 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task1;
            Task task2 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task2;
            
            PageReference pr = new PageReference('/apex/TaskMassChangeOwner?objIds=' + task1.Id + ',' + task2.Id);
            Test.setCurrentPage(pr);
            
            TaskMassAssignChangeOwnerJP controller = new TaskMassAssignChangeOwnerJP();            
            controller.task.OwnerId = ob_csr.Id;
            controller.assignToOwnerClick();           
            controller.updateRelatedSSIs(ssiIDs, ob_csr.Id);
           // controller.assignToOwnerClick();
            task1 = [Select OwnerId From Task Where Id = :task1.id];
            task2 = [Select OwnerId From Task Where Id = :task2.id];
           ssi = [Select OwnerId From SSI__c Where Id = :ssi.Id];
             
            // Test Stop
            Test.stopTest();
            System.assertEquals(ssi.OwnerId, ob_csr.Id);
       }
    }
    
    
    static testMethod void myUnitTest2() {
                   
        User ob_csr = UtilTestData.createPortalUser('OB CSR','Japan Dealer Company Manager');
        List<id> ssiIDs = new List<id>();
       
        System.runAs ( ob_csr ) {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
            Test.startTest();
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            ssiIDs.add(ssi.id);
            Id wcrtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
            Task task1 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task1;
            Task task2 = new Task(RecordTypeId = wcrtid, Subject = 'Welcome Call', WhatId = ssi.Id);
            insert task2;
            
            PageReference pr = new PageReference('/apex/TaskMassChangeOwner?objIds=' + task1.Id + ',' + task2.Id);
            Test.setCurrentPage(pr);
            
            TaskMassAssignChangeOwnerJP controller = new TaskMassAssignChangeOwnerJP();            
            controller.task.OwnerId = ob_csr.Id;
            controller.assignToOwnerClick();           
            controller.updateRelatedSSIs(ssiIDs, ob_csr.Id);
           // controller.assignToOwnerClick();
            task1 = [Select OwnerId From Task Where Id = :task1.id];
            task2 = [Select OwnerId From Task Where Id = :task2.id];
            ssi = [Select OwnerId From SSI__c Where Id = :ssi.Id];
            
            try {
                controller.task = new Task();
                controller.assignToOwnerClick(); 
            } catch(Exception e) {
                
            }
            // Test Stop
            Test.stopTest();
            System.assertEquals(ssi.OwnerId, ob_csr.Id);
       }
    }
  }