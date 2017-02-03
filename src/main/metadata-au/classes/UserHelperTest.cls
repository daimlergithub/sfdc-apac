@isTest(seeAllData=false)
public class UserHelperTest
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Vehicle__c vehicle; 
    public static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();
    public static String retailSalesleadRecordTypeID = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();
    public static Set<Id> existUserIds = new Set<Id>();
    public static map<id,User> userOldMap = new map<id,User>();
    public static List<Profile> lstProfiles = new List<profile>();
    public static List<user> usersList = new List<user>();
    public static Contact con ;
    public static Account dealer;
    public static user usr;
    public static boolean isInsert = true;
    public static boolean isUpdate = false;
    public static profile DealerDelegatedAdmin;
    public static profile DealerCommunityUser;
    public static Profile CACSSICSR = [select Id from Profile where Name = 'CAC SSI CSR'];
    public static Profile CACSSIQC = [select Id from Profile where Name = 'CAC SSI QC'];
   
    public static Campaign cmpAs;
    public static Campaign cmpSm;
    public static Campaign cmpMb;
    Public Static Tool_Kit__c toolKit;
    public static Lead__c testLead;
    public static Lead__c testLead2;
    public static Case aCase;
    public static Retail_Task__c contract;
    public static Account_Link__c externalLink;
    public static Task task;
    public static Vehicle_Relationship__c vehicleRs;
    public static String Read = 'Read';
    public static String Edit = 'Edit';
    static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId(); 
    public static Id C_MB_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.MB_COMPLAINT).getRecordTypeId();
    
   
    
     
    
     
    
    
    public static testmethod void ShareVehicleToNewUser_test()
    {
         //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {   
        
       test.startTest();
       createTestData();  
       userHelper.ShareVehicleRelationToNewUser(usr.id, existUserIds);
       Vehicle_Relationship__Share vrShare =  [select AccessLevel from Vehicle_Relationship__Share where ParentId =:vehicleRs.id and UserOrGroupId =:usr.id limit 1];       userHelper.ShareVehicleToNewUser(usr.id, existUserIds);
       test.stopTest();
       Vehicle__Share vhShare = [select AccessLevel from Vehicle__Share where ParentId =:vehicle.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,vhShare.AccessLevel) ;
       system.assertEquals(Read,vrShare.AccessLevel) ;
    }   
    
    }
    
    
    public static testmethod void ShareAccountLinkToNewUser_test()
    {
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
       createTestData();
       userHelper.ShareRetailLeadsToNewUser(usr.id, existUserIds);
       Lead__Share testLeadshare = [select AccessLevel from Lead__Share where ParentId =:testLead.id and UserOrGroupId =:usr.id limit 1];
         
       userHelper.ShareAccountLinkToNewUser(usr.id, existUserIds);
       test.stopTest();
       Account_Link__Share Alshare = [select AccessLevel from Account_Link__Share where ParentId =:externalLink.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,Alshare.AccessLevel) ; 
       system.assertEquals(Edit,testLeadShare.AccessLevel) ;
    }   
    }    
    
    public static testmethod void ShareRetailTaskToNewUser_test()
    {
        
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
       createTestData();
        
       userHelper.ShareRetailTaskToNewUser(usr.id, existUserIds);
       userHelper.ShareLeadsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Task__Share Rtshare  =  [select AccessLevel from Retail_Task__Share where ParentId =:contract.id and UserOrGroupId =:usr.id limit 1];
       
       Lead__Share testLeadshare = [select AccessLevel from Lead__Share where ParentId =:testLead.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testLeadShare.AccessLevel) ;
       system.assertEquals(Read,Rtshare.AccessLevel) ; 
    }   
    
  
    }
    
    
    
    public static testmethod void ShareAsRecordsToNewUser_test()
    {
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
        
       test.startTest();
        createTestData();
        Retail_Campaign__c retCamAs = new Retail_Campaign__c();
        retCamAs.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
        retCamAs.Dealer_Name__c = dealer.id;
        insert retCamAs;
        
        Retail_Campaign__Share retCamAsShare = new Retail_Campaign__Share();
        retCamAsShare.ParentId = retCamAs.id;
        retCamAsShare.UserOrGroupId = usr.id;
        retCamAsShare.AccessLevel = Edit;
        insert retCamAsShare;
      
        
        
       userHelper.ShareAsRecordsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share  testRetCamAsShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamAs.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testRetCamAsShare.AccessLevel) ; 
    }   
    }
    
    public static testmethod void ShareAsYearlyTAToNewUser_test()
    {
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
        createTestData();
        Retail_Campaign__c retCamSm = new Retail_Campaign__c();
        retCamSm.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        retCamSm.Dealer_Name__c = dealer.id;
        insert retCamSm;
        
        Retail_Campaign__Share retCamSmShare = new Retail_Campaign__Share();
        retCamSmShare.ParentId = retCamSm.id;
        retCamSmShare.UserOrGroupId = usr.id;
        retCamSmShare.AccessLevel = Edit;
        insert retCamSmShare;
       
        
       userHelper.ShareSmYearlyTAToNewUser(usr.id, existUserIds);
       
       Retail_Campaign__Share  testRetCamSmShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamSm.id and UserOrGroupId =:usr.id limit 1];
       
        
        Retail_Campaign__c retCamAsY = new Retail_Campaign__c();
        retCamAsY.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
        retCamAsY.Dealer_Name__c = dealer.id;
        insert retCamAsY;
        
        Retail_Campaign__Share retCamAsYShare = new Retail_Campaign__Share();
        retCamAsYShare.ParentId = retCamAsY.id;
        retCamAsYShare.UserOrGroupId = usr.id;
        retCamAsYShare.AccessLevel = Edit;
        insert retCamAsYShare;
       
        
       userHelper.ShareAsYearlyTAToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share  testRetCamAsYShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamAsY.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testRetCamAsYShare.AccessLevel) ;
        system.assertEquals(Edit,testRetCamSmShare.AccessLevel) ;
        
    }   
    
    }  
    
    public static testmethod void ShareSmRecordsToNewUser_test()
    {
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
        
       test.startTest();
        createTestData();
        Retail_Campaign__c retCamMb = new Retail_Campaign__c();
        retCamMb.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId();
        retCamMb.Dealer_Name__c = dealer.id;
        insert retCamMb;
        
        Retail_Campaign__Share retCamMbShare = new Retail_Campaign__Share();
        retCamMbShare.ParentId = retCamMb.id;
        retCamMbShare.UserOrGroupId = usr.id;
        retCamMbShare.AccessLevel = Edit;
        insert retCamMbShare;
      
        
       userHelper.ShareRetailBestPracticeToNewUser(usr.id, existUserIds);
       
       Retail_Campaign__Share  testRetCamMbShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamMb.id and UserOrGroupId =:usr.id limit 1];
        
        Retail_Campaign__c retCamSmEr = new Retail_Campaign__c();
        retCamSmEr.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        retCamSmEr.Dealer_Name__c = dealer.id;
        insert retCamSmEr;
        
        Retail_Campaign__Share retCamSmErShare = new Retail_Campaign__Share();
        retCamSmErShare.ParentId = retCamSmEr.id;
        retCamSmErShare.UserOrGroupId = usr.id;
        retCamSmErShare.AccessLevel = Edit;
        insert retCamSmErShare;
       
        
       userHelper.ShareSmRecordsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share  testRetCamSmErShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamSmEr.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testRetCamSmErShare.AccessLevel) ; 
       system.assertEquals(Edit,testRetCamMbShare.AccessLevel) ;
    }   
    
    } 
   
    
    public static testmethod void ShareAsCampaignToNewUser_test()
    {
        
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
       createTestData();        
       userHelper.ShareAsCampaignToNewUser(usr.id, existUserIds);
       userHelper.ShareSmCampaignToNewUser(usr.id, existUserIds);
       test.stopTest();
       CampaignShare TestShareSm = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpSm.id and UserOrGroupId =:usr.id limit 1];
       system.assertNotEquals(null, TestShareSm.CampaignAccessLevel) ; 
       CampaignShare TestShareAs = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpAs.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,TestShareAs.CampaignAccessLevel) ;
    }  
    
    }    
    
    public static testmethod void ShareBestPracticeToNewUser_test()
    {
        
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
       createTestData();     
       userHelper.ShareBestPracticeToNewUser(usr.id, existUserIds);
  
       CampaignShare TestShareBp = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpMb.id and UserOrGroupId =:usr.id limit 1];
       
       userHelper.ShareToolKitToNewUser(usr.id, existUserIds);
       test.stopTest();
       Tool_Kit__Share shareTk =  [select AccessLevel from Tool_Kit__Share where ParentId =: toolKit.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,shareTk.AccessLevel) ;
       system.assertNotEquals(null, TestShareBp.CampaignAccessLevel) ;
    }  
    
    }   
    
   
    public static testmethod void updateContact_test()
    {
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      { 
       test.startTest();
       createTestData();
        
       userHelper.ShareCaseToNewUser(usr.id, existUserIds);
       userHelper.AssignPermissionSetForPortalUser(existUserIds);
       userHelper.ShareAllDataToNewUser(dealer.id, usr.id, DealerDelegatedAdmin.id);
       userHelper.ValidateUser(usersList); 
       userHelper.updateContact(con.id, true);
       
       test.stopTest();
       List<Contact> cons =  [select Id,Portal_user__c from Contact where Id = :con.id ];
       system.assertEquals(true,cons[0].Portal_user__c) ;
        
    }   
    
    }
   
    public static testmethod void AfterInsert_UpdateMethod()
    {
         if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
         {
             test.startTest();
       		 createTestData();
             userOldMap.putAll(usersList);             
             userHelper.AfterInsert_UpdateMethod(usersList, userOldMap, isInsert, isUpdate);
             test.stopTest();
             List<Contact> cons =  [select Id,Portal_user__c from Contact where Id = :con.id ];
       		 system.assertEquals(true,cons[0].Portal_user__c) ;
         }                 
        
    }   
  
    
    public Static  void createTestData()
    {
         DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Delegate Admin' limit 1];
        // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
      
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', Salutation='Attorney',FirstName='testFirstname',LastName = 'testLastname', Phone = '123', email = 's@s.s');
        con.Portal_User__c = true;
        con.CanAllowPortalSelfReg = true;
        insert con;
 
        // profiles
        
        
        
        //create user  
        
        usr = new User(
            Username = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty3',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        usr.ContactId = con.id;
        insert usr;
       
          //  Insert person Account 
        Account person = new Account(
            RecordTypeId = personRecordtypeid,
            PersonMobilePhone = '1861001001',
            FirstName = 'First',
            LastName = 'Last',
            PersonEmail = 'test@test.com',
            Salutation = 'Unknown'
        );
        person.Home_Phone_2__c ='1243';
        person.Email__c = 'hs@gsad.com';
        person.Email2__c = 'ywfhedw@gsc.com';
        person.Phone ='476';
        insert person;
        
        // Insert a Case 
        
        aCase = new Case(
            Subject = 'XX',
            RecordTypeId = C_MB_RECORD_TYPE,
            AccountId = person.Id,
            Case_Class__c = 'Pre-Sales',
            Car_Type__c = 'Dealer contact method',
            Case_SubType__c = 'Dealership Contacts',
            Case_Dealer__c = dealer.id,
            Status = 'Open'
        );
        insert aCase;
        
        
        
        // Insert a Task 
       
        task = new Task(Subject= 'SMS', 
                RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId(),
                Activity_Status__c = 'Need Verification',
                Phone__c = '18611445766',
                WhatId = aCase.id,
                ActivityDate = date.today(),
                SMS_Content__c = 'testaaa',
                ownerId = usr.id);
        insert task;
     
        vehicle = new Vehicle__c();
        insert vehicle; 
        
        Vehicle__Share vehicleShare = new Vehicle__Share();
        vehicleShare.AccessLevel = Read;
        vehicleShare.ParentId = vehicle.id;
        vehicleShare.UserOrGroupId = usr.id;
        insert vehicleShare;
       // create an Account Link
       
         externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        insert externalLink;
        Account_Link__Share alShare = new Account_Link__Share();
        alshare.ParentId = externalLink.id;
        alshare.UserOrGroupId = usr.id;
        alshare.AccessLevel = Read;
        insert alShare;
        
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;
        
        Retail_Task__Share rtShare = new Retail_Task__Share();
        rtShare.ParentId = contract.id;
        rtShare.UserOrGroupId = usr.id;
        rtShare.AccessLevel = Edit;
        insert rtShare;
        
            testLead = new Lead__c();
            
            testLead.Assigned_Dealer__c = dealer.id;
            testLead.Contact__c = person.id;
            testLead.Company_Account__c = dealer.id;
            testLead.RecordTypeId = afterSalesRecordTypeId;
            insert testLead;
        
        Lead__Share Leadshare = new Lead__Share();
        Leadshare.ParentId = testLead.id;
        Leadshare.UserOrGroupId = usr.id;
        Leadshare.AccessLevel = Edit;
         insert Leadshare;
        
            testLead2 = new Lead__c();
            testLead2.Assigned_Dealer__c = dealer.id;
            testLead2.Contact__c = person.id;
            testLead.Company_Account__c = dealer.id;
            testLead2.RecordTypeId = retailSalesleadRecordTypeID;
            insert testLead2;
        
        Lead__Share LeadShareRet = new Lead__Share();
        LeadShareRet.ParentId = testLead.id;
        LeadShareRet.UserOrGroupId = usr.id;
        LeadShareRet.AccessLevel = Edit;
        insert LeadShareRet;
        
        vehicleRs = new Vehicle_Relationship__c();
        vehicleRs.RecordTypeId = VRRecordTypeId;
        vehicleRs.Recall__c = false;
        vehicleRs.Contact__c = person.id;
        
        vehicleRs.Owner_Dealer__c = dealer.id;
        vehicleRs.Vehicle_ID__c = vehicle.id;
        insert vehicleRs;
        
        Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
        vrShare.ParentId = vehicleRs.id;
        vrShare.UserOrGroupId = usr.id;
        vrShare.AccessLevel = Edit;
        insert vrShare;
        
             
            cmpAs = new Campaign();
            cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
            cmpAs.IsActive = true;
            cmpAs.Name = 'cmpAs';
            cmpAs.Status = 'Started'; 
            cmpAs.StartDate = System.today();
            cmpAs.EndDate = System.today();
            insert cmpAs;
      
        CampaignShare cmpAsShare = new CampaignShare();
        cmpAsShare.CampaignId = cmpAs.id;
        cmpAsShare.UserOrGroupId = usr.id;
        cmpAsShare.CampaignAccessLevel = Edit;
        insert cmpAsShare;
      
        
         cmpSm = new Campaign();
        cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
            cmpSm.Status = 'Started';
            //cmpSm.IsActive = true;
            cmpSm.Name = 'cmpSm';
            
            cmpSm.StartDate = System.today(); 
            cmpSm.EndDate = System.today();
            insert cmpSm;
         
        
        
        
        CampaignShare cmpSmShare = new CampaignShare();
        cmpSmShare.CampaignId = cmpSm.id;
        cmpSmShare.UserOrGroupId = usr.id;
        cmpSmShare.CampaignAccessLevel = Edit;
        insert cmpSmShare;
        
        
         cmpMb = new Campaign();
        cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            //cmpMb.IsActive = true; 
            cmpMb.Name = 'cmpMb'; 
            cmpMb.Status = 'Started'; 
            cmpMb.StartDate = System.today(); 
            cmpMb.EndDate = System.today();
            insert cmpMb;
        
        CampaignShare cmpMbShare = new CampaignShare();
        cmpMbShare.CampaignId = cmpMb.id;
        cmpMbShare.UserOrGroupId = usr.id;
        cmpMbShare.CampaignAccessLevel = Edit;
        insert cmpMbShare;
        
        toolKit = new Tool_Kit__c();
        toolKit.RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
        toolKit.Dealer_Name__c = dealer.id;
        insert toolKit;
        
        Tool_Kit__Share toolKitshare = new Tool_Kit__Share();
        toolKitshare.ParentId = toolKit.id;
        toolKitshare.UserOrGroupId = usr.id;
        toolKitshare.AccessLevel = Edit;
        insert toolKitshare;
        
        
        
        existUserIds.add(usr.id);
        
        lstProfiles.add(DealerDelegatedAdmin);
        lstProfiles.add(CACSSICSR);
        lstProfiles.add(CACSSIQC);        
		usersList.add(usr);        
        UserHelper ush = new userHelper();
     
    }
    
    
    
}