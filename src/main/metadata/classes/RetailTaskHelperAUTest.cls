@isTest
public class RetailTaskHelperAUTest {
    public static Market__c market_Obj;
  	public static Functionality_Access_Master__c functionality_access_master_Obj ;
 	public static Persona__c persona_Obj;  
  	public static User user_Obj; 
  	public static User user_Obj1; 
  	public static PermissionSet ps;
  	private static user us1;
    
    public static testMethod void invokemethAU1(){ 
        
	Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator']; 
         us1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                   EmailEncodingKey='UTF-8', LastName='TestUserAU', LanguageLocaleKey='en_US', 
                   LocaleSidKey='en_US', ProfileId = p.Id, Market__c='AU',
                   TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
    DMLManagerService.insertAsSystem(us1);
    system.runAs(us1)
    {
         ps = new PermissionSet();
         ps.Name = 'Test';
         ps.Label = 'Test';
         insert ps; 
         CustomPermission cps2 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.AURetail ];
         
         SetupEntityAccess sea2 = new SetupEntityAccess();
         sea2.ParentId = ps.Id;
         sea2.SetupEntityId = cps2.id;
         insert sea2;
         
     }
    market_Obj = new Market__c(Market_Code__c = 'AU', Market__c = 'Australia');
    Insert market_Obj; 
      
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
        
    Profile ppp = [SELECT Id,Name FROM Profile WHERE Name='IntegrationAPI']; 
        
    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = ppp.id , Profiles__c = ppp.name);
    Insert persona_Obj; 
       
    user_Obj = new User(Username = 'TestUser777692011083316@codecoverage.com'+String.valueof(DateTime.now().getTime()), LastName = 'LastName527', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111', market__c = 'AU');
    user_Obj1 = new User(Username = 'TestUser7776@codecoverage.com'+String.valueof(DateTime.now().getTime()),Market__c='AU', LastName = '1LastName5271111', Email = 'Email22@test.com1', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias444', CommunityNickname = '11null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = ppp.id, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true);
    insert user_Obj;
    insert user_Obj1;
        
         system.runAs(user_Obj ){
        	 Account acct3 =  new Account(Dealer_Default_Flag__c=false,
                              Dealer_DMS_SR_Code__c='test code 2',
                              Individual_Home_Phone__c = '+61857454554',
                              Home_Phone_2__c = '1800123456',Work_Phone__c = '+61857454554',
                              Status__c='NoCustomer',Email__c = 'testemail123@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                              City__c='Beijing',
                              Gender__c = 'Male',
                              Phone = '0801801119',
                              Area_code__c = '03',
                              MD__c = 'AU',
                              LastName = 'tstLastName',
                              FirstName = 'tstFirstName',
                              Salutation = 'Unknown',
                              Postal_Opt_Out__c=True,     
                              Province__c = 'Shanghai',
                              ZipCode__c= '3270',
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
         insert acct3;
		List<Retail_Task__c> rtref=new List<Retail_Task__c>();
        //Retail_Task__c retailtaskref = new Retail_Task__c ();
		insert rtref;
        
        RetailTaskHelperAU rt= new RetailTaskHelperAU();
        //RetailTaskHelperBase rtb=new RetailTaskHelperBase();
        rt.shareRetailTasks(rtref);
        RetailTaskHelperBase.shareRetailTasksNDCode(rtref,'AU');

         }
    }

    
    

}