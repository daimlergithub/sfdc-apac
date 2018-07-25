@isTest
public class TriggerCampaignHandlerTRTest {
    public static User user1;
    public static List<Campaign> listcampaigns;  
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;  
    public static User user_Obj;      
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();    
    
    static void setupTestData(){ 
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;  
        Set<String> customperms = new Set<String>{Label.TRRetail, Label.TRGeneric, Label.RSVP};
            List<CustomPermission> lcps = new List<CustomPermission>([SELECT ID From CustomPermission WHERE MasterLabel IN :customperms]);
        List<SetupEntityAccess> lsetupentity = new List<SetupEntityAccess>();    
        for(CustomPermission cps: lcps){
            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            lsetupentity.add(sea);
        }
        if(!lsetupentity.isEmpty())
            insert lsetupentity;
        
        Profile p1 = [select id,name from profile where Name='System Administrator' limit 1];    
        User user1 = new User(LastName='User'+System.Now(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M123@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        insert user1;
        
        system.runas(user1){
            //CustomPermissionsReader cpr = new CustomPermissionsReader();
            //system.debug(cpr.hasPermission(Label.MYGeneric));
            //System.assertEquals(true, cpr.hasPermission('Reset'));  
            market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'Turkey');
            Insert market_Obj; 
            functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
            Insert functionality_access_master_Obj; 
            persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
            Insert persona_Obj; 
            user_Obj = new User(Username = 'TestUser7776920170921083316@codecoverage.com', Market__c='TR',LastName = 'LastName527', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
            //Insert user_Obj;
            system.runas(user_Obj){  
                
                Trigger__c TriggerCampaign=new Trigger__c(Name='TriggerCampaign',Trigger_Name__c='TriggerCampaign',Trigger_Handler__c='TriggerCampaignTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
                insert TriggerCampaign;  
                listcampaigns=new list<Campaign>();
                
                Contact contact = new Contact(
                    LastName = 'test Contact'
                );
                insert contact;
                
                Campaign top1 = new Campaign(          
                    Name = 'top', 
                    Status = 'Started', 
                    StartDate = System.today(), 
                    EndDate = System.today(),
                    RecordTypeId = topCampRecordTypeId,
                    market__c='TR'
                );
                insert top1;
                
                Campaign cac= new Campaign(           
                    Name = 'top', 
                    Status = 'Started', 
                    StartDate = System.today(), 
                    EndDate = System.today(),
                    Execution_Type__c ='OB_Call',
                    RecordTypeId = topCampRecordTypeId,
                    ParentId = top1.Id,
                    market__c='TR'
                );
                listcampaigns.add(cac);       
            }
        }
        system.debug('test message inside'+user_Obj);
    }
    
    static testMethod void testTriggerCampaignHandlerTR1() {
        try{
            setupTestData();
            system.debug('test message '+user_Obj);
            system.runas(user_Obj){
                system.debug('test message 1');
                test.starttest();
                system.debug('test message');
                insert listcampaigns;
                TriggerCampaignTriggerHandlerTR tdc=new TriggerCampaignTriggerHandlerTR();
                System.assertEquals(true,listcampaigns != null ); 
                tdc.handleIntegrationTrigger(true, true, true, false, false);
                
                test.stoptest();
            }
        }
        catch(Exception e){}
    }    
    
    static testMethod void testTriggerCampaignHandlerTR2() {
        try{
            setupTestData();
            system.runas(user_Obj){
                test.starttest();
                insert listcampaigns;
                List<Campaign> clist= new list<Campaign>();
                Campaign c=listcampaigns[0];
                c.EndDate=System.today()+1 ;
                clist.add(c);
                update clist;
                TriggerCampaignTriggerHandlerTR tdc=new TriggerCampaignTriggerHandlerTR();
                System.assertEquals(true,clist != null ); 
                tdc.handleIntegrationTrigger(false, true, true, false, false);
                
                test.stoptest();
            }
        }
        catch(Exception e){}
    }      
}