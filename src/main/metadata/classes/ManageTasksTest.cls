@istest
public class ManageTasksTest{
public static Task objTask;
public static Task testTask;
public static string oldstatus;
public static List<task> tasklist;
   public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();

  public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
  public static Id eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
  public static User user1;  
static testmethod void testgetoldstatuses(){
     Profile p1 = [select id,name from profile WHERE Name='System Administrator'];     
     user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='ko', 
                          LocaleSidKey='ko', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
    system.runAs(user1){
    Account accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'testaccount'; 
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    accobj.ZipCode__c= '100234';    
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    Contact contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = accobj.Id;
    insert contobj;
    system.debug('$$$$$$$$$$$$'+contobj);
    system.debug('$$$$$$$$$$$$'+contobj.id);
    
    Campaign camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    
    
    Task taskobj = new Task();
    taskobj.RecordTypeId = OBTaskRecordTypeId ;
    taskobj.Status='open';
    taskobj.Activity_Status__c='Successful';
    taskobj.Generate_QC__c = true;
    taskobj.whatId = camobj.Id;
    taskobj.MD__c='KR';
    Task taskobj1 = new Task();
    taskobj1.RecordTypeId = eDMTaskRecordTypeId ;
    taskobj1.Status='open';
    taskobj1.Activity_Status__c='Successful';
    taskobj1.Generate_QC__c = true;
    taskobj1.whatId = camobj.Id;
    taskobj1.MD__c='KR';
    tasklist = new List<task>();
    tasklist.add(taskobj);
    tasklist.add(taskobj1);
    insert tasklist;
        test.startTest();
        ApexPages.StandardController objSc = new ApexPages.StandardController(taskobj);
        ApexPages.currentPage().getParameters().put('campid',camobj.id);  
        ManageTasks KRcontroller= new ManageTasks(objSc);
        ManageTasks.TaskInfo wrapper = new ManageTasks.TaskInfo(taskobj);
       
         Campaign a = new Campaign(Name = 'TestCampaign');
        insert a;
        
         
        
        /*for(ManageTasks.TaskInfo accRec : ti){
           accRec.isSelected = true;
       ti1.add(accRec);
        }*/

        system.assertEquals(false,KRcontroller.showuser);       
        PageReference pRef = Page.ManageTasks;
        pRef.getParameters().put('id', a.Id);
         KRcontroller.oldstatus='시작됨';
        KRcontroller.newstatus='전체';
         KRcontroller.dropDown();
        KRcontroller.getoldstatuses();
        KRcontroller.oldstatus='전체';
        KRcontroller.newstatus='시작됨';
        
         KRcontroller.dropDown();
        KRcontroller.getChangingstatus();
         KRcontroller.getUsers();
        KRcontroller.Changestatus();
        // system.assertNotEquals(null,KRcontroller.UserList);
         ApexPages.StandardController objSc1 = new ApexPages.StandardController(taskobj);
        ManageTasks KRcontroller1= new ManageTasks(objSc1);
        KRcontroller1.oldstatus='종결됨';
        KRcontroller1.newstatus='시작됨';
        KRcontroller1.dropDown();
        KRcontroller1.getChangingstatus();
        KRcontroller1.Changestatus();
        KRcontroller1.userinput='es';
        KRcontroller1.Usersearch();
        KRcontroller1.getUsers();
        system.assertEquals('Closed',KRcontroller1.oldstatus);        
        KRcontroller.getstatusval();
        ManageTasks.MonkCotact('abcd@def.com');
       KRcontroller.notifyTaskOwner(tasklist);
        ManageTasks KRcontroller2= new ManageTasks(objSc1);
        KRcontroller2.oldstatus='취소됨';
        KRcontroller2.newstatus='취소됨';
         KRcontroller2.dropDown();
        KRcontroller2.getChangingstatus();
        
        KRcontroller2.Changestatus();
        system.assertEquals('Cancelled',KRcontroller2.oldstatus);   
        KRcontroller2.oldstatus='Open';
        KRcontroller2.newstatus='전체';
        KRcontroller2.Changestatus();
        KRcontroller2.getChangingstatus();
        KRcontroller2.newstatus='Closed';
        KRcontroller2.oldstatus='종결됨';
        KRcontroller2.Changestatus();
        
        test.stopTest();
    }
}



}