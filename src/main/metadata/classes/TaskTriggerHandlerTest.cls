@isTest
private class TaskTriggerHandlerTest {
    public static Id OBRTID;
    private static Id IBRTID; 
    private static Id SSIRTID;
    private static Id WCRTID;
    private static Id OBTRTID;
    public static Account customer;
    public static DateTime endCallTime;
    public static Task obTask1;
    public static User ssi_csr1;
    
   public  static testMethod void testGetRecordTypeId(){
        Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
         ssirtid = rtMap.get('SSI Task').getRecordTypeId();
         wcrtid = rtMap.get('Welcome Call').getRecordTypeId();
         ibrtid = rtMap.get('IB Call').getRecordTypeId();
         obrtid = rtMap.get('OB Call').getRecordTypeId();
         obtrtid = rtMap.get('OB Task').getRecordTypeId();
        
    }
    

    static testMethod void testUpdateAccountCallMessage1() {
        
    	ssi_csr1 = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        System.runAs ( ssi_csr1 ){
             endCallTime = DateTime.now();
            customer = new Account( PersonMobilePhone = '1302222220',PersonOtherPhone = '1130111111',Phone = '1130111112',PersonHomePhone = '1234567',PersonAssistantPhone = '1234569');
    
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();
            testgetRecordTypeId();
           
            obTask1 = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask1;
          
            obTask1.Activity_Status__c = 'successful';
            obTask1.OB_Status__c='successful';
            obTask1.End_call_time__c = endCallTime;
            obTask1.Called__c = '1130111111';
            update obTask1;
   
            
         customer = [ select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                        From Account Where Id = :customer.Id];           
         System.assertEquals(customer.Last_Successful_Call_Second_Mobile__c, endCallTime);     
         }    
    }
        static testMethod void testUpdateAccountCallMessage2() {
        
    	ssi_csr1 = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        System.runAs ( ssi_csr1 ){
             endCallTime = DateTime.now();
            customer = new Account( PersonMobilePhone = '1130111111',PersonOtherPhone = '1130111111',Phone = '1130111112',PersonHomePhone = '1302222220',PersonAssistantPhone = '1234568');
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();
            testgetRecordTypeId();
           
            obTask1 = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask1;
           
         
            obTask1.Activity_Status__c = 'successful';
            obTask1.OB_Status__c='successful';
            obTask1.End_call_time__c = endCallTime;
            obTask1.Called__c = '1302222220';
            update obTask1;
                       
            
         customer = [ select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                        From Account Where Id = :customer.Id];           
         System.assertEquals(customer.Last_Successful_Call_Home_Phone__c, endCallTime);     
         }    
    }
    static testMethod void testUpdateAccountCallMessage3() {
        
    	ssi_csr1 = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        System.runAs ( ssi_csr1 ){
             endCallTime = DateTime.now();
            customer = new Account( PersonMobilePhone = '1130111111',PersonOtherPhone = '1130111111',Phone = '1302222220',PersonHomePhone = '1130111112',PersonAssistantPhone = '1234568');
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();
            testgetRecordTypeId();
           
            obTask1 = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask1;
           
         
            obTask1.Activity_Status__c = 'successful';
            obTask1.OB_Status__c='successful';
            obTask1.End_call_time__c = endCallTime;
            obTask1.Called__c = '1302222220';
            update obTask1;
                       
            
         customer = [ select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                        From Account Where Id = :customer.Id];           
         System.assertEquals(customer.Last_Successful_Call_Office_Phone__c, endCallTime);     
         }    
    }
    static testMethod void myUnitTest1() {

       testgetRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');

        System.runAs ( ssi_csr )
        {
        
            customer = new Account(
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
                Phone = '1234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569'
            );
    
            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
            
            Test.startTest();

            endCallTime = DateTime.now().addMinutes(30);

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
            obTask.OB_Status__c = 'successful';
            update obTask;
            customer = [
                Select Id, Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
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
            intask.Activity_Status__c = 'Closed';
            update intask;
            Test.stopTest();
            System.assertEquals(obTask.WhatId, customer.Id);
            System.assertEquals(intask.Activity_Status__c, 'Closed');
        }    
    }

    static testMethod void myUnitTest2() 
    {

       testgetRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_csr )
         {
            Test.startTest();
            customer = new Account(
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
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
            ssiTask.Activity_Status__c = 'Unanswered';
            ssiTask.Status = 'Closed';
            try{
            update ssiTask;
            }catch(exception e){}
            Task wcTask = new Task(RecordTypeId = wcrtid , WhatId = customer.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert wcTask ;
            
            ssi = [Select Id, Survey_Finished__c From SSI__c Where Id = :ssi.Id];
           /* Task wcTask = [
                Select Id, PersonAssistantPhone__c, PersonHomePhone__c, PersonMobilePhone__c, Called__c, PersonOtherPhone__c
                From Task Where recordtypeid = :wcrtid And AccountId = :customer.Id limit 1];*/

            Account acc = [Select Id, PersonOtherPhone, Phone, PersonMobilePhone, PersonHomePhone, PersonAssistantPhone From Account Where Id=:customer.Id];    
            Test.stopTest();
            System.assertnotEquals(ssi.Survey_Finished__c, '1st Survey');
            System.assertnotEquals(wcTask.PersonAssistantPhone__c, acc.PersonAssistantPhone);
            System.assertnotEquals(wcTask.PersonHomePhone__c, acc.PersonHomePhone);
            System.assertnotEquals(wcTask.PersonMobilePhone__c, acc.PersonMobilePhone);
            System.assertnotEquals(wcTask.Called__c, acc.Phone);
            System.assertnotEquals(wcTask.PersonOtherPhone__c, acc.PersonOtherPhone);
        }    
    }
    static testMethod void myUnitTest3()
    {
       testgetRecordTypeId();
    
        User ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        
        System.runAs ( ssi_csr )
        {
            Test.startTest();
            customer = new Account(
                PersonMobilePhone = '1301111111',
                PersonOtherPhone = '1302222222', 
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
            Test.stopTest();
            System.assertEquals(customer.Newly_Task_Id__c,cobTask.Id);
            System.assertEquals(logTask.Start_call_time__c,callTime);
            System.assertEquals(ssiTask.WhatId,ssi.Id);
        }
    }

    static testMethod void testUpdateLeadAndCampaignLead() 
    {

        testgetRecordTypeId();
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(30);   
       customer = new Account(
            PersonMobilePhone = '1301111111',
            PersonOtherPhone = '1302222222', 
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
            StartDate = date.today(),
            EndDate = date.today());
        insert cam;

        Campaign_Lead__c cl2 = new Campaign_Lead__c(Lead__c = lead1.Id, Campaign__c = cam.Id);
        insert cl2;
        cl2 = [Select Successful_Call_Number__c From Campaign_Lead__c Where Id =: cl2.Id Limit 1];

        Task obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
        insert obTask;

      endCallTime = DateTime.now();
        obTask.End_call_time__c = endCallTime;
        obTask.Called__c = '13011111111';
        obTask.OB_Status__c = 'successful';
        update obTask;
        customer = [
            Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
            From Account
            Where Id = :customer.Id];
        Test.stopTest();
        
        
        
        System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
        System.assertEquals(customer.Last_Successful_Call_Mobile__c, endCallTime);
        
    }

    static testMethod void TestCTIFunction() 
    {

       testgetRecordTypeId();
        Test.startTest();
        Datetime dt = Datetime.now();    
       customer = new Account(
            PersonMobilePhone = '1301111111',
            PersonOtherPhone = '1302222222', 
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

        Task obCall1 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject);
        insert obCall1;

        Task obCall2 = new Task(Related_Task_Id__c = obTask.Id, RecordTypeId = obrtid, WhatId = customer.Id, WhoId = customer.PersonContactId, callObject = callObject+'1');
        insert obCall2;
        
        Test.stopTest();
      //  System.assertEquals(obTask.WhoId, customer.PersonContactId);
       // System.assertEquals(obTask.WhatId, customer.Id);
        System.assertEquals(obCall1.Related_Task_Id__c, obTask.Id);
        System.assertEquals(obCall1.RecordTypeId, obrtid);
    }
}