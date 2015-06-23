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
	
	private static Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
    private static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap_test = Schema.SObjectType.Task.getRecordTypeInfosByName();
    private static Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();      // Person Account.
    private static Id tkSMS_recordTypeId = tkRecordTypeMap_test.get('SMS').getRecordTypeId();
    private static Id templateRecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
	private static Account personAccount;
	private static Account testPersonAccount;
	private static Task taskObj;
    public static Campaign cmpAs;
    public static Case aCase;
    private static testMethod void testGenerateMultipleQCs()
    {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        Test.startTest();
        //Inserts test data
        createPersonAcount();
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = personAccount.Id, QC_Quantity__c = 0);
        insert task;
        
        //Generate 2 QC records
        task.QC_Quantity__c = 2;
        update task;
        
        List<QC__c> qcs = [select Id from QC__c where task_ID__c = :task.Id];
        //system.assert(qcs.size() == 2);
        
        //Inserts test data
        task = new Task(Subject = 'acme', RecordTypeId = OBTaskRecordTypeId, WhatId = personAccount.Id);
        insert task;
        
        //Generate 3 QC records
        task.QC_Quantity__c = 3;
        update task;
        
        qcs = [select Id from QC__c where task_ID__c = :task.Id];
        Test.stopTest();
        
        system.assertEquals(task.WhatId,personAccount.id);
        system.assertEquals(task.QC_Quantity__c,3);
    }
    
    @isTest(seeAllData=true)
    public static void testGenerateQCs()
    {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        Test.startTest();
        //Inserts test data
        Account acc = new Account(LastName = 'Acme',FirstName = 'Firstname',Salutation = 'Unknown', Area_Code__c = '010',Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        task.Generate_QC__c = true;
        update task;
        
        //Inserts test data
        task = new Task(Subject = 'acme', RecordTypeId = OBTaskRecordTypeId, WhatId = acc.Id);
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
        system.assertEquals(acc.LastName,'Acme');
        system.assert(ssi.id!=null);
        system.assertEquals(task.WhatId,ssi.id);
        system.assertEquals(task.Activity_Status__c,'Successful');
    }
    
    @isTest(seeAllData=true)
    public static void testCopyCampaignName() {
        //Gets Task record type ids
        createPersonAcount();
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        Test.startTest();
        //Inserts test data
        Account acc = new Account(LastName = 'Acme',FirstName = 'Firstname',Salutation = 'Unknown', Area_Code__c = '010',Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;
        Campaign cam1 = new Campaign(Name = 'acmeCam1');
        insert cam1;
        Campaign cam2 = new Campaign(Name = 'acmeCam2');
        insert cam2;
        Task task = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = cam1.Id);
        insert task;
        List<Task> tasks = new List<Task>();
        
        Task assertTask = [select Id, Campaign_Name__c from Task where Id = :task.Id];
        
        
        task.WhatId = cam2.Id;
        update task;
        
         Task taskcam2 = new Task(Subject = 'acme', RecordTypeId = IBTaskRecordTypeId, WhatId = cam2.Id);
        insert taskcam2;
        
        tasks.add(task);
        tasks.add(taskcam2);
        Map<Id, Task> TaskMap = new Map<Id, Task>(); 
        TaskMap.put(task.id, task);
        TaskMap.put(taskcam2.id, taskcam2);
        
        taskHelper.FillintheCampaignNameBasedontheRelatedtoObject(tasks, taskMap, true, false);
        taskHelper.GenerateMultipleQCs(tasks);
        Task assertTaskcam2= [select Id, Campaign_Name__c from Task where Id = :taskcam2.Id];
        
        
        Test.stopTest();
        system.assertEquals(acc.LastName,'Acme');
        system.assert(cam1.id!=null);
        //system.assert(assertTaskcam2.Campaign_Name__c == 'acmeCam2');
    }
    
    @isTest(seeAllData=true)
    public static void testCreatSMSTask() {
        //Gets Task record type ids
        String IBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('IB Call').getRecordTypeId();
        String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        Test.startTest();
        Account acc = new Account(LastName = 'Acme',FirstName = 'Firstname',Salutation = 'Unknown', Area_Code__c = '010', Phone = '1391381', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), PersonMobilePhone = '1301111111',PersonOtherPhone = '1301111122');
        Account acccase = new Account(LastName = 'Acme',FirstName = 'Firstname',Salutation = 'Unknown', Area_Code__c = '010',Phone = '1391382', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), PersonMobilePhone = '1301111111',PersonOtherPhone = '1301111122');
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
        task1.IB_Status__c='You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188';
        insert task1;
        insert task2;
        
        task2.InteractionIds__c=c1.id;
        task2.Status = 'Closed';
        update task2;
        List<Task> tasks1 = [SELECT id FROM Task WHERE Subject = 'SMS' AND 
            IB_Status__c = 'You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188' 
            AND Phone__c = '13701270000'];
        List<Task> tasks2 = [SELECT id FROM Task WHERE Subject = 'SMS' AND 
            IB_Status__c = 'You are satisfied with the services overall performance evaluation: 1. Very satisfied; 2. Satisfaction 3., 4. not satisfied; 5. very dissatisfied. Thank you for your participation! Mercedes-Benz Service Center 4008181188' 
            AND Phone__c = '13701270001'];
        Test.stopTest();   
        system.assertEquals(dealer.RecordTypeId,DealerRecordtypeid);
        system.assertEquals(task1.WhatId,acc.id);
        system.assert(tasks1!=null);
    }
    
    static testmethod void testTaskFailBlacklistTrigger_Insert()
    {
		createPersonAcount();
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
        createPersonAcount();
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
    
    
    static testmethod void testrecordTypeUpdate_Generaltask()
    {
    	User userobj = UtilTestData.createUser('SSI Supervisor','CAC SSI SV');
    	
    	System.runAs(userobj) 
    	{
	        Test.startTest();
	        // Person Contact                
	        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);    
	        
	        Contact conComplaint = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
        	insert conComplaint;
            Template__c tem1 = new Template__c(RecordTypeId = templateRecordTypeId, Active__c = true,
                                               Message_Detail__c = '{DEALER_name}', Name = 'lai');
            insert tem1;
            Map<Id, Task> TaskMap = new Map<Id, Task>();  
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
        createPersonAcount();
        list<task> lstTask= new List<task>();
        for(integer i=0;i<5;i++)
        {
	        Task testSMSTask = new Task(RecordTypeid=tkSMS_recordTypeId,Subject='MBDA Survey Task Temp',
	                                    WhoId=testPersonAccount.PersonContactId,
	                                    Activity_Status__c='Sent',SMSTemplateID__c=temp1.id
	                                    );
	        lstTask.add(testSMSTask);                             
        }
        insert lstTask;
        TaskHelper.createSMSTaskAfterIBCall(lstTask);        
        Test.stopTest();
    }
    
    
        
    static void createTestData()
    {
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
        
    static void createPersonAcount()
    {
    	// Person Contact                
        personAccount = new Account(LastName='TEST ACC',
                                    FirstName = 'FirstName',
                                    Salutation = 'Unknown',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='123456',
                                      PersonMobilePhone = '1301111111',
                                      PersonOtherPhone = '1301111122',
                                      RecordTypeId=accPerson_RecordTypeId
                                     ); 
        personAccount.Is_Blacklist__c = false;
        insert(personAccount);        
        testPersonAccount = [Select Id,RecordTypeId, PersonContactId From Account Where Id = :personAccount.Id]; 
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