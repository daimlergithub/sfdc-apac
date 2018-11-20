/**
	** Class: TriggerAccountTriggerHandlerTRTest
	** Description: Test Class for TriggerOpportunityTriggerHandlerTR
	** Created By: Ashwin Kumar
	** Date: 22/06/2018
	**/
	@isTest
	public class TriggerOpportunityTriggerHandlerTRTest {
		private static List<Opportunity> oppList = new List<Opportunity>();
		private static List<Opportunity> oppUpdateList = new List<Opportunity>();
		private static Account personAcc;
		private static Opportunity oppSales;
		private static Opportunity oppSalesP;
		private static Opportunity oppAfterSales;
		public static User user3 = TestUtils.IntegrationAPIUser();
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
		public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		public static string dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
		public static void prepareTestData(String testCase){
			Trigger__c TriggerAccountTR = new Trigger__c(Name='TriggerOpportunityTR',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
			insert TriggerAccountTR;
			system.debug('p--'+TriggerAccountTR);
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
								LocaleSidKey='en_US', ProfileId = p.Id, Market__c='TR',
								TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
			DMLManagerService.insertAsSystem(usr);
			
			system.runAs(usr){
				personAcc = new Account(Dealer_Default_Flag__c=false,
									 Dealer_DMS_SR_Code__c='test code 2',
									 Status__c='NoCustomer',Email__c = 'testemail@test.com',
									 City__c='Istanbul',
									 Customer_Lifecycle_Phase__c='Care',
									 Gender__c = 'Male',
									 Phone = '0801801110',
									 Area_code__c = '03',
									 MD__c = 'TR',
									 Market__c = 'TR',
									 Data_Source__c = 'MBT Event',
									 LastName = 'galaxy1',
									 FirstName = 'First Name',
									 Salutation = 'Unknown',
									 Personal_Agreement__c = 'YES',
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
									 //PersonBirthdate=date.today(),
									 
									 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());         
				
				Account dealerAcc = new Account(Name = 'Test Turkey Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'TR',Dealer_GC_Code__c='12345',Dealer_Rollout_Status__c='Done');
				insert dealerAcc;
				group g = new group (name='TR12345');
				insert g;
				Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
				insert con;
				oppAfterSales = new Opportunity();
				oppAfterSales.AccountId = personAcc.Id;
				oppAfterSales.StageName = 'New';
				oppAfterSales.Market__c = 'TR';
				oppAfterSales.Name = 'Generic Opportunity AfterSales';
				oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
				oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
				oppAfterSales.Lead_Type__c = 'Service';
				oppAfterSales.Lead_Sub_Type__c = 'Others';
				oppAfterSales.Lead_DataSource__c = 'Event';
				oppAfterSales.Assigned_Dealer__c = dealerAcc.Id;           
				
				oppSales = new Opportunity();
				oppSales.AccountId = personAcc.Id;
				oppSales.StageName = 'New';
				oppSales.Market__c = 'TR';
				oppSales.Name = 'Generic Opportunity Sales';
				oppSales.RecordTypeId = salesLeadRecordTypeId;
				oppSales.CloseDate = Date.newInstance(2018, 4, 17);
				oppSales.Lead_Type__c = 'New Car';
				oppSales.Lead_Sub_Type__c = 'Test Drive';
				oppSales.Lead_DataSource__c = 'Event';
				
				
				oppList.add(oppAfterSales);
				oppList.add(oppSales);
				
				ps = new PermissionSet(Name = 'Test', Label = 'Test');
				insert ps;
				// provide Turkey Specific permissions
				TestUtils.providePermissionsIN(usr, ps, 'TRGeneric');
				
				market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'TR');
				Insert market_Obj; 
				functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
				Insert functionality_access_master_Obj; 
				persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p.id , Profiles__c = p.name);
				Insert persona_Obj; 
				user_Obj = new User(Username = 'TestUser7776920170921083316@codecoverage.com', LastName = 'LastName527', Market__c='TR', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias474', CommunityNickname = 'null', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = '00e28000000qHycAAE', LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsKnowledgeUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, UserPermissionsChatterAnswersUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, IsPortalSelfRegistered = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P', Active_Permission_Set__c = false, Active__c = false, Notification_Account_Finance_Update__c = false, Notification_Retail_Copy_Created__c = false, ChangesMadeInAssignedPersona__c = true, Persona_Assigned__c = 'IntegrationPerso111');
			}
			
		}
		
		public static testMethod void testHandleTriggerInsert(){
			test.startTest();
			User usr = TestUtils.createGenericAdminUser('Turkey', 'Asia/Kolkata', 'TR');
			System.runAs(usr){
				prepareTestData('');
				
				
				ps1 = new PermissionSet(Name = 'Test1', Label = 'Test1');
				insert ps1;
				// provide Turkey Specific permissions
				TestUtils.providePermissionsIN(usr, ps1, 'TRGeneric');
				insert personAcc;
				insert oppList;
			}
			test.stopTest();
		} 
		
		public static testMethod void testHandleTriggerUpdate(){
			test.startTest();
			User usr = TestUtils.createGenericAdminUser('Turkey', 'Asia/Kolkata', 'TR');
			System.runAs(usr){
				prepareTestData('');
				
				
				ps2 = new PermissionSet(Name = 'Test2', Label = 'Test2');
				insert ps2; 
				// provide Tirkey Specific permissions
				TestUtils.providePermissionsIN(usr, ps2, 'TRGeneric');
				insert oppList;
				
				List<Opportunity> opptyList1 = [SELECT Id, Name, StageName,Lost_Situation__c, CAC_Lost_Reason__c FROM Opportunity limit 10];
				System.debug('opptyList1==>' + opptyList1);
				for(Opportunity opp : opptyList1){
					opp.Type_of_Sale__c = 'Government';
					opp.StageName = 'Closed Lost';
					opp.Lost_Situation__c = 'Lost to Co-Dealer';
					opp.CAC_Lost_Reason__c = 'Double Lead';
					opp.Lost_Date__c = Date.newInstance(2018, 12, 17);
					opp.SLA_Status__c = 'SLA Reminder 1';
					oppUpdateList.add(opp);
				}
				OppHelperBase.booleanCampaignUpdate = true;
				System.debug('oppList=2=>' + oppUpdateList);
				update oppUpdateList; 
				List<Opportunity> opptyList2 = [SELECT Id, Name, StageName,Lost_Situation__c, CAC_Lost_Reason__c FROM Opportunity limit 10];
				System.debug('opptyList2==>' + opptyList2);
			}
			
			test.stopTest();
		} 
		public static testmethod void testINFUSER()
		{
			test.starttest();
			User usr = TestUtils.createGenericAdminUser('Turkey', 'Asia/Kolkata', 'TR');
			system.runas(usr){
			Trigger__c TriggerAccountTR = new Trigger__c(Name='TriggerOpportunityTR',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
			insert TriggerAccountTR;
			}
			system.runAs(user3) {
				TriggerUtil.userCreate = false;	
				 personAcc = new Account(Dealer_Default_Flag__c=false,
									 Dealer_DMS_SR_Code__c='test code 2',
									 Status__c='NoCustomer',Email__c = 'testemail@test.com',
									 City__c='Istanbul',
									 Customer_Lifecycle_Phase__c='Care',
									 Gender__c = 'Male',
									 Phone = '0801801110',
									 Area_code__c = '03',
									 MD__c = 'TR',
									 Market__c = 'TR',
									 Data_Source__c = 'MBT Event',
									 LastName = 'galaxy1',
									 FirstName = 'First Name',
									 Salutation = 'Unknown',
									 Personal_Agreement__c = 'YES',
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
									 //PersonBirthdate=date.today(),
									 
									 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
						insert personAcc;
				 Account dealerAcc = new Account(Name = 'Test Turkey Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'TR',Dealer_GC_Code__c='12345',Dealer_Rollout_Status__c='Done');
				insert dealerAcc;
				group g = new group (name='TR12345');
				insert g;
			   Opportunity oppAfterSales = new Opportunity();
				oppAfterSales.AccountId = personAcc.Id;
				oppAfterSales.StageName = 'New';
				oppAfterSales.Market__c = 'TR';
				oppAfterSales.Name = 'Generic Opportunity AfterSales';
				oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
				oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
				oppAfterSales.Lead_Type__c = 'Service';
				oppAfterSales.Lead_Sub_Type__c = 'Others';
				oppAfterSales.Lead_DataSource__c = 'Event';
				oppAfterSales.Assigned_Dealer__c =dealerAcc.Id;
				insert oppAfterSales;
			}
			test.stoptest();
		}
		public static testmethod void testDealerUSER()
		{
			test.starttest();
			 User usr = TestUtils.createTRAdminUser();
			 userrole ur =[select id from userrole where DeveloperName ='MBTH_Manager' limit 1];
			 usr.userroleid=ur.Id;
			 update usr;
			 PermissionSet ps2;
			 group g;
			 Account dealerAcc;
			 contact con;
			 address__c address;
			 system.runas(usr){
			  ps2 = new PermissionSet(Name = 'Test2', Label = 'Test2');
				insert ps2; 
					dealerAcc = new Account(Name = 'Test Turkey Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'TR',Dealer_GC_Code__c='12345',Dealer_Rollout_Status__c='Done');
				insert dealerAcc;
				 g = new group (name='TR12345');
				insert g;
				con = TestUtils.createContactTR('TestCon',dealerAcc.id);
				address = TestUtils.createAddressTR(dealerAcc.id);
				// provide Tirkey Specific permissions
		  Trigger__c TriggerAccountTR = new Trigger__c(Name='TriggerOpportunityTR',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
			insert TriggerAccountTR;
			 }
			 User userB = TestUtils.createDDAdminUSer(con.id);    
			 userB.market__c='TR';
			 update userB;
			 system.runas(usr){
			 TestUtils.providePermissionsIN(userB, ps2, 'TRGeneric');
			 }
			system.runAs(userB) {
				TriggerUtil.userCreate = false;
				 personAcc = new Account(Dealer_Default_Flag__c=false,
									 Dealer_DMS_SR_Code__c='test code 2',
									 Status__c='NoCustomer',Email__c = 'testemail@test.com',
									 City__c='Istanbul',
									 Customer_Lifecycle_Phase__c='Care',
									 Gender__c = 'Male',
									 Phone = '0801801110',
									 Area_code__c = '03',
									 MD__c = 'TR',
									 Market__c = 'TR',
									 Data_Source__c = 'MBT Event',
									 
									 Name = 'First Name',
									 
									 Personal_Agreement__c = 'YES',
									 Postal_Opt_Out__c=True,     
									 Province__c = 'Shanghai',
									 ZipCode__c= '32703',
									 //Mobile__c = '918197597651',
									 //Mobile2__c = '918197597651',
									 Primary_Email__c = 'Email1',
									 Primary_Fax__c = 'FAX2',
									 Primary_Phone__c ='Other2',
								   
									
									 Opt_In_Email__c=true,
									 //owner=user1,
									 //PersonBirthdate=date.today(),
									 
									 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId()); 
						insert personAcc;
			  
			   Opportunity oppAfterSales = new Opportunity();
				oppAfterSales.AccountId = personAcc.Id;
				oppAfterSales.StageName = 'New';
				oppAfterSales.Market__c = 'TR';
				oppAfterSales.Name = 'Generic Opportunity AfterSales';
				oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
				oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
				oppAfterSales.Lead_Type__c = 'Service';
				oppAfterSales.Lead_Sub_Type__c = 'Others';
				oppAfterSales.Lead_DataSource__c = 'Event';
			    oppAfterSales.CAC_Lost_Reason__c = 'Out of Stock';
				insert oppAfterSales;
			}
			test.stoptest();
		}
	}