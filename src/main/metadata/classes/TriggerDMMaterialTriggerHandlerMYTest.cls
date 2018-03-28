@isTest
public class TriggerDMMaterialTriggerHandlerMYTest {
    public static Account account;
    public static Contact contact;
    public static Contact contact1;
    public static String testEmail = 'test@test.com';
    public static List<Contact> contacts;
    public static User portaluser;
    public static User portaluser1;
    public static User user2;
    public static User user1;
    public static PermissionSet ps;
    
    static void createTestData()
    {
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        
        System.runAs (user1) {
            Trigger__c TriggerContact = new Trigger__c(Name='TriggerDMMaterialMY',Trigger_Name__c='TriggerDMMaterial',Trigger_Handler__c='TriggerDMMaterialTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
            upsert TriggerContact;
            
            ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
            
            CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];

            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            insert sea;
            
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
      
            user2 = UtilTestData.createPersornaUser(ps, p1);
            user2.userroleid = portalRole.id;
            insert user2;
        }
        
        System.runAs(user2){
            group grp = new group(name = 'MYtestdeal');
            insert grp;
            
            account = new Account();
            account.Name = 'account name';
            account.Phone = '012310086';
            account.Area_Code__c = '010';
           // account.Fax = '012310086';
            account.BillingCity = 'San Francisco';
            account.BillingCountry = 'USA';
            account.BillingPostalCode = '94105';
            account.BillingState = 'CA';
            account.Dealer_Presales_Email__c=testEmail;
            account.Dealer_CRM_Manager_Email__c =testEmail;
            account.Dealer_Marketing_Manager_Email__c=testEmail;
            account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
            account.Dealer_Complaint_Manager__c='true';
            account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            account.dealer_nd_code__c = 'testdeal';
            account.MD__C = 'MY';
            insert account;
            
            contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = testEmail;
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = account.Id;
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
            contact1.AccountId = account.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;
             
            Profile p = [SELECT Id, name FROM Profile WHERE usertype='PowerPartner' limit 1];
           // portaluser = UtilTestData.createPersornaUser(ps, p);
            Functionality_Access_Master__c  functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul231', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
            Insert functionality_access_master_Obj; 
            Persona__c  persona_Obj = new Persona__c(Market_Access__c = UtilTestData.market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso777', ProfileId__c = p.id , Profiles__c = p.name);
            Insert persona_Obj;
      
            portaluser= new User(LastName = 'LastName527', Email = 'Email22@test.com',  Alias = 'Alias475', CommunityNickname = 'nully', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = p.ID, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso777');
            portaluser.alias = 'test123'; 
            portaluser.email='test123@noemail.com';
            portaluser.emailencodingkey='UTF-8';
            portaluser.lastname='Testing';
            portaluser.languagelocalekey='en_US';
            portaluser.localesidkey='en_US';
            portaluser.profileid = p.id;
            portaluser.country='India';
            portaluser.IsActive =true;
            portaluser.ContactId = contacts[0].Id;
            portaluser.timezonesidkey='America/Los_Angeles';
            portaluser.username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime());
            insert portaluser;
      }
    }
    
    Public static testMethod void testDMMaterialInsert(){
        createTestData();
        Test.startTest();
        System.runAs(portaluser){
            DM_Material__c dmtrl = new DM_Material__c(name = 'testmaterial');
            insert dmtrl;
        }
        Test.stopTest();
    }
}