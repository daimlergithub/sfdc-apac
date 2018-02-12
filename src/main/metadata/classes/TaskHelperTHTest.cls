@isTest
public class TaskHelperTHTest {
   public static User user1 = TestUtils.createAdminUser();
    public static ID personid=RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static id obcallid=RecordTypeAccessService.getRecordTypeId('Task','OB Call');
    public static id edmid=RecordTypeAccessService.getRecordTypeId('Task','eDM');
	public static List<account> acc=new List<Account>();
    public static List<contact> con=new List<contact>();
    public static List<Lead__C> ledlst=new List<Lead__C>();
    public static List<dm_Request__C> dmlst=new List<Dm_request__c>();
    public static List<Task> taskList=new List<Task>();
    public static List<sobject> listofre=new List<Sobject>();
    public static void createTestData(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingTH.customSettingDetails();
        insert updatecustomsettings;
        con.add(new contact(firstname='dhanamjaya',lastname='damaragunta'));
        insert con;
        acc.add(new Account(RecordTypeId=personid,firstname='dhanamjaya',email__c='dhdjfd@gmail.com',primary_phone__c='Mobile',lastname='damaragunta',mobile__c='989898989'));
        acc.add(new Account(RecordTypeId=personid,firstname='dhanamjaya',email__c='dhdjfd@gmail.com',primary_phone__c='Home phone',lastname='damaragunta',individual_Home_Phone__c='98988989'));
		acc.add(new Account(RecordTypeId=personid,firstname='dhanamjaya',email__c='dhdjfd@gmail.com',primary_phone__c='Work Phone',lastname='damaragunta',Work_Phone__c='98988989'));
        insert acc;
        for(Account ac:acc){
        listofre.add(new Lead__C(Contact__c=ac.id));
        listofre.add(new DM_request__c(Customer_Name__c=ac.id));
        taskList.add(new Task(whoid=ac.PersonContactId,RecordTypeId=obcallid,Activity_Status__c='busy'));
        taskList.add(new Task(whoid=ac.PersonContactId,RecordTypeId=edmid,Activity_Status__c='busy'));
        taskList.add(new Task(whoid=con[0].id,RecordTypeId=edmid,Activity_Status__c='busy'));
        }insert listofre;
        for(sobject s:listofre){
            taskList.add(new Task(whatid=s.id,RecordTypeId=obcallid,Activity_Status__c='busy'));
            taskList.add(new Task(whatid=s.id,RecordTypeId=edmid,Activity_Status__c='busy')); 
            taskList.add(new Task(whatid=s.id,RecordTypeId=obcallid,Activity_Status__c='busy'));
            taskList.add(new Task(whatid=s.id,RecordTypeId=edmid,Activity_Status__c='busy'));          
        }
        insert tasklist;
    }
    @isTest
    public static void updateAccountMobiletest(){
        system.runAs(user1){
            Test.startTest();
            createTestData();
            for(Task t:taskList)
                t.activity_Status__C='rejected';     
            update taskList;
            Test.stopTest();
        }     
    }
}