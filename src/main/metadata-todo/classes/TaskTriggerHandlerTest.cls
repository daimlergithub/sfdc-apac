@isTest
private class TaskTriggerHandlerTest {

    static testMethod void myUnitTest0() {
        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
        Id wcrtid = rtMap.get('Welcome Call').getRecordTypeId();
        Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
        Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');

        System.runAs ( ssi_csr ) {
        
            Account customer = new Account(
                PersonMobilePhone = '13011111111',
                PersonOtherPhone = '13022222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569'
            );
    
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();
            
            // cover autoUpdateAccountOBTaskMessage
            Task accobTask = new Task(RecordTypeId = obtrtid, WhatId = customer.Id);
            insert accobTask;
            customer = [
                Select Id, Last_OB_Task_Create_Date__c 
                From Account
                Where Id = :customer.Id];
            accobTask = [Select Id, CreatedDate From Task Where Id = :accobTask.Id];    
            System.assertEquals(customer.Last_OB_Task_Create_Date__c, accobTask.CreatedDate.Date());

            // cover updateAccountCallMessage
            DateTime endCallTime = DateTime.now();
            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask;
            
            obTask.Called__c = '13011111111';
            obTask.OB_Status__c = 'busy';
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertNotEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertNotEquals(customer.Last_Successful_Call_Mobile__c, endCallTime);
            
            endCallTime = DateTime.now();
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '13011111111';
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertEquals(customer.Last_Successful_Call_Mobile__c, endCallTime);
            
            endCallTime = DateTime.now().addMinutes(10);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '13022222222';
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertEquals(customer.Last_Successful_Call_Second_Mobile__c, endCallTime);
            
            endCallTime = DateTime.now().addMinutes(20);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234567';
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertEquals(customer.Last_Successful_Call_Office_Phone__c, endCallTime);
            
            Test.stopTest();
        }    
    }
    
    static testMethod void myUnitTest1() {

        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
        Id smartSsirtid = rtMap.get('smart SSI Task').getRecordTypeId();
        Id wcrtid = rtMap.get('Welcome Call').getRecordTypeId();
        Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
        Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');

        System.runAs ( ssi_csr ) {
        
            Account customer = new Account(
                PersonMobilePhone = '13011111111',
                PersonOtherPhone = '13022222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569'
            );
    
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();

            DateTime endCallTime = DateTime.now().addMinutes(30);

            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask;
            
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234568';
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertEquals(customer.Last_Successful_Call_Home_Phone__c, endCallTime);
            
            endCallTime = DateTime.now().addMinutes(40);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234569';
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Id, Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
            //System.assertEquals(customer.Last_Successful_Call_Extension_Number__c, endCallTime);
            
            Task intask = new Task(recordtypeid = ibrtid, CallType = 'Inbound', WhatId = customer.Id, Caller__c = '13020130906');
            insert intask;
            
            intask.Activity_Status__c = 'Successful';
            intask.IB_Status__c = 'Valid';
            update intask;
            intask = [Select Id, Activity_Status__c, IB_Status__c, Phone__c From Task Where Id=:intask.Id];
            System.assertEquals(intask.Activity_Status__c, 'Valid');
            System.assertEquals(intask.Phone__c, '13020130906');
            
            intask.recordtypeid = ssirtid;
            intask.CallType = '';
            intask.Activity_Status__c = 'Successful';
            intask.OB_Status__c = 'Invalid';
            update intask;
            intask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:intask.Id];
            System.assertEquals(intask.Activity_Status__c, 'Successful');
            
            
            intask.recordtypeid = obrtid;
            intask.CallType = 'Outbound';
            intask.Activity_Status__c = 'Successful';
            intask.OB_Status__c = 'Invalid';
            intask.Called__c = '13120130906';
            update intask;
            intask = [Select Id, Activity_Status__c, OB_Status__c, Phone__c From Task Where Id=:intask.Id];
            System.assertEquals(intask.Activity_Status__c, 'Invalid');
            System.assertEquals(intask.Phone__c, '13120130906');
            intask.Activity_Status__c = 'Closed';
            update intask;
            intask.recordtypeid = smartSsirtid;
            update intask;
            Test.stopTest();
        }    
    }

    static testMethod void myUnitTest2() {

        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
        Id wcrtid = rtMap.get('Welcome Call').getRecordTypeId();
        Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
        Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_csr ) {
        
            Account customer = new Account(
                PersonMobilePhone = '13011111111',
                PersonOtherPhone = '13022222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569'
            );
        
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        
            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
            insert obTask;
            // cover generateWelcomeCall
            System.debug('-------------Test generateWelcomeCall-----------------');
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            
            Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
            Task ssiTask = new Task(RecordTypeId = ssirtid, WhatId = ssi.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert ssiTask;
            Test.startTest();
            ssiTask.Activity_Status__c = 'Unanswered';
            ssiTask.Status = 'Closed';
            update ssiTask;
            
            ssi = [Select Id, Survey_Finished__c From SSI__c Where Id = :ssi.Id];
            System.assertEquals(ssi.Survey_Finished__c, '1st Survey');
            Task wcTask = [
                Select Id, PersonAssistantPhone__c, PersonHomePhone__c, PersonMobilePhone__c, Called__c, PersonOtherPhone__c
                From Task Where recordtypeid = :wcrtid And AccountId = :customer.Id limit 1];

            Account acc = [Select Id, PersonOtherPhone, Phone, PersonMobilePhone, PersonHomePhone, PersonAssistantPhone From Account Where Id=:customer.Id];    
            System.assertEquals(wcTask.PersonAssistantPhone__c, acc.PersonAssistantPhone);
            System.assertEquals(wcTask.PersonHomePhone__c, acc.PersonHomePhone);
            System.assertEquals(wcTask.PersonMobilePhone__c, acc.PersonMobilePhone);
            System.assertEquals(wcTask.Called__c, acc.Phone);
            System.assertEquals(wcTask.PersonOtherPhone__c, acc.PersonOtherPhone);
                        
               
            
            Test.stopTest();
        }    
    }
    static testMethod void myUnitTest3() {
                Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
        Id wcrtid = rtMap.get('Welcome Call').getRecordTypeId();
        Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
        Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_csr ) {
            Account customer = new Account(
                PersonMobilePhone = '13011111111',
                PersonOtherPhone = '13022222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569'
            );
        
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
            insert obTask;
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            
            Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
            Task ssiTask = new Task(RecordTypeId = ssirtid, WhatId = ssi.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert ssiTask;
        Test.startTest();
        // cover autoUpdateTaskAfterLogInserted
            ssi.Newly_Task_Id__c = ssiTask.Id;
            update ssi;
            Survey_Result__c sr = new Survey_Result__c(TaskId__c = ssiTask.Id);
            sr.TaskId__c = sr.TaskId__c.subString(0, 15);
            insert sr;
            
            DateTime callTime = DateTime.now();
            Task logTask = new Task(
                WhatId = ssi.Id,
                Related_Task_Id__c = ssiTask.Id, 
                RecordTypeId = OBRTID, 
                Start_call_time__c = callTime
            );
            insert logTask;
            logTask = [Select Survey_Result_Id__c From Task Where Id = :logTask.Id];
            System.assertEquals(logTask.Survey_Result_Id__c, sr.Id);            
            ssiTask = [Select OB_Call_Times__c, Last_OB_Call__c From Task Where Id = :ssiTask.Id ];
            //System.assertEquals(ssiTask.OB_Call_Times__c, 1);
            //System.assertEquals(ssiTask.Last_OB_Call__c, callTime);
            
            callTime = DateTime.now();
            logTask.Start_call_time__c = callTime;
            update logTask;
            ssiTask = [Select OB_Call_Times__c, Last_OB_Call__c From Task Where Id = :ssiTask.Id ];
            //System.assertEquals(ssiTask.OB_Call_Times__c, 1);
            //System.assertEquals(ssiTask.Last_OB_Call__c, callTime);
            
            Task cobTask = new Task(RecordTypeId = obrtid,WhoId = cont.Id, WhatId = ssi.Id, Subject = 'Campagin Task');
            insert cobTask;
            customer.Newly_Task_Id__c = cobTask.Id;
            update customer;
            Campaign_Survey_Result__c csr = new Campaign_Survey_Result__c(TaskId__c = cobTask.Id);
            csr.TaskId__c = csr.TaskId__c.subString(0, 15);
            insert csr;
            
            callTime = DateTime.now();
            Task clogTask = new Task(
                WhatId = customer.Id,
                Related_Task_Id__c = obTask.Id, 
                RecordTypeId = OBRTID, 
                Start_call_time__c = callTime
            );
            insert clogTask;
            clogTask = [Select Survey_Result_Id__c From Task Where Id = :clogTask.Id];
            System.assertEquals(clogTask.Survey_Result_Id__c, csr.Id); 
        Test.stopTest();
        }
        }

    static testMethod void testLeadAndCampaignLeadUpdate() {

        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
    
        Datetime dt = Datetime.now();    
        Account customer = new Account(
            PersonMobilePhone = '13011111111',
            PersonOtherPhone = '13022222222', 
            Phone = '1234567', 
            PersonHomePhone = '1234568', 
            PersonAssistantPhone = '1234569'
        );

        customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        
        Lead__c lead1 = new Lead__c(Contact__c = customer.Id, CAC_Lead_Status__c = 'New');
        insert lead1;
        lead1 = [Select Successful_Call_Number__c From Lead__c Where Id =: lead1.Id Limit 1];

        Campaign cam = new Campaign(
            Name = 'TestData_CCA_Campaign',
            Campaign_Code__c = 'Code_CCA',
            Type = 'Other',
            Campaign_Objectives__c = 'Objectives',
            Description = 'Description',
            Status = 'Confirmed',
            StartDate = date.today().addDays(10),
            EndDate = date.today().addDays(20));
        insert cam;

        Campaign_Lead__c cl2 = new Campaign_Lead__c(Lead__c = lead1.Id, Campaign__c = cam.Id);
        insert cl2;
        cl2 = [Select Successful_Call_Number__c From Campaign_Lead__c Where Id =: cl2.Id Limit 1];

        Test.startTest();

        Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
        insert obTask;

        DateTime endCallTime = DateTime.now();
        obTask.End_call_time__c = endCallTime;
        obTask.Called__c = '13011111111';
        obTask.OB_Status__c = 'successful';
        update obTask;
        customer = [
            Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
            From Account
            Where Id = :customer.Id];

        System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
        System.assertEquals(customer.Last_Successful_Call_Mobile__c, endCallTime);

        Test.stopTest();
 
    }

    static testMethod void TestCTIFunction() {

        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
        Id obrtid = rtMap.get('OB Call').getRecordTypeId();
        Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
    
        Datetime dt = Datetime.now();    
        Account customer = new Account(
            PersonMobilePhone = '13011111111',
            PersonOtherPhone = '13022222222', 
            Phone = '1234567', 
            PersonHomePhone = '1234568', 
            PersonAssistantPhone = '1234569'
        );

        customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 

        customer = [Select PersonContactId From Account Where Id =: customer.Id];
        
        Task obTask = new Task(RecordTypeId = obtrtid, WhoId = customer.PersonContactId, WhatId = customer.Id, Subject = 'Campagin Task');
        insert obTask;

        String callObject = 'CALLOBJECT123456789';
        String UCID = 'test123456789';
        DateTime Start_call_time = Datetime.now();
        DateTime End_call_time = Datetime.now().addMinutes(10);

        Task obCall = new Task(RecordTypeId = obrtid, callObject = callObject, WhatId = customer.Id, UCID__c = UCID, Start_call_time__c = Start_call_time, End_call_time__c = End_call_time);
        insert obCall;

        Test.startTest();

        Task obCall1 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject);
        insert obCall1;

        Task obCall2 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject+'1');
        insert obCall2;

        Test.stopTest();
 
    }


}