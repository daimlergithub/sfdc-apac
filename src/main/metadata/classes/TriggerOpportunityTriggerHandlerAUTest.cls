/**
** Class: TriggerOpportunityTriggerHandlerAUTest
** Description: Test Class for TriggerOpportunityTriggerHandlerAUTest
** Created By: Madhusudhan CS
** Date: 28/05/2018
** Updated By: Soumya C
**/
@isTest
public class TriggerOpportunityTriggerHandlerAUTest {
    private static List<Opportunity> oppList = new List<Opportunity>();
    private static List<Opportunity> oppUpdateList = new List<Opportunity>();
    private static Account companyAcc;
    private static Opportunity oppSales;
    private static Opportunity oppSalesP;
    private static Opportunity oppAfterSales;
    private static user usr;
    public static PermissionSet ps;
    public static PermissionSet ps1;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;  
    public static User user_Obj;     
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    public static void prepareTestData(String testCase, String Market){
        Trigger__c TriggerAccountAU = new Trigger__c(Name='TriggerOpportunity',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerAU',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
        insert TriggerAccountAU;
        system.debug('p--'+TriggerAccountAU);
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
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator']; 
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        User usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, Market__c=Market,
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        
        companyAcc = TestUtils.createGenericAccount(usr, '1456', companyAccRecordTypeId, '1234567890');        
        //string dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
       // Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN');
       // insert dealerAcc;
       // Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
        // insert con;
        oppAfterSales = new Opportunity();
        oppAfterSales.AccountId = companyAcc.Id;
        oppAfterSales.StageName = 'New';
        oppAfterSales.Market__c = Market;
        oppAfterSales.Name = 'Generic Opportunity';
        oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
        //oppAfterSales.Sales_Consultant__c = con.Id;
        //oppAfterSales.Assigned_Dealer__c = dealerAcc.Id;
        oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
        oppAfterSales.Lead_Type__c = 'Service';
        oppAfterSales.Lead_Sub_Type__c = 'Others';
        
        
        oppSales = new Opportunity();
        oppSales.AccountId = companyAcc.Id;
        oppSales.StageName = 'New';
        oppSales.Market__c = Market;
        oppSales.Name = 'Generic Opportunity';
        oppSales.RecordTypeId = salesLeadRecordTypeId;
        oppSales.CloseDate = Date.newInstance(2018, 4, 17);
        oppSales.Lead_Type__c = 'Activities';
        oppSales.Lead_Sub_Type__c = 'Test Drive';
        oppSales.Lead_DataSource__c = 'eMail';
        
        oppList.add(oppAfterSales);
        oppList.add(oppSales);
        
        system.runAs(usr)
        {
                 ps = new PermissionSet();
                  ps.Name = 'Test';
                  ps.Label = 'Test';
                  insert ps;  
                  CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.AUGeneric ];
                    
                  SetupEntityAccess sea = new SetupEntityAccess();
                  sea.ParentId = ps.Id;
                  sea.SetupEntityId = cps.id;
                  insert sea;  
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = usr.id;
            psa.PermissionSetId = ps.Id;
            insert psa;       
        }
        
        market_Obj = new Market__c(Market_Code__c = Market, Market__c = Market);
        Insert market_Obj; 
        functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
        Insert functionality_access_master_Obj; 
        persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p.id , Profiles__c = p.name);
        Insert persona_Obj; 
        user_Obj = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Market__c=Market, Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
        
    }
    
     public static testMethod void testHandleTriggerInsert(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('Australia', 'Asia/Kolkata', 'AU');
        System.runAs(usr){

            
            prepareTestData('', 'AU');
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
            insert updatecustomsettings;
            ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
            insert ps1;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(usr, ps1, 'AUGeneric');
            insert oppList;
        }
        test.stopTest();
    } 
    
     public static testMethod void testHandleTriggerInsert1(){
        test.startTest();
       

		 Profile p1 = [select id,name from profile WHERE Name='IntegrationAPI'];  
        
        User usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
         
          User user3 = TestUtils.IntegrationAPIUser();
        System.runAs(user3){
             TriggerUtil.userCreate = false;
    
            ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
            insert ps1;
            companyAcc = TestUtils.createGenericAccount(user3, '1456', companyAccRecordTypeId, '1234567890'); 
            Opportunity oppSales = createGenericOpportunity(user3, companyAcc, salesLeadRecordTypeId, 'AU');
            Opportunity oppafterSales = createGenericOpportunity(user3, companyAcc, aftersalesLeadRecordTypeId, 'AU');
            List<Car_Model__c> carModelList  = createBulkCarModel(7);
        }
        test.stopTest();
    } 
    public static testMethod void testHandleTriggerInsert2(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('Australia', 'Asia/Kolkata', 'AU');
        System.runAs(usr){
         
            TriggerOpportunityTriggerHandlerAU to =new TriggerOpportunityTriggerHandlerAU();
            to.handleIntegrationTrigger(false,True,True,True,false);
        }
        test.stopTest();
    }     
       public static testMethod void testHandleTriggerInsert3(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('New Zealand', 'Asia/Kolkata', 'NZ');
        System.runAs(usr){

            
            prepareTestData('','NZ');
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
            insert updatecustomsettings;
            ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
            insert ps1;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(usr, ps1, 'NZGeneric');
            insert oppList;
        }
        test.stopTest();
    }
    
         public static Opportunity createGenericOpportunity(User u, Account acc, Id oppRecordTypeId, String market){
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Market__c = market;
        opp.Name = 'Generic Opportunity';
        opp.RecordTypeId = oppRecordTypeId;
        opp.CloseDate = Date.newInstance(2018, 4, 17);
        opp.Selected_Car_Model__c ='CLA;A-Class';
        if(UtilRecordType.getRecordTypeNameById('Opportunity', oppRecordTypeId) == 'Sales Lead'){
            opp.Lead_Type__c = 'New Car';
            opp.Lead_Sub_Type__c = 'Car Configurator';
            opp.Lead_DataSource__c = '3rd Party';
        }
        else{
            opp.Lead_Type__c = 'Parts';
            opp.Lead_Sub_Type__c = 'Accessories';
            opp.Lead_DataSource__c = '3rd Party';
        }
        //opp.Lead_Type__c = typeValues[0].getValue();
        //opp.Lead_Sub_Type__c = subTypeValues[0].getValue();
        insert opp;
        return opp;
    }
    
        public static List<Car_Model__c> createBulkCarModel(Integer n){
        List<Car_Model__c> cModelList = new List<Car_Model__c>();
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'Mercedes-Benz' + i;
            cm.Brand__c = 'Mercedes-Benz';
            cm.Series__c = 'A' + 1;
            cm.Status__c = 'Own Sellable';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cm.Market__c ='AU';
            cm.DFE_Marker__c ='Y';
             cm.Marketing_Class__c = 'CLA';
            cModelList.add(cm);
        }
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'BMW GT Series' + i;
            cm.Brand__c = 'BMW';
            cm.Series__c = 'GT' + 1;
            cm.Status__c = 'Competitor';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cm.Market__c ='AU';
            cm.DFE_Marker__c ='Y';
            cm.Marketing_Class__c = 'A-Class';
            cModelList.add(cm);
        }
        insert cModelList;
        return cModelList;
    }
    
}