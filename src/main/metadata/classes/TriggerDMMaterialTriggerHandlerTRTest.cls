@isTest
public with sharing class TriggerDMMaterialTriggerHandlerTRTest{

public static User user1;
public static User user2;
//public static User user3;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');                                                                                        
public static Persona__c persona_Obj; 

static testMethod void testTriggerDMRequestTriggerHandlerTR1() {
    PermissionSet ps = new PermissionSet();
    ps.Name = 'Test';
    ps.Label = 'Test';
    insert ps;
    
    CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRGeneric ];

  SetupEntityAccess sea = new SetupEntityAccess();
  sea.ParentId = ps.Id;
  sea.SetupEntityId = cps.id;
  insert sea;
  
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
  //DMLManagerService.insertAsSystem(user1 );
   
  System.runAs (user1) {  
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

    market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'Turkey');
    Insert market_Obj; 
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
    Insert persona_Obj; 
   user2 = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', 
   Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, 
   EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null1', IsActive = true, 
   TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', 
   ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111',Market__c='TR');
   }
    
    System.runAs (user2) {
    Trigger__c TriggerDMRequestTR= new Trigger__c(Name='TriggerDMMaterialTR',Trigger_Name__c='TriggerDMMaterial',Trigger_Handler__c='TriggerDMMaterialTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
    insert TriggerDMRequestTR;
    test.starttest();
    DM_Material__c dmMtrlSC = new DM_Material__c();
	dmMtrlSC.Name = 'Test DM Material SC Created';
	dmMtrlSC.Market__c='TR';
	dmMtrlSC.Type__c = 'Kit';
	insert dmMtrlSC;
    test.stoptest();
          
        }                     
    }            
    
               
}
