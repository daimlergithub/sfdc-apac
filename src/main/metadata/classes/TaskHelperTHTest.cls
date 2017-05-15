/*
    Type:      class
    Purpose:   Test class for taskHelperTH
    Create By: Bhushan
    Created Date :2/4/2016
*/

@isTest
public class TaskHelperTHTest {
  
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
    
    @isTest
    public static void testCopyCampaignName() {
        Profile taskprofile = [select id from profile where Name='System Administrator' limit 1];
        User userTask = new User(LastName='TaskUser',country='Australia',firstName='BCI',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest@infosys.com',UserName='samTask@usgboral.com.dev01',Market__c = 'TH');
        insert userTask;
        System.runas(userTask){
            //Gets Task record type ids
            String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
            createTestData();
            
            Test.startTest();
            //Inserts test data
            Account acc = new Account(LastName = acme,FirstName = 'Firstname2',Salutation = Unknown, Area_Code__c = '0102',Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId,Email__c='test@mbau2.com',Email2__c = 'testemail2@test2.com',Home_Phone_2__c = '0987654132');
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
           
            Test.stopTest();
            system.assertEquals(acc.LastName,acme);
            system.assert(cam1.id!=null);
        }
    }
    
 
    
    static testmethod void testTaskFailBlacklistTrigger_Insert()
    {
     Profile taskprofile = [select id from profile where Name='System Administrator' limit 1];
        User userTask = new User(LastName='TaskUser1',country='thailand',firstName='BCII',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest1@infosys.com',UserName='samTask1@usgboral.com.dev01',Market__c = 'TH');
        insert userTask;
        System.runas(userTask){
    createTestData();
    taskObj=createTask('Fail-Blacklist');
    Test.startTest(); 
        //8april
        taskObj.recordtypeId = schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();                            
        insert taskObj;
        taskObj.WhatId = personAccount.id;
        //changes ends
        List<Task> tasks = new List<Task>();
        tasks.add(taskObj);
        Map<Id, Task> taskmap = new Map<Id, Task>();
        taskmap.put(taskObj.id, taskObj);
        TaskHelperTH.TaskFailBlacklist(tasks, taskMap, true, false);
        TaskHelperTH.updateAccountMobile(tasks);
        Test.stopTest();
        list<Account> lst=[SELECT Is_Blacklist__c FROM Account WHERE PersonContactId=:taskObj.WhoId limit 1];
        system.assertEquals(true,lst[0].Is_Blacklist__c);
    }    
    }
    
    static testmethod void testTaskFailBlacklistTrigger_Update()
    {
     Profile taskprofile = [select id from profile where Name='System Administrator' limit 1];
        User userTask = new User(LastName='TaskUser2',country='Thailand',firstName='BCIK',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest2@infosys.com',UserName='samTask2@usgboral.com.dev01',Market__c = 'TH');
        insert userTask;
        System.runas(userTask){
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
        TaskHelperTH.TaskFailBlacklist(tasks, taskMap, true, false);
        Test.stopTest();
        list<Account> lst=[SELECT Is_Blacklist__c FROM Account WHERE PersonContactId=:taskObj2.WhoId limit 1];
        system.assertEquals(true,lst[0].Is_Blacklist__c); 
     }   
    }
    
    
   
    
    static testmethod void testcreateSMSTaskAfterIBCall()
    {
     Profile taskprofile = [select id from profile where Name='System Administrator' limit 1];
        User userTask = new User(LastName='TaskUser3',country='Australia',firstName='BCIJ',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest3@infosys.com',UserName='samTask@usgboral.com.dev01',Market__c = 'TH');
        insert userTask;
        System.runas(userTask){
                    
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
       
        TaskHelperTH.updateCampaignMemberStatus(lstTask,mapTask,false,true);
        Test.stopTest();
        system.assertNotEquals(null, lstTask);
   } }
    
    
        
    static void createTestData()
    {
    Profile taskprofile = [select id from profile where Name='System Administrator' limit 1];
        User userTask = new User(LastName='TaskUser4',country='Thailand',firstName='BCIA',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest4@infosys.com',UserName='samTask4@usgboral.com.dev01',Market__c = 'TH');
        insert userTask;
        System.runas(userTask){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingTH.customSettingDetails();
        insert updatecustomsettings;
        
        personAccount = new Account(LastName='TEST ACC',
                                    FirstName = 'FirstName',
                                    Salutation = Unknown,
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                   //   ZipCode__c='09152',
                                      PersonMobilePhone = '1301111111',
                                      PersonOtherPhone = '1301111122',
                                      RecordTypeId=accPerson_RecordTypeId,Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '0987655413'
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
        
   } }
        
    
    static Task createTask(String activityStatus)
    {
   
      Task testSMSTask = new Task(Subject='SMS TEST',
                                    WhoId=testPersonAccount.PersonContactId,
                                    Activity_Status__c=activityStatus  
                                    );
       return testSMSTask;                             
   }
}