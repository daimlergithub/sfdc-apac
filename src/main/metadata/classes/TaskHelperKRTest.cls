@isTest
public class TaskHelperKRTest {
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
    
    
    public static void createTestData(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        personAccount = new Account(LastName='TEST ACC',
                                    FirstName = 'FirstName',
                                    Salutation = Unknown,
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='1004468',
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
        
    }
    
    public static void testData1(){
        String OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        String SSITaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        createTestData();
          // Person Contact                
          Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
    	Contact conComplaint = new Contact(AccountId = dealer.Id, Salutation='Attorney',FirstName='testFirstname',LastName = 'testLastname', Phone = '0123456789', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
        insert conComplaint;
        Task task = new Task(Subject = acme, RecordTypeId = IBTaskRecordTypeId, WhoId = conComplaint.Id);
        insert task; 
        
        List<Task> lsttask = new List<Task>();
        lsttask.add(task);
        
        
        Account acc = new Account(LastName = acme,FirstName = 'Firstname1',Salutation = Unknown, Area_Code__c = '0101',Phone = '0123456789', RecordTypeId = accPerson_RecordTypeId,Email__c='test@mbau1.com',Email2__c = 'testemail2@test1.com',Home_Phone_2__c = '0987654131');
        insert acc;
        task = new Task(Subject = acme, RecordTypeId = OBTaskRecordTypeId, WhatId = acc.Id);
        insert task;
        
        List<Task> lsttask1 = new List<Task>();
        lsttask1.add(task);
        
        TaskHelperKR.updateAccountMobile(lsttask);
        TaskHelperKR.CustomerConsenment(lsttask1);
        
    }

}