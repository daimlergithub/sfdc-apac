@isTest
public with sharing class TriggerCaseHandlerMYTest{

public static User user1;
public static User user2;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testTriggerCaseHandlerMY1() {
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
  
    System.runAs (user1) {
        PermissionSet ps = new PermissionSet();
      ps.Name = 'Test';
      ps.Label = 'Test';
      insert ps;
	  
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
    cs.DEFAULT_CALLOUT_TIME__c='1000';
    cs.MAX_CALLOUT_TIME__c='5000';
    cs.Name='CalloutValues';
    insert cs;
    
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
    sysSet.Debug__c =true;
    sysSet.Error__c = true;
    sysSet.Info__c= true;
    sysSet.Warning__c = true;
    sysSet.Log_Purge__c =10;
    sysSet.Name=p1.Name;
    DMLManagerService.insertAsSystem(sysSet);
        
        user2 = UtilTestData.createPersornaUser(ps, p1);
    }
        System.runAs (user2) {
    Trigger__c CaseTriggerMY= new Trigger__c(Name='CaseTriggerMY',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='triggercaseHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
    insert CaseTriggerMY;
    test.starttest();
    
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Mobile__c');
        AccountFields.add('MD__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].MD__c='MY';   
        //AccountFieldsList[0].market__C='MY'; 
        insert AccountFieldsList;
        system.assertEquals(AccountFieldsList[0].id,[select id from account where id=:AccountFieldsList[0].id limit 1].id);
        
        List<String> CaseFields=new List<String>();
        CaseFields.add('Status');
        CaseFields.add('Case_RepeatCause__c');
        CaseFields.add('accountid');
        CaseFields.add('Recordtypeid');   
        CaseFields.add('MD__c');
        CaseFields.add('priority');
        List<Case> CaseFieldsList;
        CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
        CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
        CaseFieldsList[0].accountid=AccountFieldsList[0].id;
        CaseFieldsList[0].MD__c='MY';
        CaseFieldsList[0].status='Open';
        CaseFieldsList[0].Case_RepeatCause__c='';
        CaseFieldsList[0].priority='A';
        //CaseFieldsList[0].market__C='MY';
        CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        CaseFieldsList[1].accountid=AccountFieldsList[0].id;
        CaseFieldsList[1].MD__c='MY';
        CaseFieldsList[1].status='Open';
        CaseFieldsList[1].Case_RepeatCause__c='';
        CaseFieldsList[1].priority='Green <= 2';
        //CaseFieldsList[0].market__C='MY';
        insert CaseFieldsList;
        system.assertEquals(CaseFieldsList[0].id,[select id from Case where id=:CaseFieldsList[0].id limit 1].id);
        update CaseFieldsList;
        delete CaseFieldsList;
        test.stoptest();
          
        }     
        }
}