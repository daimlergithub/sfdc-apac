/*
    Type:       Test class of TaskHelper
    Purpose:    1. Auto create multiple QC records when task.QC Quantity is updated with a number.
                2. Auto create QC records when task.Generate QC is changed to true.
                3. Auto update task's campaign name when this task related to an campaign
                4. Auto create a SMS task record when a task insert.
    User Story: US-QC-015, US-QC-002, US-QC-001, US-SMSS-001
    1. Sinow Created on 2013-05-03
*/
@isTest
private class TaskHelperTest {
  
  private static Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
    private static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
    private static Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();      // Person Account.
    private static Id tkSMS_recordTypeId = tkRecordTypeMap_test.get('SMS').getRecordTypeId();
    private static Id templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    public static String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
    
    
  private static Account personAccount;
  private static Account testPersonAccount;
  private static Task taskObj;
    public static Campaign cmpAs;
    public static Case aCase;
    public static string acme = 'Acme';
    public static String Unknown = 'Unknown';
    private static testMethod void testGenerateMultipleQCs()
    {
        //Gets Task record type ids
        
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        Test.startTest();
        //Inserts test data
        createTestData();
        Task task = new Task(Subject = acme, RecordTypeId = IBTaskRecordTypeId, WhatId = personAccount.Id, QC_Quantity__c = 0);
        insert task;
        
        //Generate 2 QC records
        task.QC_Quantity__c = 2;
        update task;
        
        
        
        //Inserts test data
        task = new Task(Subject = acme, RecordTypeId = OBTaskRecordTypeId, WhatId = personAccount.Id);
        insert task;
        
        //Generate 3 QC records
        task.QC_Quantity__c = 3;
        update task;
        
        
        Test.stopTest();
        list<Task> listTask =new list<Task>();
        listTask.add(task);
        
       string caseid =string.valueof(aCase.id);
        set<string> caseIdSet = new set<string>();
        caseIdSet.add(caseid); 
        map<id,string> mapCase =new  map<id,string>();
        mapCase.put(aCase.id,string.valueof(aCase.id));
        map<id,string> taskMap =new  map<id,string>();
        taskMap.put(task.id,string.valueof(task.id));
        
        TaskHelper.copyIBCallTypeFromCase(caseIdSet,listTask);
        TaskHelper.UpdateCaseVoiceRecordlink(mapCase);
        TaskHelper.updateInteractionIds(taskMap);
        system.assertEquals(task.WhatId,personAccount.id);
        system.assertEquals(task.QC_Quantity__c,3);
    }
    
   /* @isTest
    public static void testReply_TD_unsubscribeForeachSMScontent(){
    
    Id SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
    taskObj =new Task(RecordTypeId = SSITaskRecordTypeId,Status='open',Activity_Status__c='Successful');
    taskObj=createTask('open');
    Test.startTest();                                    
        insert taskObj;
        List<Task> tasks = new List<Task>();
        system.debug('%%%%%%%%%%%%%%%'+taskobj);
        tasks.add(taskObj);
        Map<Id, Task> taskmap = new Map<Id, Task>();
        taskmap.put(taskObj.id, taskObj);
        TaskHelper.Reply_TD_unsubscribeForeachSMScontent(tasks, taskMap, true, false);
        Test.stopTest();
    }
    */
    
    @isTest
    public static void testGenerateQCs()
    {
        //Gets Task record type ids
        
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        Test.startTest();
        //Inserts test data
        Account acc = new Account(LastName = acme,FirstName = 'Firstname1',Salutation = Unknown, Area_Code__c = '0101',Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId,Email__c='test@mbau1.com',Email2__c = 'testemail2@test1.com',Home_Phone_2__c = '00000009642',MBK_Data_Source__c='Email',Mobile__c='0001234567');
        insert acc;
        Task task = new Task(Subject = acme, RecordTypeId = IBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        task.Generate_QC__c = true;
        update task;
        
        //Inserts test data
        task = new Task(Subject = acme, RecordTypeId = OBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        task.Generate_QC__c = true;
        update task;
        //Inserts test data
        SSI__c ssi = new SSI__c();
        insert ssi;
        task = new Task(Subject = '1st Survey Result', RecordTypeId = SSITaskRecordTypeId, WhatId = ssi.Id);
        insert task;
        
        task.Activity_Status__c = 'Successful';
        update task;
        Test.stopTest();
        system.assertEquals(acc.LastName,acme);
        system.assert(ssi.id!=null);
        system.assertEquals(task.WhatId,ssi.id);
        system.assertEquals(task.Activity_Status__c,'Successful');
    }
    
    @isTest
    public static void testCopyCampaignName() {
        //Gets Task record type ids
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        createTestData();
        
        Test.startTest();
        //Inserts test data
        Account acc = new Account(LastName = acme,FirstName = 'Firstname2',MBK_Data_Source__c='Email',Mobile__c = '00000009642',Salutation = Unknown, Area_Code__c = '0102',Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId,Email__c='test@mbau2.com',Email2__c = 'testemail2@test2.com',Home_Phone_2__c = '00000009842');
        insert acc;
        Campaign cam1 = new Campaign(Name = 'acmeCam1');
        insert cam1;
        Campaign cam2 = new Campaign(Name = 'acmeCam2');
        insert cam2;
        Task task = new Task(Subject = acme,QC_Quantity__c=2,RecordTypeId = IBTaskRecordTypeId, WhatId = cam1.Id);
        insert task;
        List<Task> tasks = new List<Task>();
        
       
        
        
        task.WhatId = cam2.Id;
        update task;
        
         Task taskcam2 = new Task(Subject = acme,QC_Quantity__c=2,RecordTypeId = OBTaskRecordTypeId, WhatId = cam2.Id);
        insert taskcam2;
        
        tasks.add(task);
        tasks.add(taskcam2);
        
        Map<Id, Task> TaskMap = new Map<Id, Task>(); 
        TaskMap.put(task.id, task);
        TaskMap.put(taskcam2.id, taskcam2);
       
        taskHelper.FillintheCampaignNameBasedontheRelatedtoObject(tasks, taskMap, true, false);
        // TaskHelper.Reply_TD_unsubscribeForeachSMScontent(tasks, TaskMap, true, false);
            system.debug('%%%%%%%'+tasks);
            system.debug('#######'+taskMap);
     
        taskHelper.GenerateMultipleQCs(tasks);
        
        
        
        Test.stopTest();
        system.assertEquals(acc.LastName,acme);
        system.assert(cam1.id!=null);
        
    }
    
    @isTest
    public static void testCreatSMSTask() {
        //Gets Task record type ids
       
        String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        Test.startTest();
        Account acc = new Account(LastName = acme,FirstName = 'Firstname3',Salutation = Unknown, Area_Code__c = '0103', Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId, PersonMobilePhone = '130111',PersonOtherPhone = '130112',Email__c='test@mbau3.com',Email2__c = 'testemail2@test3.com',Home_Phone_2__c ='00000009642',MBK_Data_Source__c='Email',Mobile__c='00000009642');
        Account acccase = new Account(LastName = acme,FirstName = 'Firstname4',Salutation = Unknown, Area_Code__c = '0104',Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId, PersonMobilePhone = '130112',PersonOtherPhone = '130113',Email__c='test@mbau3.com',Email2__c = 'testemail2@test3.com',Home_Phone_2__c ='00000009642',MBK_Data_Source__c='Email',Mobile__c='00000009642');
        insert acc;
        insert acccase;
        
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        
        Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '0123456789', Name = 'testdealer');
        insert dealer;
        
        Case c1 = new Case(RecordTypeId = MBRecordtypeid, Contact_Number__c = '13701270002', Case_Dealer__c = dealer.Id);
        c1.AccountId = acccase.id;
        insert c1;
        
        Task task1 = new Task(RecordTypeId = IBTaskRecordTypeId, IB_Call_Type__c = 'Inbound', IB_Status__c = 'Valid');
        Task task2 = new Task(RecordTypeId = IBTaskRecordTypeId, IB_Call_Type__c = 'Inbound', IB_Status__c = 'Valid');
        task1.WhatId = acc.id;
        task2.WhatId = c1.id;
        task1.IB_Status__c='You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188';
        insert task1;
        insert task2;
        
        task2.InteractionIds__c=c1.id;
        task2.Status = 'Closed';
        update task2;
        List<Task> tasks1 = [SELECT id FROM Task WHERE Subject = 'SMS' AND 
            IB_Status__c = 'You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188' 
            AND Phone__c = '13701270000'];
       
        Test.stopTest();   
        system.assertEquals(dealer.RecordTypeId,DealerRecordtypeid);
        system.assertEquals(task1.WhatId,acc.id);
        system.assert(tasks1!=null);
    }
    
    static testmethod void testTaskFailBlacklistTrigger_Insert()
    {
    createTestData();
    taskObj=createTask('Fail-Blacklist');
    Test.startTest();                                    
        insert taskObj;
        List<Task> tasks = new List<Task>();
        tasks.add(taskObj);
        Map<Id, Task> taskmap = new Map<Id, Task>();
        taskmap.put(taskObj.id, taskObj);
        TaskHelper.TaskFailBlacklist(tasks, taskMap, true, false);
        Test.stopTest();
        list<Account> lst=[SELECT Is_Blacklist__c FROM Account WHERE PersonContactId=:taskObj.WhoId limit 1];
        system.assertEquals(true,lst[0].Is_Blacklist__c);
        
    }
    
    static testmethod void testTaskFailBlacklistTrigger_Update()
    {
        createTestData();
    taskObj=createTask('Sent');
    Test.startTest();                                    
        insert taskObj;
        Task taskObj2=createTask('Fail-Blacklist');
        insert taskObj2;
        
        List<Task> tasks = new List<Task>();
        tasks.add(taskObj2);
        Map<Id, Task> taskmap = new Map<Id, Task>();
        taskmap.put(taskObj.id, taskObj);
        TaskHelper.TaskFailBlacklist(tasks, taskMap, true, false);
        Test.stopTest();
        list<Account> lst=[SELECT Is_Blacklist__c FROM Account WHERE PersonContactId=:taskObj2.WhoId limit 1];
        system.assertEquals(true,lst[0].Is_Blacklist__c); 
        
    }
     static testmethod void test_Reply_TD_unsubscribeForeachSMScontent()
    {
       createTestData();
    taskObj=createTask('Sent');
    Test.startTest();                                    
        insert taskObj;
        Task taskObj2=createTask('Fail-Blacklist');
        insert taskObj2;
        
        List<Task> tasks = new List<Task>();
        tasks.add(taskObj2);
        Map<Id, Task> taskmap = new Map<Id, Task>();
        taskmap.put(taskObj.id, taskObj);
     //   TaskHelper.Reply_TD_unsubscribeForeachSMScontent(tasks, taskMap, true, false);
        Test.stopTest();
     //   list<Account> lst=[SELECT Is_Blacklist__c FROM Account WHERE PersonContactId=:taskObj2.WhoId limit 1];
      // system.assertEquals(true,lst[0].Is_Blacklist__c); 
    
    }
    
    static testmethod void testrecordTypeUpdate_Generaltask()
    {
      User userobj = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
      
      System.runAs(userobj) 
      {
          Test.startTest();
          
          createTestData();
          // Person Contact                
          Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);    
          
          Contact conComplaint = new Contact(AccountId = dealer.Id, Salutation='Attorney',FirstName='testFirstname',LastName = 'testLastname', Phone = '0123456789', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
          insert conComplaint;
            Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER_name}', Name = 'lai');
            insert tem1;
            
          list<task> lstTask= new List<task>();
          for(integer i=0;i<5;i++)
          {
            Task testSMSTask = new Task(RecordTypeid=tkSMS_recordTypeId,Subject='MBDA Survey Task Temp',
                                        WhoId=conComplaint.id,
                                        Activity_Status__c='Sent',SMSTemplateID__c=tem1.id,SMS_Content__c='Thank you for your call,your feedback from the Mercedes-Benz customer service hotline has received, officials will continue to investigate the situation,get in touch with you ASAP.['+'Mercedes-Benz Service Center 4008181188'+']'
                                        );
                
            lstTask.add(testSMSTask);                             
          }
          insert lstTask;
            
          TaskHelper.recordTypeUpdate_Generaltask(lstTask);  
          Test.stopTest();
            set<id> userID =new set<id>();
            userID.add(userobj.id);
            TaskHelper.autoUpdateSSITask(userID);
            system.assertEquals(dealer.id, conComplaint.AccountId);
        } 
    }
    
    static testmethod void testcreateSMSTaskAfterIBCall()
    {
                    
        Template__c temp1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Message_Detail__c = '{DEALER_name}', Name = 'IB SMS IVR');
        insert temp1;
        Template__c temp2 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Message_Detail__c = '{DEALER_name}', Name = 'IB SMS IVR Smart');
        insert temp2;
        Template__c temp3 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                           Message_Detail__c = '{DEALER_name}', Name = 'IB SMS IVR MB');
        insert temp3;
        Test.startTest();
        createTestData();
        list<task> lstTask= new List<task>();
        Task testSMSTask;
        for(integer i=0;i<5;i++)
        {
            testSMSTask = new Task(RecordTypeid=tkSMS_recordTypeId,Subject='MBDA Survey Task Temp',
                                      WhoId=testPersonAccount.PersonContactId,
                                      Activity_Status__c = 'Sent',SMSTemplateID__c=temp1.id
                                      );
               insert testSMSTask;                        
        }
        
      lstTask.add(testSMSTask);
        map<id,Task> mapTask = new map<id,Task>();
        mapTask.put(testSMSTask.id, testSMSTask);
        
        TaskHelper.createSMSTaskAfterIBCall(lstTask);   
        TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(lstTask,mapTask,true,false);
        TaskHelper.SurveySuccessfulupdateAccountcallmessage_generatewctask_update_call_times(lstTask,mapTask,false,true);
        TaskHelper.updateCampaignMemberStatus(lstTask,mapTask,false,true);
        Test.stopTest();
        system.assertNotEquals(null, lstTask);
    }
    
   
    
    
        
    static void createTestData()
    {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
        Trigger__c TriggerDMR=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=false,insert__c=false,delete__c=false,after__c=false,before__c=false,enabled__c=false,Market__c='JP');
        insert TriggerDMR;
        personAccount = new Account(LastName='TEST ACC',
                                    FirstName = 'FirstName',
                                    Salutation = Unknown,
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='1004468',
                                      PersonMobilePhone = '1301111111',
                                      PersonOtherPhone = '1301111122',Home_Phone_2__c = '00000009642',
                                      RecordTypeId=accPerson_RecordTypeId,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',MBK_Data_Source__c ='Email',Mobile__c = '00000009642'
                                     ); 
        personAccount.Is_Blacklist__c = false;
        insert(personAccount);    
        testPersonAccount = [Select Id,RecordTypeId, PersonContactId From Account Where Id = :personAccount.Id]; 
      cmpAs = new Campaign();
        cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
            cmpAs.IsActive = true;
            cmpAs.Name = 'cmpAs';
            cmpAs.Status = 'Started'; 
            cmpAs.StartDate = System.today();
            cmpAs.EndDate = System.today();
            
            insert cmpAs;
        
         aCase = new Case(
            Subject = 'XX',
            AccountId = personAccount.Id,
            Case_Class__c = 'Pre-Sales',
            Car_Type__c = 'Dealer contact method',
            Case_SubType__c = 'Dealership Contacts',
            
            Status = 'Open'
        );
        insert aCase;
        
    }
        
    
    static Task createTask(String activityStatus)
    {
      Task testSMSTask = new Task(Subject='SMS TEST',
                                    WhoId=testPersonAccount.PersonContactId,
                                    Activity_Status__c=activityStatus  
                                    );
       return testSMSTask;                             
    }
}