/*
    Type:       Utility for preparing test data
    Purpose:    Prepare Test data for Unit Test
    User Story: 
    Used By:    DealerSearchControllerTest.cls, 
                AccountMergeControllerTest.cls,
                CarModelComparisonControllerTest.cls,
                SelectAssignedDealerController.cls,
                TriggerVehicleRelationshipTest.cls,
                TriggerSalesTest.cls,
                TriggerAftersalesTest.cls,
                TriggerAccountTest.cls
                TriggerCampaignLeadTest.cls
                DMRequestTriggerHandlerTest.cls
                EDMControllerExtensionTest.cls
                FAQNoticeControllerExtensionTest.cls
                ScheduleCreateOutboundEmailTest.cls
                ScheduleSendOutboundEmailTest.cls
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-13
    2. Chris Overwrite createUser method by RoleName and ProfileName on 2013-03-14
    3. Mouse add Singleton and simple factory pattern to this class on 2013-03-15
    4. Mouse add test data of lead management on 2013-04-24
*/
@isTest
Public class UtilTestData {
    private static Map<String, Id> recordTypeMap;
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;
    
    private static String testString='test';
    private static String languageString='en_US';
    private static String accountString='Account';
    private static String classValue='A-Class';
    private static String taskString='Task';
    private static String openStatus='Open';
    private static String generalPriority='General';

    public final static String ACCOUNT_RT_PERSON_ACCOUNT = 'Person Account';
    public final static String ACCOUNT_RT_DEALER = 'Dealer';
    public final static String accountLink_Contact2Contact = 'Contact2Contact';

    public final static String LEAD_RT_SALES_LEADS = 'Sales Leads';
    
    public final static String Vehicle_Relationship_Retail ='Vehicle Relationship Retail';
    public final static String VEHICLE_RELATIONSHIP = 'Vehicle Relationship';

    public final static String VEHICLE_MB = 'MB';

    public final static String CAMPAIGN_RT_CAMPAIGN_EXECUTION = 'Campaign Execution - Simple';
    public final static String CAMPAIGN_RT_CAC_CAMPAIGN = 'CAC Campaign';
    public final static String CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN = 'Central Marketing Campaign';
    public final static String CASE_RT_MB_COMPLAINT = 'MB Complaint';
    public final static String CASE_RT_CHRYSLER_COMPLAINT = 'Chrysler Complaint';

    public final static String TASK_RT_SMS = 'SMS';
    public final static String TASK_RT_EDM = 'eDM';
    public final static String TASK_RT_DM = 'DM';
    public final static String TASK_RT_OB = 'OB';
    
    //public final static String GENERAL_TASK = 'General Task';

    public final static Integer BATCH_SIZE = 101;
    
    // Initiate recordTypeMap
    private static Map<String, Id> getRecordTypeMapInstance() {
        if (recordTypeMap == null) {
            recordTypeMap = new Map<String, Id>();
            for (RecordType rt : [SELECT Id, Name, SobjectType FROM RecordType LIMIT 1000]) {
                recordTypeMap.put(rt.Name + rt.SobjectType, rt.Id);
            }
        }
        
        return recordTypeMap;
    }
    
    // Initiate roleMap
    private static Map<String, Id> getUserRoleMapInstance() {
        if (roleMap == null) {
            roleMap = new Map<String, Id>();
            for (UserRole role : [SELECT Id, Name FROM UserRole LIMIT 1000]) {
                roleMap.put(role.Name, role.Id);
            }
        }
        
        return roleMap;
    }
    
    // Initiate profileMap
    private static Map<String, Id> getProfileMapInstance() {
        if (profileMap == null) {
            profileMap = new Map<String, Id>();
            for (Profile prof : [SELECT Id, Name FROM Profile LIMIT 1000]) {
                profileMap.put(prof.Name, prof.Id);
            }
        }
        
        return profileMap;
    }
    
    // Get UserRoleId by Role Name
    Public static Id getUserRoleId(String roleName) {
        return getUserRoleMapInstance().get(roleName);
    }
    
    // Get ProfileId by Profile Name
    Public static Id getProfileId(String profileName) {
        return getProfileMapInstance().get(profileName);
    }
    
    // Create Test User
    private static User createUser(Id userRoleId, Id profileId) {
        User usr = new User();
        usr.UserName = testString + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = userRoleId;
        usr.ProfileId = profileId;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = testString;
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = languageString;
        usr.localesidkey=languageString;
        usr.isActive = true;
        insert usr;
        return usr;
    }
       // Create Test portal User
    private static User createPortalUser(Id userRoleId, Id profileId) {   
       User thisUser = [ select Id,UserRoleId from User where Id = :UserInfo.getUserId() ];        
        Account acc = new Account ( Name = 'dummtyTestAcc',Mobile__c = '00000009642',OwnerId = thisUser.Id,Work_Phone__c='+66037779999',Individual_Home_Phone__c='+66037773999'); 
        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_DEALER  + accountString);     
        insert acc;      
        System.assert(acc.Name=='dummtyTestAcc');
        Contact con = new Contact ( AccountId = acc.id, LastName = 'portalTestUser',Dealer_Complaint_Gate_Keeper__c=true, Permission_Set_Settings__c = 'S_M_Retail_Campaign');
        insert con;      
        System.assert(con.LastName=='portalTestUser'); 
        System.Debug('@@@@@@@@@@ profileId '+profileId);
        System.Debug('@@@@@@@@@@@ userRoleId'+userRoleId); 
        //Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        //Profile PartnerPrfile = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        //System.Debug('@@@@@@@@@@@ PartnerPrfile.Id'+PartnerPrfile.Id); 
        System.assertEquals(UserInfo.getUserId(),thisUser.id);   
        User usr=new User();       
        System.runAs ( thisUser ) {               
                usr.UserName = testString + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId=profileId;
                // usr.UserRoleId=userRoleId;
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = testString;
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = languageString;
                usr.localesidkey=languageString;
                usr.isActive = true;
                usr.ContactId =con.Id;
                Database.insert(usr); 
                system.debug('!!!!! User Records'+usr); 
         }                        
        return usr; 
          
    }
   
   // Create Test User by Role Name and Profile Name
    public static User createUser(String roleName, String profileName) {
        Id userRoleId = getUserRoleId(roleName);
        if (userRoleId == null) {
            throw new IllegalArgumentException('Unknown user role ' + roleName);       
        }
        
        Id profileId = getProfileId(profileName);
        if (profileId == null) {
            throw new IllegalArgumentException('Unknown profile ' + profileName);
        }

        return createUser(userRoleId, profileId);
    }
  
    // Create Test portal User by Role Name and Profile Name
    public static User createPortalUser(String roleName, String profileName) {
        Id userRoleId = getUserRoleId(roleName);
        if (userRoleId == null) {
            throw new IllegalArgumentException('Unknown user role ' + roleName);
        }
        
        Id profileId = getProfileId(profileName);
        if (profileId == null) {
            throw new IllegalArgumentException('Unknown profile ' + profileName);
        }
System.Debug('@@@@@@@@@@ profileName'+profileName);
        System.Debug('@@@@@@@@@@@ roleName'+roleName);
        return createPortalUser(userRoleId, profileId);
    }
  /*
   // Create Test portal User by Role Name , Profile Name and Account Name
    public static User createPortalUserforAccount(String roleName, String profileName,String accountRecordTypeName) {
        Id userRoleId = getUserRoleId(roleName);
        if (userRoleId == null) {
            throw new IllegalArgumentException('Unknown user role ' + roleName);
        }
        
        Id profileId = getProfileId(profileName);
        if (profileId == null) {
            throw new IllegalArgumentException('Unknown profile ' + profileName);
        }

        return createPortalUserforAccount(userRoleId, profileId, accountRecordTypeName);
    } */
  
    public static Sobject createSobject(Sobject so, String recordTypeName) {
        initiateSobject(so, recordTypeName);
        
        insert so;
        return so;
    }

    public static List<Sobject> createSobjects(List<Sobject> sos, String recordTypeName) {
        initiateSobjects(sos, recordTypeName);

        insert sos;
        return sos;
    }
    
    // Initiate sobjects which number is BATCH_SIZE
    private static List<Sobject> initiateSobjects(List<Sobject> sos, String recordTypeName) {
        for (Sobject so : sos) {
            initiateSobject(so, recordTypeName);
        }

        return sos;
    }
    
    private static Sobject initiateSobject(Sobject so, String recordTypeName) {
        if (so instanceof Account) {
			Account acc=(Account)so;
            if (recordTypeName == ACCOUNT_RT_PERSON_ACCOUNT) {
                initiatePersonAccount(so);
            }
            else if (recordTypeName == ACCOUNT_RT_DEALER) {
				if(acc.MD__C=='TH'){
					initiateDealer1(so);
                }
                else{
					initiateDealer(so);
				}
			}
        }
        else if (so instanceof Contact) {
            initiateContact(so);
        }
        else if (so instanceof Vehicle__c) {
            initiateVehicle(so);
        }
        else if (so instanceof Vehicle_Relationship__c) {
            initiateVehicleRelationship(so, recordTypeName);
        }
        else if (so instanceof Car_Model__c) {
            initiateCarModel(so);
        }
        else if (so instanceof Attribute__c) {
            initiateAttribute(so);
        }
        else if (so instanceof Car_Model_Attribute__c) {
            initiateCarModelAttribute(so);
        }
        else if (so instanceof Lead__c) {
            if (recordTypeName == LEAD_RT_SALES_LEADS) {
                initiateSalesLead(so);
            }
        }
        else if (so instanceof Campaign_Lead__c) {
            initiateCampaignLead(so);
        }
        else if (so instanceof Campaign) {
            if (recordTypeName == CAMPAIGN_RT_CAMPAIGN_EXECUTION) {
                initiateCampaignExecution(so);
            }
            else if (recordTypeName == CAMPAIGN_RT_CAC_CAMPAIGN) {
                initiateCACCampaign(so);
            }
            else if (recordTypeName == CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN) {
                initiateCentralMKTCampaign(so);
            }
        }
        else if (so instanceof CampaignMember) {
            initiateCampaignMember(so);
        }
        else if (so instanceof Campaign_Package__c) {
            initiateCampaignPackage(so);
        }
        else if (so instanceof Participating_Dealer__c) {
            initiateParticipatingDealer(so);
        }
        else if (so instanceof Campaign_Offering__c) {
            initateCampaignOffering(so);
        }
        else if (so instanceof Package_Item__c) {
            initiatePackageItem(so);
        }
        else if (so instanceof Attachment) {
            initiateAttachment(so);
        }
        else if (so instanceof Case) {
            if (recordTypeName == CASE_RT_MB_COMPLAINT) {
                initiateMBComplaintCase(so);
            }
            else if (recordTypeName == CASE_RT_CHRYSLER_COMPLAINT) {
                initiateChryslerComplaintCase(so);
            }
        }
        else if (so instanceof Task) {
            if (recordTypeName == TASK_RT_SMS) {
                initiateSMSTask(so);
            }
            else if (recordTypeName == TASK_RT_OB) {
                initiateOBTask(so);
            }
            else if (recordTypeName == TASK_RT_DM) {
                initiateDMTask(so);
            }
            else if (recordTypeName == TASK_RT_EDM) {
                initiateEDMTask(so);
            }
            else if (recordTypeName == 'General Task'){
                initiateGeneralTask(so);
            }
        }

        return so;
    }
    
    // Create Unsaved Dealer City
    private static void initiateDealerCity(Sobject so) {
    }

    // Create Unsaved Dealer
    private static void initiateDealer(Sobject so) {
        Account acc = (Account)so;

        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_DEALER  + accountString);
        acc.Dealer_Alternate_Name__c = 'Test Alternate';
        acc.Phone = '021000000';
        acc.Dealer_GC_Code__c = 'gc code';
        acc.Dealer_GS_Code__c = 'gs code';
        acc.Name = acc.Name == null ? 'test dealer' : acc.Name;
        acc.Dealer_MB_Sub_Region__c = acc.Dealer_MB_Sub_Region__c == null ?
            'North1' : acc.Dealer_MB_Sub_Region__c;
    }
    
	//campaignhelperth
    private static void initiateDealer1(Sobject so) {
        Account acc = (Account)so;
        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_DEALER  + accountString);
        acc.Dealer_Alternate_Name__c = 'Test Alternate';
        acc.Phone = '021000000';
        acc.Dealer_GC_Code__c = 'gc code';
        acc.Dealer_GS_Code__c = 'gs code';
        acc.Name = acc.Name == null ? 'test dealer' : acc.Name;
        acc.Dealer_MB_Sub_Region__c = acc.Dealer_MB_Sub_Region__c == null ?
            'North1' : acc.Dealer_MB_Sub_Region__c;
    
		//acc.Mobile__c='123456789012';
		// acc.Work_Phone__c='123456789012';
		acc.Individual_Home_Phone__c='+66-12-123-789';
		// acc.Email__c='abc@gmail.com';
    }
	
    // Create Unsaved Person Account
    // N.B. Name is read only for Person Account
    private static void initiatePersonAccount(Sobject so) {
        Account acc = (Account)so;

        acc.RecordTypeId = 
            getRecordTypeMapInstance().get(ACCOUNT_RT_PERSON_ACCOUNT + accountString);
        // acc.Name = testString;
        acc.LastName = 'Customer';
        acc.Type = acc.Type == null ? '0=Company' : acc.Type;
        acc.Phone = '01234567';
        acc.Area_Code__c = '010';
        acc.Status__c = acc.Status__c == null ? '0=Customer' : acc.Status__c;
    }

    // Create Unsaved Contact
    private static void initiateContact(Sobject so) {
        Contact con = (Contact)so;
        con.FirstName = 'Someone';
        con.LastName = 'Benz';
        
    }

    // Create Unsaved Vehicle
    // UsVIN__c Length must be 17, 
    // EuroVIN__c length must be 17 or 18
    private static void initiateVehicle(Sobject so ) {
        Vehicle__c vehicle = (Vehicle__c)so;

        vehicle.UsVIN__c = 'usvin111111111111'; 
        vehicle.EuroVIN__c = 'eurovin1234567890';
        vehicle.Brand__c = VEHICLE_MB;
        vehicle.Class__c = classValue;
        vehicle.Model__c = '130i';
        vehicle.Colour__c = '40 ';
        vehicle.CommissionNumber__c = '123456';
    }
    
    // Create Unsaved Vehicle Relationship
    private static void initiateVehicleRelationship(Sobject so, String recordTypeName) {
        Vehicle_Relationship__c relationship = (Vehicle_Relationship__c)so;

        relationship.RegistrationProvince__c = 'Shanghai';
        relationship.Registration_City__c = 'Shanghai';
        relationship.Status__c = '0=Previously Owned';
        relationship.Main_Usage__c = '0=Taxi';
        relationship.Ownership__c = '1=Company';
        relationship.Car_Relation__c = 'User';
        relationship.New_Used__c = '0=New';
        relationship.Validity__c = 'Unknown';
        relationship.Purchase_Date__c = System.today();
        relationship.Registration_Date__c = System.today();
        relationship.recordTypeId = getRecordTypeMapInstance().get(recordTypeName + 'Vehicle_Relationship__c');
    }

    // Create Unsaved Sales
    // If some field value are null, system will suibianly assign a value to it.
    private static void initiateSales(Sobject so) {

    }

    // Create Unsaved Aftersales
    private static void initiateAftersales(Sobject so) {

    }
    
    // Create Unsaved Car Model
    private static void initiateCarModel(Sobject so) {
        Car_Model__c carModel = (Car_Model__c)so;

        carModel.Name = carModel.Name == null ? 'test Benz' : 
           carModel.Name;
        carModel.Brand__c = VEHICLE_MB;
        carModel.Model__c = 'B200';
        carModel.Series__c = classValue;
        carModel.Description__c = 'Good Niubi Car';
    }
    
    // Create Unsaved Attribute
    private static void initiateAttribute(Sobject so) {
        Attribute__c attr = (Attribute__c)so;

        attr.Name = attr.Name == null ? 'Market price' : attr.Name;
        attr.Attribute_Category__c = attr.Attribute_Category__c == null ?
           'Basic parameters' : attr.Attribute_Category__c;
        attr.Attribute_Type__c = attr.Attribute_Type__c == null ? 
           'Price' : attr.Attribute_Type__c;
        attr.Description__c = 'Niubi Attribute';
    }

    // Create Unsaved Car Model Attribute
    private static void initiateCarModelAttribute(Sobject so) {
        Car_Model_Attribute__c carModelAttr = (Car_Model_Attribute__c)so;

        carModelAttr.Attribute__c = carModelAttr.Attribute__c == null ?
           createSobject(new Attribute__c(), null).Id : carModelAttr.Attribute__c;
        
        carModelAttr.Car_Model__c = carModelAttr.Car_Model__c == null ?
           createSobject(new Car_Model__c(), null).Id : carModelAttr.Car_Model__c;
        
        carModelAttr.Value__c = '1000000';
        carModelAttr.Description__c = 'Really expensive Ah, Yes, well ... ... Ah';
    }
    
    // Create Unsaved Lead which record type is Sales Leads
    private static void initiateSalesLead(Sobject so) {
        Lead__c lead = (Lead__c)so;

        lead.Contact__c = lead.Contact__c == null ? 
           createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id : 
           lead.Contact__c;
        
        lead.CAC_Lead_Status__c = lead.CAC_Lead_Status__c == null ? 
            'Qualified' : lead.CAC_Lead_Status__c;

        lead.Lead_Type__c = 'New Car';
        lead.Lead_Desired_Service__c = 'Test Drive;Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';

        // Interested Vehicle Information
        lead.Interested_Vehicle_Brand__c = lead.Interested_Vehicle_Brand__c == null ? 
           VEHICLE_MB : lead.Interested_Vehicle_Brand__c;
        lead.Interested_Vehicle_Class__c = lead.Interested_Vehicle_Class__c == null ? 
           classValue : lead.Interested_Vehicle_Class__c;
        lead.Interested_Vehicle_Model__c = lead.Interested_Vehicle_Model__c == null ? 
           'A160' : lead.Interested_Vehicle_Model__c;

        // Trade-In Vehicle Information
        lead.Trade_In_MB_Vehicle_Model__c = lead.Trade_In_MB_Vehicle_Model__c == null ? 
           'Mercedes-Benz cars' : lead.Trade_In_MB_Vehicle_Model__c;
        lead.Trade_In_Vehicle_Brand__c = lead.Trade_In_Vehicle_Brand__c == null ? 
           'C230' : lead.Trade_In_Vehicle_Brand__c;
        lead.Trade_In_Vehicle_Class__c = lead.Trade_In_Vehicle_Class__c == null ? 
           'C-CLASS' : lead.Trade_In_Vehicle_Class__c;
        lead.Trade_In_Other_Vehicle_Model__c = lead.Trade_In_Other_Vehicle_Model__c == null ? 
           'other model' : lead.Trade_In_Other_Vehicle_Model__c;

        lead.Bought_Vehicle_Brand__c = VEHICLE_MB;
        lead.Bought_Vehicle_Class__c = classValue;
        lead.Bought_Vehicle_Model__c = 'A160';
    }
    
    // Create Unsaved Campaign Lead which Lead__c
    private static void initiateCampaignLead(Sobject so) {
        Campaign_Lead__c campaignLead = (Campaign_Lead__c)so;

        campaignLead.Lead__c = campaignLead.Lead__c == null ? 
           createSobject(new Lead__c(), LEAD_RT_SALES_LEADS).Id : campaignLead.Lead__c;
           
        campaignLead.Campaign__c = campaignLead.Campaign__c == null ? 
           createSobject(new Campaign(), CAMPAIGN_RT_CAMPAIGN_EXECUTION).Id : 
           campaignLead.Campaign__c;

        campaignLead.Lead_Source__c = 'Dealer';
        campaignLead.Lead_InfoSource__c = 'Event';
    }
    
    // Create Unsaved Campaign Members
    private static void initiateCampaignMember(Sobject so) {
        CampaignMember member = (CampaignMember)so;
        member.CampaignId = member.CampaignId == null ? 
            createSobject(new Campaign(), CAMPAIGN_RT_CAMPAIGN_EXECUTION).Id :
            member.CampaignId;

        // We need to get PersonContactId by PersonAccountId
        if (member.ContactId == null){
            Account personAccount = (Account)createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT);
            personAccount = [SELECT Id, PersonContactId 
                             FROM Account WHERE Id = :personAccount.Id];
            member.ContactId = personAccount.PersonContactId;
        }

        member.Status = 'Sent';
        member.Registration_Notes__c = member.Registration_Notes__c == null ?
            'Test Registration Notes': member.Registration_Notes__c;
    }

    // CampaignMemberStatus is a strange thing, you know that.
    // So we need zhe mo zuo
    public static void createCampaignMemberStatus(Campaign cam) {
        List<CampaignMemberStatus> cmsToInsert = new List<CampaignMemberStatus>();
        CampaignMemberStatus cms2 = new CampaignMemberStatus(
            CampaignId = cam.Id,
            Label = 'Lead',
            HasResponded = true,
            IsDefault = false,
            SortOrder = 4
        );
                                                             
        CampaignMemberStatus cms3 = new CampaignMemberStatus(
            CampaignId = cam.Id,
            Label = 'Participated',
            HasResponded = true,
            IsDefault = false,
            SortOrder = 5
        );    
                                                                                                                                        
        CampaignMemberStatus cms4 = new CampaignMemberStatus(
            CampaignId = cam.Id,
            Label = 'Registered',
            HasResponded = true,
            IsDefault = false,
            SortOrder = 6
        );
                                                             
        CampaignMemberStatus cms5 = new CampaignMemberStatus(
            CampaignId = cam.Id,
            Label = 'Failed/No Response',
            HasResponded = true,
            IsDefault = false,
            SortOrder = 7
        );
        cmsToInsert.addAll(new List<CampaignMemberStatus> {cms2, cms3, cms4, cms5});
        insert cmsToInsert;
    }

    // Create Unsaved Campaign which record type is Campaign Execution
    private static void initiateCampaignExecution(Sobject so) {
        Campaign cam = (Campaign)so;

        Id campaignExecutionRecordTypeId = 
           getRecordTypeMapInstance().get(CAMPAIGN_RT_CAMPAIGN_EXECUTION + 'Campaign');
        cam.RecordTypeId = campaignExecutionRecordTypeId;
        
        cam.ParentId = cam.ParentId == null ? 
            createSobject(new Campaign(), CAMPAIGN_RT_CAC_CAMPAIGN).Id : cam.ParentId;

        cam.Name = 'Test Campaign Execution';
        cam.Campaign_Code__c = String.valueOf(Math.rint(Math.random() * 10000000));
        cam.Execution_Type__c = 'OB Call';
    }
    
    // Create Unsaved Campaign which record type is CAC Campaign
    private static void initiateCACCampaign(Sobject so) {
        Campaign cam = (Campaign)so;

        Id cacCampaignRecordTypeId = 
           getRecordTypeMapInstance().get(CAMPAIGN_RT_CAC_CAMPAIGN + 'Campaign');
        cam.RecordTypeId = cacCampaignRecordTypeId;

        cam.ParentId = cam.ParentId == null ? 
            createSobject(new Campaign(), CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN).Id : 
            cam.ParentId;

        cam.Name = 'Test CAC Campaign';
        cam.Campaign_Code__c = String.valueOf(Math.rint(Math.random() * 10000000));

        cam.Task_De_dup_by__c = cam.Task_De_dup_by__c == null ?
            'Account' : cam.Task_De_dup_by__c;
        cam.Task_De_dup_Range__c = cam.Task_De_dup_Range__c == null ?
            'By CAC Campaign' : cam.Task_De_dup_Range__c;
    }
    
    // Create Unsaved Campaign which record type is Central Marketing Campaign
    private static void initiateCentralMKTCampaign(Sobject so) {
        Campaign cam = (Campaign)so;

        Id centralMKTCampaignRecordTypeId = 
           getRecordTypeMapInstance().get(CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN + 'Campaign');
        cam.RecordTypeId = centralMKTCampaignRecordTypeId;

        cam.Name = 'Test Central MKT Campaign';
        cam.Campaign_Code__c = String.valueOf(Math.rint(Math.random() * 10000000));

        cam.Type = 'CRM Acquisition Program';
        cam.Status = 'Planned';
        cam.Campaign_Objectives__c = 'na many many danzi';
        cam.Description = 'na de yue more yue good';
        cam.StartDate = System.today();
        cam.EndDate = System.today() + 10;
    }

    // Create Unsaved Participating Dealer (Just CAC Marketing Campaign has)
    private static void initiateParticipatingDealer(Sobject so) {
        Participating_Dealer__c partDealer = (Participating_Dealer__c)so;

        partDealer.Campaign__c = partDealer.Campaign__c == null ?
            createSobject(new Campaign(), CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN).Id :
            partDealer.Campaign__c;

        partDealer.Dealer__c = partDealer.Dealer__c == null ?
            createSobject(new Account(), ACCOUNT_RT_DEALER).Id :
            partDealer.Dealer__c;

        partDealer.Campaign_Package__c = partDealer.Campaign_Package__c == null ?
            createSobject(new Campaign_Package__c(), null).Id :
            partDealer.Campaign_Package__c;

        partDealer.Session_Start_Date__c = System.today();
        partDealer.Session_End_Date__c = System.today() + 10;
    }

    // Create Unsaved Campaign Package (Just CAC Marketing Campaign has)
    private static void initiateCampaignPackage(Sobject so) {
        Campaign_Package__c camPackage = (Campaign_Package__c)so;

        camPackage.Campaign__c = camPackage.Campaign__c == null ?
            createSobject(new Campaign(), CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN).Id :
            camPackage.Campaign__c;

        camPackage.Name = camPackage.Name == null ?
            'Test Campaign Package': camPackage.Name;
        camPackage.Package_Description__c = camPackage.Package_Description__c == null ?
            'hao bao ya' : camPackage.Package_Description__c;
    }

    // Create unsaved Campaign Offering(Detail Object of Campaign)
    private static void initateCampaignOffering(Sobject so) {
        Campaign_Offering__c offering = (Campaign_Offering__c)so;

        offering.Campaign__c = offering.Campaign__c == null ?
            createSobject(new Campaign(), CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN).Id :
            offering.Campaign__c;

        offering.Description__c = 'Can I bu miao shu ma?';
        offering.Start_Date__c = System.today();
        offering.End_date__c = System.today() + 5;
    }

    // Create Unsaved Package_Item__c(The detail object of Campaign Offering and Campaign Package)
    private static void initiatePackageItem(Sobject so) {
        Package_Item__c packageItem = (Package_Item__c)so;

        packageItem.Offering__c = packageItem.Offering__c == null ?
            createSobject(new Campaign_Offering__c(), null).Id :
            packageItem.Offering__c;

        packageItem.Package_Name__c = packageItem.Package_Name__c == null ?
            createSobject(new Campaign_Package__c(), null).Id :
            packageItem.Package_Name__c;

        packageItem.Unique_ID__c = String.valueOf(Math.rint(Math.random() * 1000000));
    }

    // Create Unsaved Outbound_Email__c
    private static void initiateOutboundEmail(Sobject so) {

    }

    // Create Unsaved Attachment
    private static void initiateAttachment(Sobject so) {
        Attachment att = (Attachment)so;

        // att.ParentId is populated before
        att.Description = 'Description';
        att.Name = testString;
        att.Body = Blob.valueOf(testString);
    }

    // Create Unsaved MB Complaint Case
    private static void initiateMBComplaintCase(sobject so) {
        Case ca = (Case)so;

        ca.RecordTypeId = getRecordTypeMapInstance().get(CASE_RT_MB_COMPLAINT + 'Case');
        ca.AccountId = ca.AccountId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            ca.AccountId;

        ca.Complaint_Date__c = System.today();
    }

    // Create Unsaved Chrysler Complaint Case
    private static void initiateChryslerComplaintCase(sobject so) {
        Case ca = (Case)so;

        ca.RecordTypeId = getRecordTypeMapInstance().get(CASE_RT_CHRYSLER_COMPLAINT + 'Case');
        ca.AccountId = ca.AccountId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            ca.AccountId;

        ca.Complaint_Date__c = System.today();
        ca.Case_Type__c = 'After-Sales';
        ca.Case_SubType__c = 'Fire or Gasbag Case';
        ca.Dealer_Contact__c = 'Yes';
        ca.Status = 'Wating for Reply';
        ca.Priority = 'Green-less than twice';
    }

    // Create SMS Task
    private static void initiateSMSTask(Sobject so) {
        Task task = (Task)so;
        task.RecordTypeId = getRecordTypeMapInstance().get(TASK_RT_SMS + taskString);
        task.Subject = testString;
        task.WhatId = task.WhatId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            task.WhatId;

        task.Activity_Status__c = task.Activity_Status__c == null ?
            'Need Verification' : task.Activity_Status__c;
        task.Status = openStatus;
        task.Priority__c = generalPriority;
    }

    // Create OB Task
    private static void initiateOBTask(Sobject so) {
        Task task = (Task)so;
        task.RecordTypeId = getRecordTypeMapInstance().get(TASK_RT_OB + taskString);
        task.Subject = testString;
        task.WhatId = task.WhatId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            task.WhatId;

        task.Activity_Status__c = task.Activity_Status__c == null ?
            'not started' : task.Activity_Status__c;
        task.Status = openStatus;
        task.Priority__c = generalPriority;
    }

    // Create DM Task
    private static void initiateDMTask(Sobject so) {
        Task task = (Task)so;
        task.RecordTypeId = getRecordTypeMapInstance().get(TASK_RT_DM + taskString);
        task.Subject = testString;
        task.WhatId = task.WhatId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            task.WhatId;

        task.Activity_Status__c = task.Activity_Status__c == null ?
            openStatus : task.Activity_Status__c;
        task.Status = openStatus;
        task.Priority__c = generalPriority;
    }

    // Create eDM Task
    private static void initiateEDMTask(Sobject so) {
        Task task = (Task)so;
        task.RecordTypeId = getRecordTypeMapInstance().get(TASK_RT_EDM + taskString);
        task.Subject = testString;
        task.WhatId = task.WhatId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            task.WhatId;

        task.Activity_Status__c = task.Activity_Status__c == null ?
            'Pending' : task.Activity_Status__c;
        task.Status = openStatus;
        task.Priority__c = generalPriority;
    }
    
    //Create General Task
    private static void initiateGeneralTask(Sobject so) {
        Task task = (Task)so;
        task.RecordTypeId = getRecordTypeMapInstance().get('General Task'+ taskString);
        task.Subject = testString;
        task.WhatId = task.WhatId == null ?
            createSobject(new Account(), ACCOUNT_RT_PERSON_ACCOUNT).Id :
            task.WhatId;

        task.ActivityDate = System.today().addDays(-1);
        task.Activity_Status__c = task.Activity_Status__c == null ?
            'Pending' : task.Activity_Status__c;
        task.Status = openStatus;
        task.Priority__c = generalPriority;
    }
    
    public static Campaign dataPreparation(){
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();  
        // Central Campaign
        Id centCampaignRT = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();                 
        // Centre Campaign Data Prepared
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=centCampaignRT);  
        insert TestData_CCA;
        return TestData_CCA;
    }
}