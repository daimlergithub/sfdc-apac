/**
** Class: TriggerAccountTriggerHandlerINTest
** Description: Test Class for TriggerAccountTriggerHandlerINTest
** Created By: Prem Kumar
** Date: 2018/03/15
**/
@isTest
public class TriggerAccountTriggerHandlerINTest {
    
    private static List<Account> accountList = new List<Account>();
    private static Account personAccOne;
    private static Map<id,Account> accountMap =  new map<id,Account>();
    private static user us1;
    public static PermissionSet ps;
    public static PermissionSet ps1;
    public static PermissionSet ps2;
    public static PermissionSet ps3;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;  
    public static User user_Obj;      
    public static void prepareTestData(String testCase){
        Trigger__c TriggerAccountIN = new Trigger__c(Name='TriggerAccountIN',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
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
        
        us1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                       EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                       LocaleSidKey='en_US', ProfileId = p.Id, Market__c='IN',
                       TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(us1);
        
        personAccOne = new Account(Dealer_Default_Flag__c=false,
                                 Dealer_DMS_SR_Code__c='test code 2',
                                 Home_Phone_2__c = '+911234567890',Work_Phone__c = '+911234567890',
                                 Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                 City__c='Beijing', Gender__c = 'Male', Phone = '+911234567890', Area_code__c = '13', MD__c = 'IN',
                                 LastName = 'galaxy Last',  FirstName = 'First Name', Salutation = 'Unknown', Postal_Opt_Out__c=True, Province__c = 'Shanghai',
                                 ZipCode__c= '327036', Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2',
                                 PersonDoNotCall=True, PersonHasOptedOutOfEmail=True, Opt_In_Email__c=true, PersonBirthdate=date.today(),
                                 
                                 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
        
        accountList.add(personAccOne); 
        
        for(Account a:accountList){
            accountMap.put(a.Id,a);
        }
        
        system.runAs(us1)
        {
            ps = new PermissionSet(Name = 'Test', Label = 'Test');
            insert ps;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(us1, ps, 'INGeneric');
        }
        
        market_Obj = new Market__c(Market_Code__c = 'IN', Market__c = 'India');
        Insert market_Obj; 
        functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
        Insert functionality_access_master_Obj; 
        persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p.id , Profiles__c = p.name);
        Insert persona_Obj; 
        user_Obj = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
        
    }
    
    public static testMethod void testHandleTriggerInsert(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
        insert updatecustomsettings;
        prepareTestData('');
        system.runAs(user_Obj ){
            ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
            insert ps1;
            // provide India Specific permissions
            TestUtils.providePermissionsIN(user_Obj, ps1, 'INGeneric');
            insert accountList;
        }
    } 
    
    public static testMethod void testHandleTriggerUpdate(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
        insert updatecustomsettings;
        prepareTestData('');
        system.runAs(user_Obj ){
            ps2 = new PermissionSet(Name = 'Test2', Label = 'Test2');
            insert ps2; 
            // provide India Specific permissions
            TestUtils.providePermissionsIN(user_Obj, ps2, 'INGeneric');
            insert accountList;
            TriggerRecursiveCheck.run = true;                 
            update accountList; 
        }
    } 
    public static testMethod void testHandleTriggerDelete(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
        insert updatecustomsettings;
        
        prepareTestData('');
        system.runAs(user_Obj ){
            ps3 = new PermissionSet(Name = 'Test3', Label = 'Test3');
            insert ps3; 
            // provide India Specific permissions
            TestUtils.providePermissionsIN(user_Obj, ps3, 'INGeneric');
            insert personAccOne;
            List<Account> accList = [SELECT Id,Name FROM Account WHERE Id =:personAccOne.Id];
            delete accList;
        }
    } 
    
}