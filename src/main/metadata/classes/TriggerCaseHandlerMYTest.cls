/**
* Test class for triggercaseHandlerMY
* Author:Pratyasha Mishra
* Created Date : 9th Oct 2017
*/

//PM2017

@isTest
public class TriggerCaseHandlerMYTest {
    
    //PM2017
    /*
      Name:Pratyasha Mishra
      Description:Added to setup test data for MY
      Modified Date: 2017-09-13
  */
    public static User user1;
    public static User user2;
    public static List<Case> CaseFieldsList;
    static void setupTestData(){ 
      PermissionSet ps = new PermissionSet();
    ps.Name = 'Test';
    ps.Label = 'Test';
    insert ps;
  system.debug('permission set'+ps);
     Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user2 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user2 );
    system.runas(user1){
        Trigger__c CaseTriggerMY= new Trigger__c(Name='CaseTriggerMY',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='triggercaseHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
    insert CaseTriggerMY;
   
    
    SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        //.debug('p--'+TriggerAccountTH);
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh); 
    CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];
    
    SetupEntityAccess sea = new SetupEntityAccess();
    sea.ParentId = ps.Id;
    sea.SetupEntityId = cps.id;
    insert sea;
       PermissionSetAssignment psa = new PermissionSetAssignment();
    psa.AssigneeId = user2.id;
    psa.PermissionSetId = ps.Id;
    insert psa;
         
        
        system.debug('permission set'+psa);
       System.runAs (user1) {  
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Mobile__c');
        AccountFields.add('MD__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].MD__c='MY';   
        AccountFieldsList[0].market__C='MY'; 
        insert AccountFieldsList;
        List<String> CaseFields=new List<String>();
        CaseFields.add('Status');
        CaseFields.add('Case_RepeatCause__c');
        CaseFields.add('accountid');
        CaseFields.add('Recordtypeid');   
        CaseFields.add('MD__c');
        CaseFields.add('priority');
        
        CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
        CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
        CaseFieldsList[0].accountid=AccountFieldsList[0].id;
        CaseFieldsList[0].MD__c='MY';
        CaseFieldsList[0].status='Open';
        CaseFieldsList[0].Case_RepeatCause__c='';
        CaseFieldsList[0].priority='A';
        CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        CaseFieldsList[1].accountid=AccountFieldsList[0].id;
        CaseFieldsList[1].MD__c='MY';
        CaseFieldsList[1].status='Open';
        CaseFieldsList[1].Case_RepeatCause__c='';
        CaseFieldsList[1].priority='Green <= 2';
      }  
    }
    }
    static testMethod void testTriggerCaseHandlerMY1() {
        try{
            setupTestData();
           system.runas(user2){
                test.starttest();
               insert CaseFieldsList;
                triggercaseHandlerMY td=new triggercaseHandlerMY();
                update CaseFieldsList;
                delete CaseFieldsList;
               // td.handleTrigger(true,false,true,false,false);
                test.stoptest();
               // insert CaseFieldsList;
           }
          }
        catch(Exception e){}
    }

}