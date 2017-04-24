@isTest
private class TaskTriggerHandlerTest {

private static Map<String, RecordTypeInfo> rtMap =  Schema.SObjectType.Task.getRecordTypeInfosByName();
private static Id ssirtid = rtMap.get('SSI Task').getRecordTypeId();
private static Id ibrtid = rtMap.get('IB Call').getRecordTypeId();
private static Id obrtid = rtMap.get('OB Call').getRecordTypeId();
private static Id obtrtid = rtMap.get('OB Task').getRecordTypeId();
private static Id eDMrtid = rtMap.get('eDM').getRecordTypeId();
private static Account customer;
private static Task accobTask;
private static Task obTask;

private static DateTime endCallTime;
private static User ssi_csr;
private static User ssi_csruser;
private static User User_ssi_csr;
private static SSI__c ssi;
private static Task ssiTask;
private static Contact cont;
private static Lead__c lead1;
private static Campaign cam;
private static Campaign_Lead__c cl2;
private static String successful='successful';
public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

  public static void preparedUserProfile()
  {
   ssi_csr = UtilTestData.createUser('SSI CSR','CAC SSI CSR'); 
   User anotherUser = UtilTestData.createUser('SSI CSR','CAC OB TL'); 
  }
  
    
public static void preparedTestData()
{
                                
            customer = new Account(
                PersonMobilePhone = '1130111111',
                PersonOtherPhone = '1302222222', 
                Phone = '01234567', 
                PersonHomePhone = '1234568', 
                PersonAssistantPhone = '1234569',
                MBK_Data_Source__c = 'Email',
                Mobile__c = '00000009842',
               Last_Successful_Call__c =DateTime.now().addMinutes(10)
            );
            
     customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
     
      // cover autoUpdateAccountOBTaskMessage

            accobTask = new Task(RecordTypeId = obtrtid, WhatId = customer.Id);
            insert accobTask;  
            endCallTime = DateTime.now();
            obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id, End_call_time__c = endCallTime);
            insert obTask;
             ssi = new SSI__c(Status__c = 'Matched');
            insert ssi;                                     
            cont = [Select Id From Contact Where AccountId = :customer.Id];
                                                        
            ssiTask = new Task(RecordTypeId = eDMrtid, WhatId = ssi.Id, WhoId = cont.Id, Subject = 'Welcome Call + 1st Survey Call');
            insert ssiTask; 
            
            
            }

    static testMethod void TestaskTriggerHandler()
    {
       
                 
      preparedUserProfile();

        System.runAs ( ssi_csr ) 
        {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;
            
                 preparedTestData();                      
            Test.startTest();
           
            customer = [
                Select Id, Last_OB_Task_Create_Date__c 
                From Account
               Where Id = :customer.Id];
            accobTask = [Select Id, CreatedDate From Task Where Id = :accobTask.Id];    
            // cover updateAccountCallMessage
            
            
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
            obTask.OB_Status__c = successful;
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            
            endCallTime = DateTime.now().addMinutes(10);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '13022222222';
            obTask.OB_Status__c = successful;
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            
            endCallTime = DateTime.now().addMinutes(20);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234567';
            obTask.OB_Status__c = successful;
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            Test.stopTest();
            //System.assertEquals(customer.Last_Successful_Call__c, endCallTime);
           //System.assertEquals(customer.Last_Successful_Call_Office_Phone__c, endCallTime);
           

           /*TaskTriggerHandlerKR ttr = new TaskTriggerHandlerKR();
           ttr.handleTrigger(false,false,false,false,false);
           ttr.handleIntegrationTrigger(false,false,false,false,false);*/
        }    
    }
    
      static testMethod void myUnitTest1() {
     
      ssi_csruser= UtilTestData.createUser('SSI CSR','CAC SSI CSR');
                
       System.runAs ( ssi_csruser )
        {
                
         preparedTestData();             
            Test.startTest(); 
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
                                                insert updatecustomsettings;
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234568';
            obTask.OB_Status__c = successful;
            update obTask;
            customer = [
                Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            
            endCallTime = DateTime.now().addMinutes(40);
            obTask.End_call_time__c = endCallTime;
            obTask.Called__c = '1234569';
            obTask.OB_Status__c = successful;
            update obTask;
            customer = [
                Select Id, Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
                From Account
                Where Id = :customer.Id];
            Task intask = new Task(recordtypeid = ibrtid, CallType = 'Inbound', WhatId = customer.Id, Phone__c = '13020130906');
            insert intask;
            
            intask.Activity_Status__c = 'successful';
            intask.IB_Status__c = 'Valid';
            update intask;
            intask = [Select Id, Activity_Status__c, IB_Status__c, Phone__c From Task Where Id=:intask.Id];
            System.assertEquals(intask.Activity_Status__c, 'Valid');
            System.assertEquals(intask.Phone__c, null);
            
            intask.recordtypeid = ssirtid;
            intask.CallType = '';
            intask.Activity_Status__c ='successful';
            intask.OB_Status__c = 'Invalid';
            update intask;
           intask = [Select Id, Activity_Status__c, OB_Status__c From Task Where Id=:intask.Id];
            
            intask.recordtypeid = obrtid;
            intask.CallType = 'Outbound';
            intask.Activity_Status__c = successful;
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
        User_ssi_csr = UtilTestData.createUser('SSI CSR','CAC OB TL');        
        System.runAs ( User_ssi_csr )
         {  
              List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
                                               insert updatecustomsettings;
            preparedTestData();             
            Test.startTest();
                     
            ssiTask.Activity_Status__c = 'Unanswered';
            ssiTask.Status = 'Closed';
            update ssiTask;
            
            ssi = [Select Id, Survey_Finished__c From SSI__c Where Id = :ssi.Id];
            Task wcTask = [
                Select Id, AccountId,PersonAssistantPhone__c, PersonHomePhone__c, PersonMobilePhone__c, Called__c, PersonOtherPhone__c
                From Task Where recordtypeid = :eDMrtid And AccountId = :customer.Id limit 1];
              
            Test.stopTest();
            system.assertEquals(wcTask.accountid,customer.Id);
           
        }    
    }
    
   static testMethod void doGenerateWC()
    {
       preparedUserProfile();
        
       System.runAs ( ssi_csr )
       {
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
                                insert updatecustomsettings;
           preparedTestData();    
            Test.startTest();           
            
            // cover autoUpdateTaskAfterLogInserted
            ssi.Newly_Task_Id__c = ssiTask.Id;
           
            update ssi;
           // obTask = new Task(Activity_Status__c = 'Voice Mail',Record)
            ssiTask.Activity_Status__c  ='Voice Mail';
            ssiTask.RecordTypeId = ssirtid ;
            ssiTask.Status ='Closed';
            ssiTask.subject = 'Welcome Call + 1st Survey Call';
            update ssiTask;
            
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
    
    static testMethod void testLeadAndCampaignLeadUpdate() 
    {          
    preparedTestData();
     preparedTestDataLead();    
          Test.startTest();   
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
                                insert updatecustomsettings;
        cl2 = [Select Successful_Call_Number__c From Campaign_Lead__c Where Id =: cl2.Id Limit 1];    
        endCallTime = DateTime.now();
        obTask.End_call_time__c = endCallTime;
        obTask.Called__c = '13011111111';
        obTask.OB_Status__c = successful;
        update obTask;
        customer = [
            Select Last_Successful_Call__c, Last_Successful_Call_Second_Mobile__c, Last_Successful_Call_Office_Phone__c, Last_Successful_Call_Mobile__c, Last_Successful_Call_Home_Phone__c 
            From Account
            Where Id = :customer.Id];                 
        Test.stopTest();
        System.assertEquals(obTask.WhatId, customer.Id);
    }
    
     static testMethod void TestCTIFunction() 
    {
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
                                insert updatecustomsettings;
        preparedTestData();
       Test.startTest();
        customer = [Select PersonContactId From Account Where Id =: customer.Id];
        
        obTask = new Task(RecordTypeId = obtrtid, WhoId = customer.PersonContactId, WhatId = customer.Id, Subject = 'Campagin Task');
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
        System.assertEquals(obTask.WhoId, customer.PersonContactId);
        System.assertEquals(obTask.WhatId, customer.Id);
        System.assertEquals(obCall1.Related_Task_Id__c, obTask.Id);
        System.assertEquals(obCall1.RecordTypeId, obrtid);
    }
    
    public static void preparedTestDataLead()
    {
    preparedTestData();
    lead1 = new Lead__c(Contact__c = customer.Id, CAC_Lead_Status__c = 'New');
        insert lead1;
        lead1 = [Select Successful_Call_Number__c From Lead__c Where Id =: lead1.Id Limit 1];

         cam = new Campaign(
            Name = 'TestData_CCA_Campaign',
            Campaign_Code__c = 'Code_CCA',
            Type = 'Other',
            Campaign_Objectives__c = 'Objectives',
            Description = 'Description',
            Status = 'Confirmed',
            StartDate = date.today().addDays(10),
            EndDate = date.today().addDays(20));
        insert cam;

          cl2 = new Campaign_Lead__c(Lead__c = lead1.Id, Campaign__c = cam.Id);
        insert cl2;
        obTask = new Task(RecordTypeId = obrtid, WhatId = customer.Id);
        insert obTask;
    }
}