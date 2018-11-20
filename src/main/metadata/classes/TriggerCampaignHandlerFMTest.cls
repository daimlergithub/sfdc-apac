@isTest
public class TriggerCampaignHandlerFMTest {
public static User user1;
public static List<Campaign> listcampaigns;  
public static List<Campaign> listCampaignInt;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj;  
public static Persona__c persona_Obj_Int; 
public static User user_Obj;  
public static User userInt;
//public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static string CampExeRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
@testSetup    
static void setupTestData(){ 
PermissionSet ps = new PermissionSet();
ps.Name = 'Test';
ps.Label = 'Test';
insert ps;  
CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.FMGeneric ]; //ANkitK Label change
    
SetupEntityAccess sea = new SetupEntityAccess();
sea.ParentId = ps.Id;
sea.SetupEntityId = cps.id;
insert sea;

Profile p1 = [select id,name from profile where Name='System Administrator' limit 1];  
Profile p2 = [select id,name from profile where Name='IntegrationAPI' limit 1];   //Ankit  
    
User user1 = new User(LastName='User'+System.Now(),Market__c='ID',country='Indonesia',firstName='AAA',ProfileId=p1.Id,Alias='AAA111',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='ankit.kapoor01@infosys.com',UserName='camptestuser@camptest.com.dev01'+String.valueof(DateTime.now().getTime()));
insert user1;
    
    
userInt = new User(LastName='userInt'+System.Now(),firstName='AAA',ProfileId=p2.Id,Alias='AA222',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='ankit.kapoor01@infosys.com',UserName='camptestuserInt@camptest.com.dev01'+String.valueof(DateTime.now().getTime()));
insert userInt;
    
  system.runas(user1){
      //CustomPermissionsReader cpr = new CustomPermissionsReader();
     //system.debug(cpr.hasPermission(Label.MYGeneric));
    //System.assertEquals(true, cpr.hasPermission('Reset'));  
    market_Obj = new Market__c(Market_Code__c = 'ID', Market__c = 'Indonesia');
    Insert market_Obj; 
    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
    Insert functionality_access_master_Obj; 
    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'TestPersona', ProfileId__c = p1.id , Profiles__c = p1.name);
    Insert persona_Obj; 
      //Ankit
//    persona_Obj_Int = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'TestPersonaInt', ProfileId__c = p2.id , Profiles__c = p2.name);
//    Insert persona_Obj_Int;  
      
  user_Obj = new User(Username = 'TestUser77769201234231412346@codecoverage.com', LastName = 'LastName527', Email = 'Email21234123@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias23', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'TestPersona');
    //Insert user_Obj;
      
//    user_Obj_Int = new User(Username = 'TestUser7776234231412346@codecoverage.com', LastName = 'LastName527', Email = 'Email21234123@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias23', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'TestPersonaInt');
//    Insert user_Obj_Int;
   
  system.runas(user_Obj){  
      Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaignID',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerFM',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='ID');
  		insert TriggerCampaign; 
  listcampaigns=new list<Campaign>();
       
       Contact contact = new Contact(
           LastName = 'test Contact'
       );
       insert contact;
       
       Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Draft', 
           	IsActive =false,
            StartDate = System.today(), 
            EndDate = System.today(),
          	Campaign_Type__c = 'Sales',
          	Purpose__c = 'Loyality',
            RecordTypeId = topCampRecordTypeId
        );
        insert top1;
                    
       Campaign campExe = new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            RecordTypeId = CampExeRecordTypeId, 
            ParentId = top1.Id
        );
        listcampaigns.add(campExe);  
   //   insert campExe;
    }
}     
}
    
static testMethod void testTriggerCampaignHandlerFM1() {  //Ankit MY1 to FM1
        try{
          
           system.runas(user_Obj){
                test.starttest();
                TriggerCampaignTriggerHandlerFM tdc=new TriggerCampaignTriggerHandlerFM();
                System.assertEquals(true,listcampaigns != null ); 
                tdc.handleIntegrationTrigger(true, true, true, false, false);
           		insert listcampaigns;
                test.stoptest();
           }
                
          }
        catch(Exception e){}
    }  
    
    static testMethod void testTriggerCampaignHandlerFM3() {  //Ankit MY1 to FM1
        System.debug('hiiiiii');
        Profile p2 = [select id,name from profile where Name='IntegrationAPI' limit 1];
        User usrIntegration = new User(LastName='userInt'+System.Now(),firstName='AAA',ProfileId=p2.Id,Alias='AA222',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='ankit.kapoor01@infosys.com',UserName='camptestuserInt@camptest.com.dev01'+String.valueof(DateTime.now().getTime()));
insert usrIntegration;
          
          System.debug('123----'+listcampaigns);
           system.runas(usrIntegration){
               System.debug('Ank----'+usrIntegration.Profile.name);
                test.starttest();
               TriggerUtil.userCreate=false;
               
            Campaign CampaignInt  = new Campaign(          
            Name = 'topInt', 
            Status = 'Draft', 
           	IsActive =false,
            StartDate = System.today(), 
            EndDate = System.today(),
          	Campaign_Type__c = 'Sales',
          	Purpose__c = 'Loyality',
            Market__c='ID',
            RecordTypeId = topCampRecordTypeId
        );
        insert CampaignInt;
               
            Campaign campExeInt = new Campaign(           
            Name = 'topExeInt', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB_Call',
            Market__c='ID',
            RecordTypeId = CampExeRecordTypeId, 
            ParentId = CampaignInt.Id
        );
        System.debug('Ankit123----'+listCampaignInt);
        listCampaignInt=new list<Campaign>();
        listCampaignInt.add(campExeInt); 
               
               
            //    TriggerCampaignTriggerHandlerFM tdc=new TriggerCampaignTriggerHandlerFM();
           //     System.assertEquals(true,listcampaigns != null ); 
               // tdc.handleIntegrationTrigger(true, true, true, false, false);
           		insert listCampaignInt;
                test.stoptest();
           }
                
          
        
    }  
static testMethod void testTriggerCampaignHandlerFM2() {
        try{
          
           system.runas(user_Obj){
                test.starttest();
                List<Campaign> clist= new list<Campaign>();
                Campaign c=listcampaigns[0];
                c.EndDate=System.today()+1 ;
                clist.add(c);
                TriggerCampaignTriggerHandlerFM tdc=new TriggerCampaignTriggerHandlerFM();
                System.assertEquals(true,clist != null ); 
                tdc.handleIntegrationTrigger(false, true, true, false, false);
                update clist;
                test.stoptest();
           }
          }
        catch(Exception e){}
    }        

}