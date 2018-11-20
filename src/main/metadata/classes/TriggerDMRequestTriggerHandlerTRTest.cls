@isTest
public with sharing class TriggerDMRequestTriggerHandlerTRTest{

public static User user1;
public static User user2;
//public static User user3;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');                                                                                        
public static Persona__c persona_Obj; 

static testMethod void testTriggerDMRequestTriggerHandlerMY1() {
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
    Trigger__c TriggerDMRequestTR= new Trigger__c(Name='TriggerDMRequestTR',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
    insert TriggerDMRequestTR;
    test.starttest();
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Firstname');
        AccountFields.add('Mobile__c');
        AccountFields.add('Market__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Firstname='Lastname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].Market__c='TR';   
        insert AccountFieldsList;
        List<String> AddressFields=new List<String>();
        AddressFields.add('Address_Line_1__c');
        AddressFields.add('Address_Line_2__c');
        AddressFields.add('Address_Line_3__c');
        AddressFields.add('Address_Type__c');
        AddressFields.add('City__c');
        AddressFields.add('Province__c');
        AddressFields.add('Market__c');
        List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',1);
        AddressFieldsList[0].Address_Line_1__c='Lastname1';
        AddressFieldsList[0].Address_Line_2__c='+6003123654789';
        AddressFieldsList[0].Address_Line_3__c='+60825634789541';
        AddressFieldsList[0].Address_Type__c='Home';
        AddressFieldsList[0].Province__c='+609856321478';
        AddressFieldsList[0].City__c='+609856321478';
        AddressFieldsList[0].Market__c='TR';
        AddressFieldsList[0].ZipCode__c='12345';
        AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
		AddressFieldsList[0].country__c='Turkey';
        insert AddressFieldsList;
        List<String> DMReqFields=new List<String>();
        DMReqFields.add('Customer_Name__c');
        DMReqFields.add('Sending_Address__c');
        DMReqFields.add('Channel__c');        
        List<DM_Request__c> DMReqFieldsList=DataFactoryServices.createRecords('DM_Request__c',DMReqFields,'',1);
        DMReqFieldsList[0].Customer_Name__c=AccountFieldsList[0].id;
        DMReqFieldsList[0].Sending_Address__c='Home';
        DMReqFieldsList[0].Channel__c='Letter';
        insert DMReqFieldsList;
        DMReqFieldsList[0].Delivery_Type__c='1';
        update DMReqFieldsList;       
        test.stoptest();
          
        }                     
    }            
    
static testMethod void testTriggerDMRequestTriggerHandlerTR2() {
    PermissionSet ps = new PermissionSet();
    ps.Name = 'Test';
    ps.Label = 'Test';
    insert ps;
    
    CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRGeneric ];
    CustomPermission cps1 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRRetail ];

   SetupEntityAccess sea1 = new SetupEntityAccess();
  sea1.ParentId = ps.Id;
  sea1.SetupEntityId = cps1.id;
  insert sea1;                                                                                                 

  SetupEntityAccess sea = new SetupEntityAccess();
  sea.ParentId = ps.Id;
  sea.SetupEntityId = cps.id;
  insert sea;
  group grp = new group(name = 'TR123456', developername = 'TR123456');
    insert grp;
  
  Account dealer1;                                                                 
  
    Profile p1 = [select id, name from profile where Name='IntegrationAPI' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
  //DMLManagerService.insertAsSystem(user1 );
  TriggerUtil.userCreate=false;  
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
 dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='123456');
        insert dealer1;
    market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'Turkey');
    Insert market_Obj; 
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
    Insert persona_Obj; 
     user2 = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Email = 'Email22@test.com',  Alias = 'Alias474', CommunityNickname = 'null1', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL',EmailEncodingKey = 'UTF-8', ProfileId = p1.id, LanguageLocaleKey = 'en_US', Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
    insert user2;
      PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user2.id;
        psa.PermissionSetId = ps.Id;
        insert psa;    
    }
     TriggerUtil.userCreate=false; 
    System.runAs (user2) {
       
    Trigger__c TriggerDMRequestMY= new Trigger__c(Name='TriggerDMRequestTR',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
    insert TriggerDMRequestMY;
     TriggerUtil.userCreate=false;     
    test.starttest();
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Mobile__c');
        AccountFields.add('Market__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].Market__c='TR';   
        insert AccountFieldsList;
        List<String> AddressFields=new List<String>();
        AddressFields.add('Address_Line_1__c');
        AddressFields.add('Address_Line_2__c');
        AddressFields.add('Address_Line_3__c');
        AddressFields.add('Address_Type__c');
        AddressFields.add('City__c');
        AddressFields.add('Province__c');
        AddressFields.add('Market__c');
        List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',2);
          AddressFieldsList[0].Address_Line_1__c='Lastname1';
        AddressFieldsList[0].Address_Line_2__c='+6003123654789';
        AddressFieldsList[0].Address_Line_3__c='+60825634789541';
        AddressFieldsList[0].Address_Type__c='Home';
        AddressFieldsList[0].Province__c='+609856321478';
        AddressFieldsList[0].City__c='+609856321478';
        AddressFieldsList[0].Market__c='TR';
        AddressFieldsList[0].ZipCode__c='12345';
        AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
		AddressFieldsList[0].country__c='Turkey';
       // insert AddressFieldsList;
        AddressFieldsList[1].Address_Line_1__c='Lastname1';
        AddressFieldsList[1].Address_Line_2__c='+6003123654789';
        AddressFieldsList[1].Address_Line_3__c='+60825634789541';
        AddressFieldsList[1].Address_Type__c='Business';
        AddressFieldsList[1].Province__c='+609856321478';
        AddressFieldsList[1].City__c='+609856321478';
        AddressFieldsList[1].Market__c='TR';
        AddressFieldsList[1].ZipCode__c='12345';
        AddressFieldsList[1].Customer__c=AccountFieldsList[0].id;  
		AddressFieldsList[1].country__c='Turkey';
        insert AddressFieldsList;
        List<String> DMReqFields=new List<String>();
        DMReqFields.add('Customer_Name__c');
        DMReqFields.add('Sending_Address__c');
        DMReqFields.add('Channel__c');
        DMReqFields.add('Market__c');
         DM_Material__c dmtrl1 = new DM_Material__c(name = 'testmaterial1');
            insert dmtrl1;
             DM_Material__c dmtrl2 = new DM_Material__c(name = 'testmaterial2');
            insert dmtrl2;
             DM_Material__c dmtrl3 = new DM_Material__c(name = 'testmaterial3');
            insert dmtrl3;
        List<DM_Request__c> DMReqFieldsList=DataFactoryServices.createRecords('DM_Request__c',DMReqFields,'',1);
        DMReqFieldsList[0].Customer_Name__c=AccountFieldsList[0].id;
        DMReqFieldsList[0].Sending_Address__c='Home';
        DMReqFieldsList[0].Channel__c='Letter';
        DMReqFieldsList[0].Market__c='TR';
        insert DMReqFieldsList;
        DMReqFieldsList[0].Delivery_Type__c='1';
        update DMReqFieldsList; 
        DMReqFieldsList[0].Sending_Address__c='Business';
        DMReqFieldslIst[0].Assigned_Dealer__c=dealer1.id;
        DMReqFieldslIst[0].Expected_DM_Material1__c=dmtrl1.id;
        DMReqFieldslIst[0].Expected_DM_Material2__c=dmtrl2.id;
        DMReqFieldslIst[0].Expected_DM_Material3__c=dmtrl3.id;
        DMReqFieldslIst[0].Actual_DM_Material1__c=dmtrl1.id;
        DMReqFieldslIst[0].Actual_DM_Material2__c=dmtrl2.id;
        DMReqFieldslIst[0].Actual_DM_Material3__c=dmtrl3.id;
        update DMReqFieldsList;          
        test.stoptest();
          
        }                     
    }    
    
    
    
        
static testMethod void testTriggerDMRequestTriggerHandlerTY3() {
    PermissionSet ps = new PermissionSet();
    ps.Name = 'Test';
    ps.Label = 'Test';
    insert ps;
    
    CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRGeneric ];
    CustomPermission cps1 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRRetail ];

  SetupEntityAccess sea = new SetupEntityAccess();
  sea.ParentId = ps.Id;
  sea.SetupEntityId = cps.id;
  insert sea;
   SetupEntityAccess sea1 = new SetupEntityAccess();
  sea1.ParentId = ps.Id;
  sea1.SetupEntityId = cps1.id;
  insert sea1;
    group grp = new group(name = 'TR123456', developername = 'TR1234562');
    insert grp;
  
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    userRole r=[select id from userRole where Name='MBMY Management'];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', userroleid=r.id,
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
  //DMLManagerService.insertAsSystem(user1 );
     Account dealer1,dealer;
  TriggerUtil.userCreate=false;  
  System.runAs (user1) {  
     dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='123456');
        insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Market__c='TR', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
      dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Market__c='TR',Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;

        Account dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Market__c='TR', Individual_Home_Phone__c='02202123626', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealerAccount;
        Contact c1=new Contact(FirstName = 'Test',Lastname = 'Contact',AccountId=dealerAccount.Id,Market__c='TR');
        insert c1;
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
    profile d=[select id from profile where name='Malaysia Dealer User'];
    market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'Turkey');
    Insert market_Obj; 
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230',
    PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, 
    Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
    Insert persona_Obj; 
    user2 = new User(contactid=dealerContact.id,Username = 'TestUser70921083316@codsecoverage.com', LastName = 'LastName527',
     Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, 
     EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null1', IsActive = true,
      TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, 
      EmailEncodingKey = 'UTF-8', ProfileId = p1.id, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, 
             UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', 
             DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false,
              Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false,
               ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111',Market__c='TR');
    user2.profileid=d.id;
    insert user2;
     PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user2.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
    }
     TriggerUtil.userCreate=false; 
    System.runAs (user2) {
       
    Trigger__c TriggerDMRequestMY= new Trigger__c(Name='TriggerDMRequestTR',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
    insert TriggerDMRequestMY;
     TriggerUtil.userCreate=false;     
    test.starttest();
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Firstname');
        AccountFields.add('Mobile__c');
        AccountFields.add('Market__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Firstname='Firstname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].Market__c='TR';   
        insert AccountFieldsList;
        List<String> AddressFields=new List<String>();
        AddressFields.add('Address_Line_1__c');
        AddressFields.add('Address_Line_2__c');
        AddressFields.add('Address_Line_3__c');
        AddressFields.add('Address_Type__c');
        AddressFields.add('City__c');
        AddressFields.add('Province__c');
        AddressFields.add('Market__c');
        List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',2);
                                                           
        AddressFieldsList[0].Address_Line_1__c='Lastname1';
        AddressFieldsList[0].Address_Line_2__c='+6003123654789';
        AddressFieldsList[0].Address_Line_3__c='+60825634789541';
        AddressFieldsList[0].Address_Type__c='Home';
        AddressFieldsList[0].Province__c='+609856321478';
        AddressFieldsList[0].City__c='+609856321478';
        AddressFieldsList[0].Market__c='TR';
        AddressFieldsList[0].ZipCode__c='12345';
        AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
        AddressFieldsList[0].Country__c='Turkey';  
        // insert AddressFieldsList;
        AddressFieldsList[1].Address_Line_1__c='Lastname1';
        AddressFieldsList[1].Address_Line_2__c='+6003123654789';
        AddressFieldsList[1].Address_Line_3__c='+60825634789541';
        AddressFieldsList[1].Address_Type__c='Business';
        AddressFieldsList[1].Province__c='+609856321478';
        AddressFieldsList[1].City__c='+609856321478';
        AddressFieldsList[1].Market__c='TR';
        AddressFieldsList[1].ZipCode__c='12345';
        AddressFieldsList[1].Country__c='Turkey';  
        AddressFieldsList[1].Customer__c=AccountFieldsList[0].id;                          
        insert AddressFieldsList;
        List<String> DMReqFields=new List<String>();
        DMReqFields.add('Customer_Name__c');
        DMReqFields.add('Sending_Address__c');
        DMReqFields.add('Channel__c');
        DMReqFields.add('Market__c');
        List<DM_Request__c> DMReqFieldsList=DataFactoryServices.createRecords('DM_Request__c',DMReqFields,'',1);
        DMReqFieldsList[0].Customer_Name__c=AccountFieldsList[0].id;
        DMReqFieldsList[0].Sending_Address__c='Home';
        DMReqFieldsList[0].Channel__c='Letter';
        DMReqFieldsList[0].Market__c='TR';
        insert DMReqFieldsList;
        DMReqFieldsList[0].Delivery_Type__c='1';
        update DMReqFieldsList;       
        DMReqFieldsList[0].Sending_Address__c='Business';
        DMReqFieldslIst[0].Assigned_Dealer__c=dealer1.id;
        update DMReqFieldsList;                                              
        test.stoptest();
          
        }                     
    }                
}