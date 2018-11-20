@isTest
public with sharing class caseHelperTHTest{
final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
     public static id fsinq =RecordTypeAccessService.getRecordTypeId('case','FS Inquiry');//FS Complaint
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
    public static Id recordTypeFSInquiry_Id=Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS Inquiry').getRecordTypeId();
    public static Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public static User user3 = TestUtils.IntegrationAPIUser();
    public static void createtestData(){
        Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
    insert casetrigger;
        List<Group> gr=new List<group>();
        gr.add(new Group(Name='12345'));
         gr.add(new Group(Name='FS_ESCALATE_TO_MBTH_Queue'));
        
        insert gr;
        
        //FS_ESCALATE_TO_MBTH_Queue
        groupmember gm=new groupmember(groupid=gr[1].id,userorgroupid=user1.id);
        insert gm;
        EmailTemplate et1 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_1st_Reminder_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');
    EmailTemplate et2 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_2nd_Reminder_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');        
    EmailTemplate et3 = new EmailTemplate(isActive = true,Name = 'testTemplate',DeveloperName = 'Case_escalated_to_MBTH_Notification',TemplateType = 'text',FolderId = UserInfo.getUserId(),Body = '');                
        //Insert new List<EmailTemplate>{et1,et2,et3};
        
        personAcc = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
      insertAccount.add(personAcc);
        Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345',Dealer_Lead_Gate_Keeper__c=user1.Id,Dealer_Rollout_Status__c='Done');
        insertAccount.add(accObj1);
        Account accObj2 = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+66-12-123-789',Dealer_ND_Code__c='12345',Dealer_Lead_Gate_Keeper__c=user1.Id,Dealer_Rollout_Status__c='Done');
        insertAccount.add(accObj2);
        //personAcc2 = new Account(Primary_Address_Reference__c=objAddress.Id,RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
    //insert personAcc2;
    Account accObj3 = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
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
       
        
        Case c1 = new Case(Subject='testing1',accountid=insertAccount[0].id,Recordtypeid=caseINquiryId,MD__c='TH');
         insertCases.add(c1);
        Case c2 = new Case(Subject='testing2',COS_Ticket_Number__c='123',accountid=insertAccount[3].id,Recordtypeid=MBRecordtypeid,MD__c='TH',Case_Dealer__c=insertAccount[1].Id);
         insertCases.add(c2);
        Case c3 = new Case(Subject='testing3',accountid=insertAccount[0].id,Recordtypeid=fsinq,MD__c='TH',Case_Dealer__c=insertAccount[1].Id);
         insertCases.add(c3);
       
       
        insert insertCases;
        
        Case c4 = new Case(Subject='testing4',status='Closed',parentId=insertCases[0].id,Case_RepeatCause__c='2=Others',accountid=insertAccount[0].id,Recordtypeid=MBRecordtypeid,MD__c='TH');
        
        insert c4;
        //insertCases.add(c4);
        Case c5 = new Case(Subject='testing5',parentId=insertCases[0].id,Case_RepeatCause__c='2=Others',accountid=insertAccount[0].id,Recordtypeid=caseMBComplaintRec_Id,MD__c='TH');
        insertCases.add(c5);
        insertCases.clear();
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
    
    //To cover integration handler section in triggerCasehandlertr
    static testMethod void testintegrationHandlerTH() {
		Profile p1 = [select id, name from profile where Name='IntegrationAPI' limit 1];
    	String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Profile p2 = [select id, name from profile where Name='System Administrator' limit 1];
    	user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='TH',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert user1;
		
        List < Group > gr = new List < group > {
            new Group(Name = 'TH12345',developername = 'testndgroup1'),
            new Group(Name = 'TH12346',developername = 'testndgroup2')
        };
        insert gr;
		system.runAs(user3) {
            TriggerUtil.userCreate = false;
            Trigger__c CaseTriggerMY= new Trigger__c(Name='CaseTriggerTH',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='CaseTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
        	insert CaseTriggerMY;
            //insert casewith primary dealer as dealer1
            Account dealer1 = new Account(Dealer_Rollout_Status__c = 'Done', Dealer_DMS_CRM_Code__c = 'DealerCode', Market__c = 'TH', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
        	insert dealer1;		
			Account dealer2 = new Account(Dealer_Rollout_Status__c = 'Done', Dealer_DMS_CRM_Code__c = 'DealerCode', Market__c = 'TH', Individual_Home_Phone__c = '+66-9885857858', RecordTypeId = dealerType, Name = 'test dealer2', Dealer_GC_Code__c = '123457', Dealer_nd_Code__C = '12346');
        	insert dealer2;
            Account dealer3 = new Account(Dealer_Rollout_Status__c = 'Done', Dealer_DMS_CRM_Code__c = 'DealerCode', Market__c = 'TH', Individual_Home_Phone__c = '+66-9885857859', RecordTypeId = dealerType, Name = 'test dealer3', Dealer_GC_Code__c = '123457', Dealer_nd_Code__C = Null);
        	insert dealer3;
            Account accObj3 = new Account(Foundation_Date__c=system.today(),RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
			insert accObj3;
            List<String> CaseFields=new List<String>();
			CaseFields.add('Status');
			CaseFields.add('Recordtypeid');   
			CaseFields.add('Market__c');
			CaseFields.add('Case_Dealer__c');
			List<Case> CaseFieldsList;
			CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
			
			CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('S24h - MMC').getRecordTypeId();
			CaseFieldsList[0].Market__c='TH';
			CaseFieldsList[0].status='Open';
			CaseFieldsList[0].Case_Dealer__c=dealer1.Id;
            CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('S24h - MMC').getRecordTypeId();
			CaseFieldsList[1].Market__c='TH';
			CaseFieldsList[1].status='Open';
			CaseFieldsList[1].Case_Dealer__c=Null;
            CaseFieldsList[1].AccountId=accObj3.Id;
            CaseFieldsList[0].AccountId=accObj3.Id;
			insert CaseFieldsList;
			//update primary case dealer to dealer2
			CaseFieldsList[0].Case_Dealer__c=dealer2.Id;
            CaseFieldsList[1].Case_Dealer__c=dealer2.Id;
            update CaseFieldsList;
            CaseFieldsList[0].Case_Dealer__c=dealer3.Id;
            update CaseFieldsList;
            CaseFieldsList[0].ownerid=user1.Id;
            CaseFieldsList[1].ownerid=user1.Id;
			update CaseFieldsList;
        }
	}
}