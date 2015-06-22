@isTest
private class TaskTriggerHandlerTest {

    private static list<Task> listTask1 =new list<Task>();
    private static map<id,Task> taskMap1 = new map<id,Task>();
    private static Account customer; 
    private static id recAnnualId=Schema.SObjectType.Task.getRecordTypeInfosByName().get('Annual Call').getRecordTypeId();
    private static Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
    
        private static Id ssirtid = rtMap.get(UtilConstant.SSI_TASK).getRecordTypeId();
        private static Id ibrtid = rtMap.get(UtilConstant.IB_CALL).getRecordTypeId();
        private static Id obrtid = rtMap.get(UtilConstant.OB_CALL).getRecordTypeId();
        private static Id obtrtid = rtMap.get(UtilConstant.OB_TASK).getRecordTypeId();
        private static Id eDMrtid = rtMap.get('eDM').getRecordTypeId();
    private static void createAccount()
    {
          customer = new Account(
                PersonMobilePhone = '1130111111',
                PersonOtherPhone = '1302222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
            );
    
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
        
    }
   
    static testMethod void myUnitTest0()
    {
       
        //User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');

        //System.runAs ( ssi_csr ) 
        //{
        createAccount();
        
           
            Test.startTest();
            // cover autoUpdateAccountOBTaskMessage
            Task accobTask = new Task(RecordTypeId = obtrtid, WhatId = customer.Id);
            insert accobTask;
            customer = [
                Select Id, Last_OB_Task_Create_Date__c 
                From Account
                Where Id = :customer.Id];
            accobTask = [Select Id, CreatedDate From Task Where Id = :accobTask.Id];    
            // cover updateAccountCallMessage
            DateTime endCallTime = DateTime.now();
            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask;
            
            obTask.Called__c = '13011111111';
            obTask.OB_Status__c = 'busy';
            update obTask;
           
            endCallTime = DateTime.now();
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '13011111111';
            obTask.OB_Status__c = 'successful';
            update obTask;
            
            endCallTime = DateTime.now().addMinutes(10);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '13022222222';
           
            update obTask;
            
            endCallTime = DateTime.now().addMinutes(20);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234567';
            
            update obTask;
        
           
        
            listTask1.add(obTask);          
            taskMap1.put(obTask.id, obTask);
            //TaskTriggerHandler.updateAccountCallMessage(taskMap1, taskMap1);
            TaskTriggerHandler.autoUpdateTaskAfterLogInserted(listTask1[0]);
            TaskTriggerHandler.autoUpdateSSISurveyStatus(listTask1[0], listTask1[0]);
            TaskTriggerHandler.generateWelcomeCall(listTask1[0],listTask1[0]);
            TaskTriggerHandler.taskFieldsUpdate(listTask1, taskMap1);
            TaskHelper.TaskFailBlacklist(listTask1,taskMap1,true,true);
            TaskHelper.updateCampaignMemberStatus(listTask1,taskMap1,true,true);
            TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(listTask1,taskMap1,true,true);           
            TaskHelper.FillintheCampaignNameBasedontheRelatedtoObject(listTask1,taskMap1,true,true);
            Test.stopTest();
        
        //verify
        
         customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            System.assertNotEquals(customer.Last_Successful_Call__c, endCallTime);
            System.assertNotEquals(customer.Last_Successful_Call_Mobile__c, endCallTime);
            
        
        //}    
    }
    
    static testMethod void myUnitTest1() {

        
    
        //User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');

       // System.runAs ( ssi_csr )
       // {
             createAccount();
            
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
            
            endCallTime = DateTime.now().addMinutes(40);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234569';
           
            update obTask;
            customer = [
                Select Id, Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            
            
            Task intask = new Task(recordtypeid = ibrtid, CallType = 'Inbound', WhatId = customer.Id, Caller__c = '13020130906');
            insert intask;
            
            intask.Activity_Status__c = 'Successful';
            intask.IB_Status__c = 'Valid';
            update intask;
            intask = [Select Id, Activity_Status__c, IB_Status__c, Phone__c From Task Where Id=:intask.Id];
            
            
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
            intask.Activity_Status__c = 'Closed';
            update intask;
       
            listTask1.add(intask);
        
           
            taskMap1.put(intask.id, intask);
        
             //TaskTriggerHandler.updateAccountCallMessage(taskMap1, taskMap1);
            TaskTriggerHandler.autoUpdateTaskAfterLogInserted(listTask1[0]);
            TaskTriggerHandler.autoUpdateSSISurveyStatus(listTask1[0], listTask1[0]);
            TaskTriggerHandler.generateWelcomeCall(listTask1[0],listTask1[0]);
            TaskTriggerHandler.taskFieldsUpdate(listTask1, taskMap1);
            TaskHelper.TaskFailBlacklist(listTask1,taskMap1,true,true);
            TaskHelper.updateCampaignMemberStatus(listTask1,taskMap1,true,true);
            TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(listTask1,taskMap1,true,true);
            
            TaskHelper.FillintheCampaignNameBasedontheRelatedtoObject(listTask1,taskMap1,true,true);
            Test.stopTest();
        //verify
            System.assertEquals(obTask.WhatId, customer.Id);
            System.assertEquals(intask.Activity_Status__c, 'Closed');
        //}    
    }

  
    static testMethod void myUnitTest3()
    {
           
       // User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
       // System.runAs ( ssi_csr )
       // {
         createAccount();    
        Test.startTest();
            
            Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
            insert obTask;
            SSI__c ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;
            
            Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
            Task ssiTask = new Task(RecordTypeId = ssirtid, WhatId = ssi.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert ssiTask;
            // cover autoUpdateTaskAfterLogInserted
            ssi.Newly_Task_Id__c = ssiTask.Id;
            update ssi;
            
            DateTime callTime = DateTime.now();
            Task logTask = new Task(
                WhatId = ssi.Id,
                Related_Task_Id__c = ssiTask.Id, 
                RecordTypeId = OBRTID, 
                Start_call_time__c = callTime
            );
            insert logTask;
         
            ssiTask = [Select OB_Call_Times__c, Last_OB_Call__c,WhatId From Task Where Id = :ssiTask.Id ];
            
            callTime = DateTime.now();
            logTask.Start_call_time__c = callTime;
            update logTask;
            ssiTask = [Select OB_Call_Times__c, Last_OB_Call__c,WhatId From Task Where Id = :ssiTask.Id ];
            
            Task cobTask = new Task(RecordTypeId = obrtid,WhoId = cont.Id, WhatId = ssi.Id, Subject = 'Campagin Task');
            insert cobTask;
        
           
           
        
            customer.Newly_Task_Id__c = cobTask.Id;
            update customer;
        
        listTask1.add(cobTask);          
            taskMap1.put(cobTask.id, cobTask);
           // TaskTriggerHandler.updateAccountCallMessage(taskMap1, taskMap1);
            TaskTriggerHandler.autoUpdateTaskAfterLogInserted(listTask1[0]);
            TaskTriggerHandler.autoUpdateSSISurveyStatus(listTask1[0], listTask1[0]);
            TaskTriggerHandler.generateWelcomeCall(listTask1[0],listTask1[0]);
            TaskTriggerHandler.taskFieldsUpdate(listTask1, taskMap1);
            TaskHelper.TaskFailBlacklist(listTask1,taskMap1,true,true);
            TaskHelper.updateCampaignMemberStatus(listTask1,taskMap1,true,true);
            TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(listTask1,taskMap1,true,true);
            
            TaskHelper.FillintheCampaignNameBasedontheRelatedtoObject(listTask1,taskMap1,true,true); 
        
            Test.stopTest();
        //verify
            System.assertEquals(customer.Newly_Task_Id__c,cobTask.Id);
            System.assertEquals(logTask.Start_call_time__c,callTime);
            System.assertEquals(ssiTask.WhatId,ssi.Id);
       // }
    }

    

    static testMethod void TestCTIFunction() 
    {

        createAccount();
        Test.startTest();
         
       
        customer = [Select PersonContactId From Account Where Id =: customer.Id];
        
        Task obTask = new Task(RecordTypeId = obtrtid, WhoId = customer.PersonContactId, WhatId = customer.Id, Subject = 'Campagin Task');
        insert obTask;

        String callObject = 'CALLOBJECT123456789';
        String UCID = 'test123456789';
        DateTime Start_call_time = Datetime.now();
        DateTime End_call_time = Datetime.now().addMinutes(10);

        Task obCall = new Task(RecordTypeId = obrtid, callObject = callObject, WhatId = customer.Id, UCID__c = UCID, Start_call_time__c = Start_call_time, End_call_time__c = End_call_time);
        insert obCall;

        Task obCall1 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject);
        insert obCall1;

        Task obCall2 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject+'1');
        insert obCall2;
        listTask1.add(obCall);          
            taskMap1.put(obCall.id, obCall);
        Test.stopTest();
        //verify
        System.assertEquals(obTask.WhoId, customer.PersonContactId);
        System.assertEquals(obTask.WhatId, customer.Id);
        System.assertEquals(obCall1.Related_Task_Id__c, obTask.Id);
        System.assertEquals(obCall1.RecordTypeId, obrtid);
    }
     static testMethod void testAuTriggerHandler() 
    {
           
        //create test data    
        
        createAccount(); 
        
        Vehicle__c vehicle = new Vehicle__c();
        insert vehicle;
        
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer',Individual_Home_Phone__c='3697854698',Work_Phone__c='2457895847',Mobile__c='1248795468');
        insert dealer;
        
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(Account__c =dealer.id ,RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;    
           
        Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
               
      //start test
        Test.startTest();
            Task ssiTask = new Task(RecordTypeId = recAnnualId, WhatId = contract.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert ssiTask;
           
            ssiTask.Activity_Status__c = 'Unanswered';
            ssiTask.ActivityDate = system.today();
            ssiTask.Notification_Email_Flag__c=true;
            ssiTask.Status = 'Closed';
            update ssiTask;
        
        Test.stopTest();           

          //verify  
          ssiTask=[select HomeMobilePhone__c,OfficePhone__c,PersonHomePhone__c,Activity_Date__c from Task]; 
          system.assertEquals(ssiTask.HomeMobilePhone__c, dealer.Individual_Home_Phone__c);
          system.assertEquals(ssiTask.OfficePhone__c, dealer.Work_Phone__c);
          system.assertEquals(ssiTask.PersonHomePhone__c, dealer.Mobile__c);
          
                       
                  
    }
    static testMethod void testUpdateAccountCallMessage() 
    {
      list<Task> listOldTask1 = new list<Task>();
      list<Task> listNewTask1 = new list<Task>();
      map<id,Task> taskNewMap1 = new  map<id,Task>();
      map<id,Task> tasOldkMap1 = new  map<id,Task>();
        
        
        createAccount();
        Test.startTest();  
           
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
        
        Lead__c lead1 = new Lead__c(Contact__c = customer.Id, CAC_Lead_Status__c = 'New');
        insert lead1;
        
        lead1 = [Select Successful_Call_Number__c From Lead__c Where Id =: lead1.Id Limit 1];
        
        Campaign_Lead__c cl2 = new Campaign_Lead__c(Lead__c = lead1.Id, Campaign__c = cam.Id);
        insert cl2;
        
        cl2 = [Select Successful_Call_Number__c From Campaign_Lead__c Where Id =: cl2.Id Limit 1];
      
        Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
          
        Task obTask = new Task(OB_Status__c = UtilConstant.SUCCESSFUL,RecordTypeId = obrtid, WhatId = customer.Id,CallType = 'Inbound',Called__c = '13011111111');
        insert obTask;
        
        
        listOldTask1.add(obTask);          
        tasOldkMap1.put(obTask.id, obTask);
        TaskTriggerHandler.updateAccountCallMessage(taskNewMap1, tasOldkMap1);
        
        obTask.ActivityDate = system.today();
        //obTask.WhoId = customer.Id;
        obTask.WhatId = customer.Id;
        obTask.Activity_Status__c = UtilConstant.SUCCESSFUL;
        update obTask;
        
        listNewTask1.add(obTask);          
        taskNewMap1.put(obTask.id, obTask);
        
           
        TaskTriggerHandler.updateAccountCallMessage(taskNewMap1, tasOldkMap1);
           
           
            
        Test.stopTest();
      
    }
    static testMethod void testTaskFieldsUpdate() 
    {
      list<Task> listOldTask1 = new list<Task>();
      list<Task> listNewTask1 = new list<Task>();
      map<id,Task> taskNewMap1 = new  map<id,Task>();
      map<id,Task> tasOldkMap1 = new  map<id,Task>();
        
        
        createAccount();
        Test.startTest();  
           
      
        Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
          
        Task obTask = new Task(OB_Status__c = UtilConstant.SUCCESSFUL,RecordTypeId = ibrtid, WhatId = customer.Id,Called__c = '13011111111');
        insert obTask;
        
        
        listOldTask1.add(obTask);          
        tasOldkMap1.put(obTask.id, obTask);
        
        
        obTask.ActivityDate = system.today();
        //obTask.WhoId = customer.Id;
        obTask.WhatId = customer.Id;
        obTask.CallType = 'Inbound';
        obTask.CallObject = 'test';
        obTask.UCID__c = 'test';
        obTask.Activity_Status__c = UtilConstant.SUCCESSFUL;
        update obTask;
        
        listNewTask1.add(obTask);          
        taskNewMap1.put(obTask.id, obTask);
        
       TaskTriggerHandler.taskFieldsUpdate(listNewTask1, tasOldkMap1);
       
           
           
            
        Test.stopTest();
      
    }
    static testMethod void testTaskFieldsUpdate1() 
    {
      list<Task> listOldTask1 = new list<Task>();
      list<Task> listNewTask1 = new list<Task>();
      map<id,Task> taskNewMap1 = new  map<id,Task>();
      map<id,Task> tasOldkMap1 = new  map<id,Task>();
        
        
        createAccount();
        Test.startTest();  
           
      
        Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
          
        Task obTask = new Task(OB_Status__c = UtilConstant.SUCCESSFUL,RecordTypeId = obrtid, Called__c = '13011111111');
        insert obTask;
        
        
        listOldTask1.add(obTask);          
        tasOldkMap1.put(obTask.id, obTask);
        
        
        obTask.ActivityDate = system.today();
        //obTask.WhoId = customer.Id;
        //obTask.WhatId = customer.Id;
        obTask.CallType = 'Outbound';
        obTask.CallObject = 'test';
        //obTask.UCID__c = 'test';
        obTask.Activity_Status__c = UtilConstant.SUCCESSFUL;
        update obTask;
        
        listNewTask1.add(obTask);          
        taskNewMap1.put(obTask.id, obTask);
        
       TaskTriggerHandler.taskFieldsUpdate(listNewTask1, tasOldkMap1);
       TaskTriggerHandler.generateWelcomeCall(obTask,obTask);
           
           
            
        Test.stopTest();
      
    }
    static testMethod void testGenerateWelcomeCall() 
    {
      
        
        createAccount();
        Test.startTest();  
           
      
        Contact cont = [Select Id From Contact Where AccountId = :customer.Id];
          
        Task obTask = new Task(OB_Status__c = UtilConstant.SUCCESSFUL,RecordTypeId = ssirtid, Called__c = '13011111111');
        insert obTask;    
            
        
        obTask.ActivityDate = system.today();
        //obTask.WhoId = customer.Id;
        //obTask.WhatId = customer.Id;
        obTask.CallType = 'Outbound';
        obTask.CallObject = 'test';
        obTask.Subject = 'Welcome Call + 1st Survey Call';
        //obTask.UCID__c = 'test';
        obTask.Activity_Status__c = UtilConstant.SUCCESSFUL;
        update obTask;    
        
     
       TaskTriggerHandler.generateWelcomeCall(obTask,obTask);
           
           
            
        Test.stopTest();
      
    }
   
}