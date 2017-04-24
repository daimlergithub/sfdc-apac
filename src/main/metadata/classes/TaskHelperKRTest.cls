@istest
public class TaskHelperKRTest {
  public static Account accobj;
  public static Contact Contobj;
  public static Lead__c leadobj;
  public static Task taskobj;
   public static Task taskobj1;
  public static List<Task> tasklist;
  public static Campaign camobj;
  public static DM_Request__c dmr;
  public static DM_Material__c Material;
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
  public static Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
  public static Id SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
  public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
  public static Id eDMTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
      
  static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'testaccount'; 
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    accobj.ZipCode__c= '1002347';    
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = accobj.Id;
    insert contobj;
    system.debug('$$$$$$$$$$$$'+contobj);
    system.debug('$$$$$$$$$$$$'+contobj.id);
    
    camobj = new Campaign();
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
    
    leadobj = new Lead__c();
    leadobj.RecordTypeId = salesleadRecordTypeId;
    //leadobj.Contact__c = accobj.Id;
    leadobj.CAC_Lead_Status__c = 'Qualified';
    leadobj.Lead_Type__c = 'New Car';
    insert leadobj;
    system.debug('$$$$$$$$$$$$'+leadobj);
    system.debug('$$$$$$$$$$$$'+leadobj.id);
    
    taskobj = new Task();
    taskobj.RecordTypeId = OBTaskRecordTypeId ;
    taskobj.Status='open';
    taskobj.Activity_Status__c='Successful';
    taskobj.Generate_QC__c = true;
    taskobj.whatId = accobj.Id;
    taskobj1 = new Task();
    taskobj1.RecordTypeId = eDMTaskRecordTypeId ;
    taskobj1.Status='open';
    taskobj1.Activity_Status__c='Successful';
    taskobj1.Generate_QC__c = true;
    taskobj1.whatId = leadobj.Id;
    tasklist = new List<Task>();
    tasklist.add(taskobj);
    tasklist.add(taskobj1);
    insert tasklist;
      
    dmr = new DM_Request__c();
    Trigger__c TriggerDMR=new Trigger__c(Name='DMRequest',Trigger_Name__c='TriggerDMRequest',
                                         Trigger_Handler__c='TriggerDMRequestTriggerHandlerJP',update__c=True,
                                         insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,
                                         Market__c='JP');
    insert TriggerDMR;
    
  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
  
    Material = new DM_Material__c();
    Material.Name='testname';
    insert Material;
        
    dmr = new  DM_Request__c();
    dmr.Status__c='Open'; 
    //dmr.Customer_Name__c=accobj.id;
    //dmr.Sending_Address__c='Home';
    dmr.TitleOfHonor__c = 'To Person';
    dmr.Status2__c='open';
    dmr.Expected_DM_Material1__c=Material.id;
    dmr.Expected_DM_Material2__c=Material.id;
    dmr.Expected_DM_Material3__c=Material.id;
    dmr.Status1__c='Success';
    dmr.Status3__c='Success';
    dmr.Sent_Date__c=system.today().addDays(-10);
    insert dmr;
    system.debug('$$$$$$$$$$$$'+dmr);
    system.debug('$$$$$$$$$$$$'+dmr.id);
  }
  public static testmethod void updateAccountMobileTest() {
    createTestData();
    test.starttest();
      TaskHelperKR.updateAccountMobile(tasklist);
    test.stoptest();  
    system.assertEquals(taskobj.Activity_Status__c,'Successful');
  }
  public static testmethod void CustomerConsenmentTest() {
    createTestData();
    test.starttest();
      TaskHelperKR.CustomerConsenment(tasklist);
    test.stoptest();     
    system.assertEquals(taskobj.Activity_Status__c,'Successful');
  }
}