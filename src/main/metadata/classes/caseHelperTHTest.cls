@isTest
public with sharing class caseHelperTHTest{
final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public List<Id> tmpCaseIds = new List<Id>();
    public Static List<Account> insertAccount = new List<Account>();
    public Static List<Account> updateAccounts = new List<Account>();
    public Static List<Address__c> insertAddress = new List<Address__c>();
    public Static List<Case> insertCases = new List<case>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    public static Account personAcc;
    public static Account personAcc2;
    public static Account dealerAccount1;
    public static Account dealerAccount2;
    public static User user1= TestUtils.createAdminUser();
    public static Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id recordTypeAccCompanyAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public static void createtestData(){
        Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
    insert casetrigger;
        Group gr=new Group(Name='12345');
        insert gr;
        EmailTemplate et1 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_1st_Reminder_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');
		EmailTemplate et2 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_2nd_Reminder_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');        
		EmailTemplate et3 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_escalated_to_MBTH_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');                
        Insert new List<EmailTemplate>{et1,et2,et3};
        
        personAcc = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
    	insertAccount.add(personAcc);
        Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345',Dealer_Lead_Gate_Keeper__c=user1.Id);
        insertAccount.add(accObj1);
        Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345',Dealer_Lead_Gate_Keeper__c=user1.Id);
        insertAccount.add(accObj2);
        //personAcc2 = new Account(Primary_Address_Reference__c=objAddress.Id,RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
    //insert personAcc2;
    Account accObj3 = new Account(RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
        insertAccount.add(accObj3);
        insert insertAccount;
        address__c objAddress=new Address__C(Customer__c=insertAccount[0].id,Province__c='ACT',Address_Type__c = 'Home',ZipCode__c ='1234567',MD__c = 'TH');
        insertAddress.add(objAddress);
        address__c objAddress2=new Address__C(Customer__c=insertAccount[3].id,Province__c='ACT',Address_Type__c = 'Home',ZipCode__c ='1234567',MD__c = 'TH');
         insertAddress.add(objAddress2);
        insert objAddress;
        personAcc.Primary_Address_Reference__c=objAddress.Id;
        accObj3.Primary_Address_Reference__c=objAddress2.Id;
        updateAccounts.add(personAcc);
        updateAccounts.add(accObj3);
        update updateAccounts;
       
        
        Case c1 = new Case(Subject='testing',accountid=insertAccount[0].id,Recordtypeid=MBRecordtypeid,MD__c='TH');
         insertCases.add(c1);
        Case c2 = new Case(Subject='testing',accountid=insertAccount[3].id,Recordtypeid=MBRecordtypeid,MD__c='TH',Case_Dealer__c=insertAccount[1].Id);
         insertCases.add(c2);
        Case c3 = new Case(Subject='testing',accountid=insertAccount[0].id,Recordtypeid=MBRecordtypeid,MD__c='TH',Case_Dealer__c=insertAccount[1].Id);
         insertCases.add(c3);
        insert insertCases;
        insertCases.clear();
        Case c4 = new Case(Subject='testing',parentId=c1.id,Case_RepeatCause__c='2=Others',accountid=insertAccount[0].id,Recordtypeid=MBRecordtypeid,MD__c='TH');
        insertCases.add(c4);
        Case c5 = new Case(Subject='testing',parentId=c1.id,Case_RepeatCause__c='2=Others',accountid=insertAccount[0].id,Recordtypeid=caseMBComplaintRec_Id,MD__c='TH');
        insertCases.add(c5);
        insert insertCases;
        insertCases.clear();
        //CaseHelperTH.booleanCampaignUpdate=true;
        c3.Case_Dealer__c=accObj2.Id;
        c3.MBTH_1st_Reminder__c=true;
        c3.MBTH_2nd_Reminder__c=true;
        c3.MBTH_Escalated_to_MBTH__c=true;   
        c2.Case_Dealer__c=null;
        insertCases.add(c3);
        insertCases.add(c2);
        update insertCases;
    }
    private static testmethod void caseHelperTHTestMethod(){
        system.runAs(user1){
            createtestData();
        }
    }
}