/**
* Test Class for TriggerHandler triggercaseHandlerFM
* Author: Shashi
* Created Date : 17th Oct 2018
*/

@isTest
public class TriggerAddressTriggerHandlerFMTest {
    public static User user1;
    public static User user2;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;
    private static Account account;
    private static Address__c address,address2;
    private static List<Address__c> addressList=new List<Address__c>();
    
    public static testMethod void TriggerAddressTriggerHandlerFM1(){
        //create test data
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
            Set<String> customperms = new Set<String>{Label.FMRetail, Label.FMGeneric, Label.CreateRetailCopy, Label.AccCDM, Label.ALAddressUpdate};
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
        //user1 = UtilTestData.createPersornaUser(ps, p1);
        //user1.market__c='ID';
        //insert user1;
        System.runAs (user2) { 
            
            Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerFM',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='ID');
        	upsert TriggerAddress;
        
            test.starttest();
            
            account= new Account();
            account.Phone='09844650654';
            account.FirstName = 'Test';        
            //account.MBK_Data_Source__c ='Email';
            account.Data_Source__c  = 'Test4';
            account.Dealer_Rollout_Status__c = 'Done';
            account.market__c='ID';
            account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
            
            
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='test1';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=account.id;
            address.TitleOfHonor__c = 'To Person'; 
            address.Preferred__c = true;
            address.country__c = 'Indonesia';
            address.ZipCode__c = '12345';
            address.market__c='ID';
            addressList.add(address);
            
            DMLManagerService.insertAsSystem(addressList);
            //insert address;
            
            address2=new Address__c();
            address2.Address_Type__c='Business';
            address2.Province__c='test1';
            address2.City__c='bangalore';
            address2.District__c='test2';
            address2.Block__c='test3';
            address2.Address_Line_1__c='testaddress1';
            address2.Address_Line_2__c='testaddress2';
            address2.Customer__c=account.id;
            address2.TitleOfHonor__c = 'To Person'; 
            address2.Preferred__c = false;
            address2.country__c = 'Indonesia';
            address2.ZipCode__c = '12345';
            address2.Market__c='ID'; 
            string updateType='';
            /*try{
                insert address2;
            }catch(Exception e){} */
            insert address2;
            update address2;
            delete address2;
            
            account.Primary_Address_Reference__c=address.id;
            update account;
            map<id,Address__c> addressOldMap=new map<id,Address__c>();
            addressOldMap.put(address.id,address);
            //test.startTest();
            TriggerRecursiveCheck.run = true;
            
            Map<id,Address__c> AddIDMap= new Map<id,Address__c>();
            AddIDMap.put(address2.Id, address2);
                
            try{
                // update address;
                AddressHelperFM.updateAddressOnAccount(addressList);
                AddressHelperBase.updatemarket(addressList); 
                AddressHelperFM.updatePrimaryAddressOnAccount(addressOldMap);
                AddressHelperFM.validateSameAddressType(addressList,addressOldMap,true,true,'ID');
                addressList[0].Address_Type__c='Business';
                DMLManagerService.updateAsSystem(addressList);
                AddressHelperFM.updateAccountonDeletion(addressList);
                AddressHelperFM.updateAddressCDM(addressList,'ID',updateType);
                
                AddressHelperFM.updateAddressRetailCopies(AddIDMap,'ID');
                system.assertNotEquals(null, addressList[0].id);
                delete address;
            }catch(Exception e){}
            
            test.stopTest();
            //account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ] ;
        }
    }
}