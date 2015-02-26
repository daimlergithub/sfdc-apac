/*
    Type:       Test class of TaskHelper
    Purpose:    1. Auto create multiple QC records when task.QC Quantity is updated with a number.
                2. Auto create QC records when task.Generate QC is changed to true.
                3. Auto update task's campaign name when this task related to an campaign
                4. Auto create a SMS task record when a task insert.
    User Story: US-QC-015, US-QC-002, US-QC-001, US-SMSS-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-05-03
*/
@isTest
private class TaskHelperTest {
    private static testMethod void testGenerateMultipleQCs() {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        
        //Inserts test data
        Account acc = new Account(LastName = 'Acme', Area_Code__c = '010',Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = acc.Id, QC_Quantity__c = 0);
        insert task;
        
        //Generate 2 QC records
        task.QC_Quantity__c = 2;
        update task;
        
        List<QC__c> qcs = [select Id from QC__c where task_ID__c = :task.Id];
        //system.assert(qcs.size() == 2);
        
        //Inserts test data
        task = new Task(Subject = 'acme', RecordTypeId = OBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        
        //Generate 3 QC records
        task.QC_Quantity__c = 3;
        update task;
        
        qcs = [select Id from QC__c where task_ID__c = :task.Id];
        //system.assert(qcs.size() == 3);
    }
    
    @isTest(seeAllData=true)
    public static void testGenerateQCs() {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        
        //Inserts test data
        Account acc = new Account(LastName = 'Acme', Area_Code__c = '010',Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        task.Generate_QC__c = true;
        update task;
        
        List<QC__c> qcs = [select Id from QC__c where task_ID__c = :task.Id];
        system.assert(qcs.size() == 1);
        
        //Inserts test data
        task = new Task(Subject = 'acme', RecordTypeId = OBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        task.Generate_QC__c = true;
        update task;
        
        qcs = [select Id from QC__c where task_ID__c = :task.Id];
        system.assert(qcs.size() == 1);
        
        //Inserts test data
        SSI__c ssi = new SSI__c();
        insert ssi;
        task = new Task(Subject = '1st Survey Result', RecordTypeId = SSITaskRecordTypeId, WhatId = ssi.Id);
        insert task;
        
        task.Activity_Status__c = 'Successful';
        update task;
    }
    
    @isTest(seeAllData=true)
    public static void testCopyCampaignName() {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        
        //Inserts test data
        Account acc = new Account(LastName = 'Acme', Area_Code__c = '010',Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        Campaign cam1 = new Campaign(Name = 'acmeCam1');
        insert cam1;
        Campaign cam2 = new Campaign(Name = 'acmeCam2');
        insert cam2;
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = cam1.Id);
        insert task;
        
        Task assertTask = [select Id, Campaign_Name__c from Task where Id = :task.Id];
        system.assert(assertTask.Campaign_Name__c == 'acmeCam1');
        
        task.WhatId = cam2.Id;
        update task;
        assertTask = [select Id, Campaign_Name__c from Task where Id = :task.Id];
        system.assert(assertTask.Campaign_Name__c == 'acmeCam2');
    }
    
    @isTest(seeAllData=true)
    public static void testCreatSMSTask() {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        
        Account acc = new Account(LastName = 'Acme', Area_Code__c = '010', Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), PersonMobilePhone = '13701270000');
        Account acccase = new Account(LastName = 'Acme', Area_Code__c = '010',Phone = '1391382', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), PersonMobilePhone = '13701270001');
        insert acc;
        insert acccase;
        
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        
        Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
        insert dealer;
        
        Case c1 = new Case(RecordTypeId = MBRecordtypeid, Contact_Number__c = '13701270002', Case_Dealer__c = dealer.Id);
        c1.AccountId = acccase.id;
        insert c1;
        
        Task task1 = new Task(RecordTypeId = IBTaskRecordTypeId, IB_Call_Type__c = 'Inbound', IB_Status__c = 'Valid');
        Task task2 = new Task(RecordTypeId = IBTaskRecordTypeId, IB_Call_Type__c = 'Inbound', IB_Status__c = 'Valid');
        task1.WhatId = acc.id;
        task2.WhatId = c1.id;
        insert task1;
        insert task2;
        
        List<Task> tasks1 = [SELECT id FROM Task WHERE Subject = 'SMS' AND 
            IB_Status__c = 'You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188' 
            AND Phone__c = '13701270000'];
        List<Task> tasks2 = [SELECT id FROM Task WHERE Subject = 'SMS' AND 
            IB_Status__c = 'You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188' 
            AND Phone__c = '13701270001'];
    }
}