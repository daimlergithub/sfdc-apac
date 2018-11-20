/**
* Test Class for TriggerHandler triggercaseHandlerFM
* Author: Shashi
* Created Date : 17th Oct 2018
*/

@isTest
public class triggercaseHandlerFMTest {

    public static User user1;
    public static User user2;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj; 
    
    public static testMethod void triggercaseHandlerFM1(){
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='ID',
                         TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        System.runAs (user1) {
            group grp = new group(name = '123456', developername = 'testndgroup');
            insert grp;
            group grp1 = new group(name = '1234567', developername = 'testgcgroup');
            insert grp1;
            PermissionSet ps = new PermissionSet();
            ps.Name = 'Test';
            ps.Label = 'Test';
            insert ps;
            Set<String> customperms = new Set<String>{Label.FMRetail, Label.FMGeneric, Label.CreateRetailCopy};
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
            
            //user2 = UtilTestData.createPersornaUser(ps, p1);
            //---------------
            //Create Persona User
            //public static User createPersornaUser(PermissionSet ps, Profile prof){
                    market_Obj = new Market__c(Market_Code__c = 'ID', Market__c = 'Indonesia');
                    Insert market_Obj; 
                    functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = 'IDSysAdmin', Module_Name__c = 'IDSysAdmin', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
                    Insert functionality_access_master_Obj; 
                    persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p1.id , Profiles__c = p1.name);
                    Insert persona_Obj;
                    
                    user2 = new User(Username = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com', Market__c= 'ID',LastName = 'LastName527', Email = 'Email22@test.com',  Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = p1.ID, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
                    //return personSysUser2;
            //}
            //----------------
            
        }
        System.runAs (user2) {
            Trigger__c CaseTriggerID= new Trigger__c(Name='CaseTriggerID',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='triggercaseHandlerFM',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='ID');
            insert CaseTriggerID;
            test.starttest();
            
            List<String> AccountFields=new List<String>();
            AccountFields.add('Mobile__c');
            //AccountFields.add('MD__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',2);
            AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            AccountFieldsList[0].Lastname='Lastname1';
            AccountFieldsList[0].Mobile__c='+609856321478';
            AccountFieldsList[0].market__C='ID';
            //AccountFieldsList[0].MD__c='MY';  
            AccountFieldsList[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            AccountFieldsList[1].Name = 'test company';
            AccountFieldsList[1].Mobile__c='+609856321479';
            //AccountFieldsList[1].MD__c='MY';
            AccountFieldsList[1].market__C='ID';
            insert AccountFieldsList;
            system.assertEquals(AccountFieldsList[0].id,[select id from account where id=:AccountFieldsList[0].id limit 1].id);
            
            Address__c address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='Tokyo';
            address.City__c='bangalore';
            address.District__c='test2';
            //address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=AccountFieldsList[0].id;
            //address.TitleOfHonor__c = 'To Person';     
            address.market__C='ID';        
            insert address;
            
            AccountFieldsList[0].primary_address_reference__c = address.id;
            update AccountFieldsList[0];
            
            Account dealer = new Account();
            dealer.Dealer_Alternate_Name__c = 'Test Alternate';
            dealer.Phone = '12332121';
            dealer.Dealer_GC_Code__c = '1234567';
            dealer.Dealer_ND_Code__c = '123456';
            dealer.Name = 'test dealer';
            dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            dealer.Star_Elite_Account_Owner__c = user1.Id;
            dealer.Smart_Account_Owner__c = user1.Id;
            dealer.Dealer_Lead_System__c = 'salesforce';
            dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
            dealer.Allow_Data_Sharing__c = 'yes';
            dealer.Province__c = 'jiangsu';
            dealer.City__c = 'nanjing';
            dealer.Preferred_Language__c = 'english';
            dealer.Dealer_Lead_System__c = 'salesforce';
            dealer.Gender__c = '0=Male';
            dealer.ZipCode__c = '200235';
            dealer.Type = '0=Company';
            dealer.Status__c = '0=contac1';
            dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
            dealer.Dealer_Region__c = 'EAST';
            dealer.Dealer_Active__c = True;
            dealer.Dealer_Rollout_Status__c = 'Done';
            dealer.market__C='ID';    
            insert dealer;
            
            List<String> CaseFields=new List<String>();
            CaseFields.add('Status');
            CaseFields.add('Case_RepeatCause__c');
            CaseFields.add('accountid');
            CaseFields.add('Recordtypeid');   
            CaseFields.add('Market__c');
            CaseFields.add('priority');
            List<Case> CaseFieldsList;
			List<Case> CaseFieldsList2;
            CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
            CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
            CaseFieldsList[0].accountid=AccountFieldsList[0].id;
            CaseFieldsList[0].Market__c='ID';
            CaseFieldsList[0].status='Open';
            CaseFieldsList[0].Case_RepeatCause__c='';
            CaseFieldsList[0].priority='A';
            CaseFieldsList[0].case_dealer__c = dealer.id;
            //CaseFieldsList[0].market__C='MY';
            CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
            CaseFieldsList[1].accountid=AccountFieldsList[1].id;
            CaseFieldsList[1].Market__c='ID';
            CaseFieldsList[1].status='Open';
            CaseFieldsList[1].Case_RepeatCause__c='';
            CaseFieldsList[1].priority='Green <= 2';
            CaseFieldsList[1].case_dealer__c = dealer.id;
            //CaseFieldsList[0].market__C='MY';
            insert CaseFieldsList;
            CaseFieldsList2=DataFactoryServices.createRecords('Case',CaseFields,'',1);
            CaseFieldsList2[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
            CaseFieldsList2[0].accountid=AccountFieldsList[1].id;
            CaseFieldsList2[0].Market__c='ID';
            CaseFieldsList2[0].status='Open';
            CaseFieldsList2[0].Case_RepeatCause__c='Test';
            CaseFieldsList2[0].priority='Green <= 2';
            CaseFieldsList2[0].case_dealer__c = dealer.id;
            CaseFieldsList2[0].ParentId= CaseFieldsList[1].ID;
            /*CaseFieldsList2[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
            CaseFieldsList2[1].accountid=AccountFieldsList[1].id;
            CaseFieldsList2[1].Market__c='ID';
            CaseFieldsList2[1].status='Open';
            CaseFieldsList2[1].Case_RepeatCause__c='Test';
            CaseFieldsList2[1].priority='Green <= 2';
            CaseFieldsList2[1].case_dealer__c = dealer.id;
            CaseFieldsList2[1].ParentId= CaseFieldsList2[0].ID; */
            insert CaseFieldsList2;
            system.assertEquals(CaseFieldsList[0].id,[select id from Case where id=:CaseFieldsList[0].id limit 1].id);
            update CaseFieldsList;
            delete CaseFieldsList;
            test.stoptest();
        }  
    }
}