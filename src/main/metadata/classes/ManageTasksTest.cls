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
static testmethod void testgetoldstatuses(){
    Account accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'testaccount'; 
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    accobj.ZipCode__c= '1002347';    
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
    Task taskobj1 = new Task();
    taskobj1.RecordTypeId = eDMTaskRecordTypeId ;
    taskobj1.Status='open';
    taskobj1.Activity_Status__c='Successful';
    taskobj1.Generate_QC__c = true;
    taskobj1.whatId = camobj.Id;
    tasklist = new List<task>();
    tasklist.add(taskobj);
    tasklist.add(taskobj1);
    
        
        ApexPages.StandardController objSc = new ApexPages.StandardController(taskobj);
        ManageTasks KRcontroller= new ManageTasks(objSc);
        ManageTasks.TaskInfo wrapper = new ManageTasks.TaskInfo(taskobj);
       
         Campaign a = new Campaign(Name = 'TestCampaign');
        insert a;
        
         
        
        /*for(ManageTasks.TaskInfo accRec : ti){
           accRec.isSelected = true;
       ti1.add(accRec);
        }*/


        PageReference pRef = Page.ManageTasks;
        pRef.getParameters().put('id', a.Id);
         KRcontroller.dropDown();
        KRcontroller.getoldstatuses();
        
         KRcontroller.dropDown();
        KRcontroller.getChangingstatus();
         KRcontroller.getUsers();
        KRcontroller.Changestatus();
         ApexPages.StandardController objSc1 = new ApexPages.StandardController(taskobj);
        ManageTasks KRcontroller1= new ManageTasks(objSc1);
        
        KRcontroller1.Changestatus();
        KRcontroller1.userinput='es';
        KRcontroller1.Usersearch();
        KRcontroller1.getUsers();
        KRcontroller.getstatusval();
      
}
static testmethod void testdropDown(){
/*objTask=new Task();
ApexPages.StandardController objSc = new ApexPages.StandardController(objTask);
        ManageTasks KRcontroller= new ManageTasks(objSc);
        Campaign a = new Campaign(Name = 'TestAccount');
        insert a;
        
        PageReference pRef = Page.ManageTasks;
        pRef.getParameters().put('id', a.Id);
    
        KRcontroller.dropDown();*/

}


}