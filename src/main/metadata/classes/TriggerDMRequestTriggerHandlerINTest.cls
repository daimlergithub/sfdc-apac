/**
** Class: DMRequestINTest 
** Description: Test Class for DMRequestHelperIN & TriggerDMRequestTriggerHandlerIN.
** Created By: Honey Narang
** Date: 17/08/2018
**/
@isTest
public with sharing class TriggerDMRequestTriggerHandlerINTest{
    
    public static User user1;
    public static User user2;
    //public static User user3;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');                                                                                        
    public static Persona__c persona_Obj; 
    
    static testMethod void testTriggerDMRequestTriggerHandlerIN1() {
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;
        
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: 'INGeneric'];
        
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
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
            
            market_Obj = new Market__c(Market_Code__c = 'IN', Market__c = 'India');
            Insert market_Obj; 
            functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
            Insert functionality_access_master_Obj; 
            persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
            Insert persona_Obj; 
            user2 = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null1', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
        }
        
        System.runAs (user2) {
            Trigger__C dmtrigger=new Trigger__C(name='TriggerAccountLinkIN',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='IN',Trigger_Handler__c='TriggerDMRequestTriggerHandlerIN',Trigger_Name__c='TriggerDMRequest',update__c=true);
            insert dmtrigger;
            test.starttest();
            List<String> AccountFields=new List<String>();
            AccountFields.add('Lastname');
            AccountFields.add('Mobile__c');
            AccountFields.add('MD__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
            AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            AccountFieldsList[0].Lastname='Lastname';
            AccountFieldsList[0].FirstName='Lastname';
            AccountFieldsList[0].Mobile__c='+919988998877';
            AccountFieldsList[0].MD__c='IN';   
            
            insert AccountFieldsList;
            List<String> AddressFields=new List<String>();
            AddressFields.add('Address_Line_1__c');
            AddressFields.add('Address_Line_2__c');
            AddressFields.add('Address_Line_3__c');
            AddressFields.add('Address_Type__c');
            AddressFields.add('City__c');
            AddressFields.add('Province__c');
            AddressFields.add('MD__c');
            AddressFields.add('Country__C');
            List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',1);
            AddressFieldsList[0].Address_Line_1__c='Lastname1';
            AddressFieldsList[0].Address_Line_2__c='+918899887766';
            AddressFieldsList[0].Address_Line_3__c='+919988776655';
            AddressFieldsList[0].Address_Type__c='Home';
            AddressFieldsList[0].Province__c='+918909878890';
            AddressFieldsList[0].City__c='+919988334455';
            AddressFieldsList[0].MD__c='IN';
            AddressFieldsList[0].Country__c='IN';
            AddressFieldsList[0].ZipCode__c='12345';
            AddressFieldsList[0].District__c = 'Test';
            AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
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
    
    static testMethod void testTriggerDMRequestTriggerHandlerIN2() {
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;
        
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: 'INGeneric' ];
        CustomPermission cps1 = [SELECT ID From CustomPermission WHERE MasterLabel =: 'INRetail' ];
        
        SetupEntityAccess sea1 = new SetupEntityAccess();
        sea1.ParentId = ps.Id;
        sea1.SetupEntityId = cps1.id;
        insert sea1;                                                                                                 
        
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        group grp = new group(name = 'IN123456', developername = 'IN123456');
        insert grp;
        
        Account dealer1;                                                                 
        
        Profile p1 = [select id, name from profile where Name='IntegrationAPI' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
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
            dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='IN', Individual_Home_Phone__c='02202123626', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='123456');
            insert dealer1;
            market_Obj = new Market__c(Market_Code__c = 'IN', Market__c = 'India');
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
            
            Trigger__C dmtrigger=new Trigger__C(name='TriggerAccountLinkIN',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='IN',Trigger_Handler__c='TriggerDMRequestTriggerHandlerIN',Trigger_Name__c='TriggerDMRequest',update__c=true);
            insert dmtrigger;
            TriggerUtil.userCreate=false;     
            test.starttest();
            List<String> AccountFields=new List<String>();
            AccountFields.add('Lastname');
            AccountFields.add('Mobile__c');
            AccountFields.add('MD__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
            AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            AccountFieldsList[0].Lastname='Lastname1';
            AccountFieldsList[0].Mobile__c='+609856321478';
            AccountFieldsList[0].MD__c='IN';   
            insert AccountFieldsList;
            List<String> AddressFields=new List<String>();
            AddressFields.add('Address_Line_1__c');
            AddressFields.add('Address_Line_2__c');
            AddressFields.add('Address_Line_3__c');
            AddressFields.add('Address_Type__c');
            AddressFields.add('City__c');
            AddressFields.add('Province__c');
            AddressFields.add('MD__c');
            List<Address__c> AddressFieldsList=DataFactoryServices.createRecords('Address__c',AddressFields,'A',2);
            AddressFieldsList[0].Address_Line_1__c='Lastname1';
            AddressFieldsList[0].Address_Line_2__c='+919955667788';
            AddressFieldsList[0].Address_Line_3__c='+919955667789';
            AddressFieldsList[0].Address_Type__c='Home';
            AddressFieldsList[0].Province__c='+919955667780';
            AddressFieldsList[0].City__c='+919955667781';
            AddressFieldsList[0].MD__c='IN';
            AddressFieldsList[0].ZipCode__c='12345';
            AddressFieldsList[0].Customer__c=AccountFieldsList[0].id;  
            AddressFieldsList[0].District__c = 'Test';
            // insert AddressFieldsList;
            AddressFieldsList[1].Address_Line_1__c='Lastname1';
            AddressFieldsList[1].Address_Line_2__c='+919955667782';
            AddressFieldsList[1].Address_Line_3__c='+919955667783';
            AddressFieldsList[1].Address_Type__c='Business';
            AddressFieldsList[1].Province__c='+609856321478';
            AddressFieldsList[1].City__c='+609856321478';
            AddressFieldsList[1].MD__c='IN';
            AddressFieldsList[1].ZipCode__c='12345';
            AddressFieldsList[1].District__c = 'Test';
            AddressFieldsList[1].Customer__c=AccountFieldsList[0].id;  
            insert AddressFieldsList;
            List<String> DMReqFields=new List<String>();
            DMReqFields.add('Customer_Name__c');
            DMReqFields.add('Sending_Address__c');
            DMReqFields.add('Channel__c');
            DMReqFields.add('MD__c');
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
            DMReqFieldsList[0].MD__c='IN';
            insert DMReqFieldsList;
            DMReqFieldsList[0].Delivery_Type__c='1';
            update DMReqFieldsList; 
            DMReqFieldsList[0].Sending_Address__c='Business';
            DMReqFieldslIst[0].Assigned_Dealer__c=dealer1.id;
            DMReqFieldslIst[0].Status1__c='Success';
            DMReqFieldslIst[0].Status2__c='Success';
            DMReqFieldslIst[0].Status3__c='Success';
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
}