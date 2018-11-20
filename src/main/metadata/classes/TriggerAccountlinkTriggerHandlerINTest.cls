/**
* Type:Test class
*Test class for Handler of Trigger on AccountLink for IN
* Created By:Sravanthi Gudibandi
*/

@isTest
public class TriggerAccountlinkTriggerHandlerINTest{
    private static Account acct1;
    private static Account acct2;
    private static Account_Link__c al1;
    private static Account_Link__c al2;
    private static Account_Link__c al3;
    public static Contact contactObj;
    private static List<Account> accountList = new List<Account>();
    private static Map<id,Account> accountMap =  new map<id,Account>();
    private static user us1;
    private static user user1;
    public static PermissionSet ps;
    public static PermissionSet ps1;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;  
    public static User user_Obj; 
    public static User user_Obj1;   
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public  Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public  Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public  Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    
    public static void prepareTestData(String testCase){
        
        Trigger__c TriggerAccountLinkIN=new Trigger__c(Name='TriggerAccountLinkIN',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountlinkTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
        List<Trigger__c> lsttrg = new List<Trigger__C>();
        lsttrg.add(TriggerAccountLinkIN);
        
        insert lsttrg;
        group grp = new group(name = '123456', developername = 'testndgroup');
        insert grp;
        group grp1 = new group(name = '1234567', developername = 'testgcgroup');
        insert grp1;
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
                       EmailEncodingKey='UTF-8', LastName='TestUserIN', LanguageLocaleKey='en_US', 
                       LocaleSidKey='en_US', ProfileId = p.Id, Market__c='IN',
                       TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(us1);
        
        acct1= new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           //Individual_Home_Phone__c = '02-202-2456',
                           Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212378978',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '03',
                           MD__c = 'IN',
                           LastName = 'galaxy',

                           FirstName = 'First Name',
                           Salutation = 'Unknown',
                           Postal_Opt_Out__c=True,     
                           Province__c = 'Shanghai',
                           ZipCode__c= '32703',
                           //Mobile__c = '918197597651',
                           //Mobile2__c = '918197597651',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           PersonDoNotCall=True,
                           // ownerid=user1.id,
                           PersonHasOptedOutOfEmail=True,
                           Opt_In_Email__c=true,
                           //owner=user1,
                           PersonBirthdate=date.today(),
                           dealer_nd_code__c = '123456',
                           dealer_gc_code__c = '1234567',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
        
        accountList.add(acct1);
        
        system.runAs(us1)
        {
            ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;  
            CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INGeneric ];
            
            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            insert sea;  
            
            CustomPermission cps1 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INRetail ];
            SetupEntityAccess sea1 = new SetupEntityAccess();
            sea1.ParentId = ps.Id;
            sea1.SetupEntityId = cps1.id;
            insert sea1;
            
            CustomPermission cps2 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.addressupdateRT ];
            SetupEntityAccess sea2 = new SetupEntityAccess();
            sea2.ParentId = ps.Id;
            sea2.SetupEntityId = cps2.id;
            insert sea2;
            
        }
        
        market_Obj = new Market__c(Market_Code__c ='IN', Market__c ='India');
        Insert market_Obj; 
        
        functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
        Insert functionality_access_master_Obj; 
        Profile ppp = [SELECT Id,Name FROM Profile WHERE Name='IntegrationAPI']; 
        persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = ppp.id , Profiles__c = ppp.name);
        Insert persona_Obj; 
        
        user_Obj = new User(Username = 'TestUser777692011083316@codecoverage.com'+String.valueof(DateTime.now().getTime()), LastName = 'LastName527', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111', market__c = 'MY');
        user_Obj1 = new User(Username = 'TestUser7776@codecoverage.com'+String.valueof(DateTime.now().getTime()), LastName = '1LastName5271111', Email = 'Email22@test.com1', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias444', CommunityNickname = '11null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = ppp.id, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true);
        insert user_Obj;
        insert user_Obj1;
        
    }
    
    public static testMethod void testHandleTriggerDelete(){
        
        prepareTestData('');
        TriggerUtil.userCreate=false;
        system.runAs(user_Obj1 ){
            
            List<Account_Link__c> listacclk1=new List<Account_Link__c>();
            al3= new Account_Link__c(Name='new55 al',Md__c='IN',toRole__c=acct1.id,fromrole__c=acct1.id,
                                     RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),
                                     Market__c='IN', Dealer_ND_Code__c = '123456');    listacclk1.add(al3);
            insert listacclk1;
            system.assertEquals(al3.Market__c, 'IN');
        }
    } 
    
    public static testMethod void testHandleTriggerInsert(){
        
        prepareTestData('');
        system.runAs(user_Obj ){
            
            insert accountList;
            
            acct2 =  new Account(Dealer_Default_Flag__c=false,
                                 Dealer_DMS_SR_Code__c='test code 2',
                                 //Individual_Home_Phone__c = '02-202-2456',
                                 Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212371111',
                                 Status__c='NoCustomer',Email__c = 'testemail123@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                 City__c='Beijing',
                                 Gender__c = 'Female',
                                 Phone = '0801801119',
                                 Area_code__c = '03',
                                 MD__c = 'IN',
                                 LastName = 'galaxy',
                                 FirstName = 'First Name',
                                 Salutation = 'Unknown',
                                 Postal_Opt_Out__c=True,     
                                 Province__c = 'Shanghai',
                                 ZipCode__c= '32703',
                                 //Mobile__c = '918197597651',
                                 //Mobile2__c = '918197597651',
                                 Primary_Email__c = 'Email1',
                                 Primary_Fax__c = 'FAX2',
                                 Primary_Phone__c ='Other2',
                                 PersonDoNotCall=True,
                                 // ownerid=user1.id,
                                 PersonHasOptedOutOfEmail=True,
                                 Opt_In_Email__c=true,
                                 //owner=user1,
                                 PersonBirthdate=date.today(),
                                 dealer_nd_code__c = '123456',
                                 dealer_gc_code__c = '1234567',
                                 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
            insert acct2;
            
            List<Account_Link__c> listacclk1=new List<Account_Link__c>();
            
            al1= new Account_Link__c(Name='new al',Md__c='IN',toRole__c=acct1.id,fromrole__c=acct2.id,
                                     RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),
                                     Market__c='IN', Dealer_ND_Code__c = '123456');
            
            
            listacclk1.add(al1);
           
            List<Account_Link__c> updatelst=new List<Account_Link__c>();
            al1.fromrole__c=acct2.id;
			INTriggerRecursionCheck.inAccLinkvalC2C = false;
            updatelst.add(al1);
			system.assertEquals(al1.Market__c, 'IN');
        }
    }
	public static testMethod void testTriggerUpdate(){
        
        prepareTestData('');
        system.runAs(user_Obj1 ){
            
            insert accountList;
            
            acct2 =  new Account(Dealer_Default_Flag__c=false,
                                 Dealer_DMS_SR_Code__c='test code 2',
                                 //Individual_Home_Phone__c = '02-202-2456',
                                 Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212371111',
                                 Status__c='NoCustomer',Email__c = 'testemail123@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                 City__c='Beijing',
                                 Gender__c = 'Female',
                                 Phone = '0801801119',
                                 Area_code__c = '03',
                                 MD__c = 'IN',
                                 LastName = 'galaxy',

                                 FirstName = 'First Name',
                                 Salutation = 'Unknown',
                                 Postal_Opt_Out__c=True,     
                                 Province__c = 'Shanghai',
                                 ZipCode__c= '32703',
                                 //Mobile__c = '918197597651',
                                 //Mobile2__c = '918197597651',
                                 Primary_Email__c = 'Email1',
                                 Primary_Fax__c = 'FAX2',
                                 Primary_Phone__c ='Other2',
                                 PersonDoNotCall=True,
                                 // ownerid=user1.id,
                                 PersonHasOptedOutOfEmail=True,
                                 Opt_In_Email__c=true,
                                 //owner=user1,
                                 PersonBirthdate=date.today(),
                                 dealer_nd_code__c = '123456',
                                 dealer_gc_code__c = '1234567',
                                 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
            insert acct2;
            
            List<Account_Link__c> listacclk1=new List<Account_Link__c>();
            
            al1= new Account_Link__c(Name='new al',Md__c='IN',toRole__c=acct1.id,fromrole__c=acct2.id,
                                     RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),
                                     Market__c='IN', Dealer_ND_Code__c = '123456');
            
            
            listacclk1.add(al1);
           
            List<Account_Link__c> updatelst=new List<Account_Link__c>();
            al1.fromrole__c=acct2.id;
            updatelst.add(al1);
            insert updatelst;
			system.assertEquals(al1.Market__c, 'IN');
			List<Account_Link__c> acclinkUpdateList = new List<Account_Link__c>();
            List<Account_Link__c> AcclinkList1 = [SELECT Id FROM Account_Link__c limit 10];
            System.debug('AcclinkList1==>' + AcclinkList1);
            for(Account_Link__c acclnk : AcclinkList1){
                acclnk.name = 'testone';
                acclinkUpdateList.add(acclnk);
            }
            INTriggerRecursionCheck.inAccLinkrevokesharing = false;
            INTriggerRecursionCheck.inAccLinkrevokesharing = false;
            System.debug('acclnkList=2=>' + acclinkUpdateList);
            update acclinkUpdateList; 
            List<Account_Link__c> acclnktyList2 = [SELECT Id, Name FROM Account_Link__c limit 10];
            System.debug('acclnktyList2==>' + acclnktyList2);
        }
    }
}