/**
** Class: TriggerAccountTriggerHandlerINTest
** Description: Test Class for TriggerAccountTriggerHandlerINTest
** Created By: Prem Kumar
** Date: 12/04/2018
**/
@isTest
public class TriggerOpportunityTriggerHandlerINTest {
    private static List<Opportunity> oppList = new List<Opportunity>();
    private static List<Opportunity> oppUpdateList = new List<Opportunity>();
    private static Account companyAcc;
    private static Opportunity oppSales;
    private static Opportunity oppSalesP;
    private static Opportunity oppAfterSales;
    private static user usr;
    public static PermissionSet ps;
    public static PermissionSet ps1;
    public static PermissionSet ps2;
    public static PermissionSet ps3;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;  
    public static User user_Obj;     
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    public static void prepareTestData(String testCase){
        Trigger__c TriggerAccountIN = new Trigger__c(Name='TriggerOpportunity',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
        insert TriggerAccountIN;
        system.debug('p--'+TriggerAccountIN);
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
                            LocaleSidKey='en_US', ProfileId = p.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        
        companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');        
        string dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN');
        insert dealerAcc;
        Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
        insert con;
        oppAfterSales = new Opportunity();
        oppAfterSales.AccountId = companyAcc.Id;
        oppAfterSales.StageName = 'New';
        oppAfterSales.Market__c = 'IN';
        oppAfterSales.Name = 'Generic Opportunity';
        oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
        //oppAfterSales.Sales_Consultant__c = con.Id;
        //oppAfterSales.Assigned_Dealer__c = dealerAcc.Id;
        oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
        oppAfterSales.Lead_Type__c = 'Car Service';
        oppAfterSales.Lead_Sub_Type__c = 'Others';
        oppAfterSales.Lead_DataSource__c = 'Event';
        
        oppSales = new Opportunity();
        oppSales.AccountId = companyAcc.Id;
        oppSales.StageName = 'New';
        oppSales.Market__c = 'IN';
        oppSales.Name = 'Generic Opportunity';
        //oppSales.Sales_Consultant__c = con.Id;
        //oppSales.Assigned_Dealer__c = dealerAcc.Id;
        oppSales.RecordTypeId = salesLeadRecordTypeId;
        oppSales.CloseDate = Date.newInstance(2018, 4, 17);
        oppSales.Lead_Type__c = 'Activities';
        oppSales.Lead_Sub_Type__c = 'Test Drive';
        oppSales.Lead_DataSource__c = 'Event';
        
        oppList.add(oppAfterSales);
        oppList.add(oppSales);
        
        system.runAs(usr)
        {
            ps = new PermissionSet(Name = 'Test', Label = 'Test');
            insert ps;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(usr, ps, 'INGeneric');
        }
        
        market_Obj = new Market__c(Market_Code__c = 'IN', Market__c = 'IN');
        Insert market_Obj; 
        functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
        Insert functionality_access_master_Obj; 
        persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p.id , Profiles__c = p.name);
        Insert persona_Obj; 
        user_Obj = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Market__c='IN', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
        
    }
    
    public static testMethod void testHandleTriggerInsert(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            prepareTestData('');
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
            insert updatecustomsettings;
            ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
            insert ps1;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(usr, ps1, 'INGeneric');
            insert oppList;
        }
        test.stopTest();
    } 
    
    public static testMethod void testHandleTriggerUpdate(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            prepareTestData('');
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
            insert updatecustomsettings;
            ps2 = new PermissionSet(Name = 'Test2', Label = 'Test2');
            insert ps2; 
            // provide India Specific permissions
            TestUtils.providePermissionsIN(usr, ps2, 'INGeneric');
            insert oppList;
            Opportunity tempOpp = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
            List<Opportunity> opptyList = [SELECT Id,Name FROM Opportunity limit 10];
            for(Opportunity opp : opptyList){
                opp.Type_of_Sale__c = 'Government';
                opp.StageName = 'Closed Lost';
                opp.Lost_Situation__c = 'Lost to Co-Dealer';
                opp.CAC_Lost_Reason__c = 'Double Lead';
                opp.Lost_Date__c = Date.newInstance(2018, 12, 17);
                oppUpdateList.add(opp);
            }
            OppHelperBase.booleanCampaignUpdate = true;
            update oppUpdateList; 
            TriggerOpportunityTriggerHandlerIN to =new TriggerOpportunityTriggerHandlerIN();
            to.handleIntegrationTrigger(True,True,True,True,True);
        }
        test.stopTest();
    } 
}