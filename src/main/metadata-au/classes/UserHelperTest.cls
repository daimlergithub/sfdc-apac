@isTest(seeAllData=true)
public class UserHelperTest
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Vehicle__c vehicle; 
    public static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ExternalLink').getRecordTypeId();
    public static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    public static String retailSalesleadRecordTypeID = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();
    public static Set<Id> existUserIds = new Set<Id>();
    public static List<Profile> lstProfiles = new List<profile>();
    public static List<user> usersList = new List<user>();
    public static Contact con ;
    public static Account dealer;
    public static user usr;
    public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Delegate Admin'];
    public static Profile CACSSICSR = [select Id from Profile where Name = 'CAC SSI CSR'];
    public static Profile CACSSIQC = [select Id from Profile where Name = 'CAC SSI QC'];
    public static Profile portalUserProf = [select Id from Profile where Name = 'Dealer Delegate Admin'];
    
    
    public static testmethod void ValidateUser_test()
    {
       //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {   
         test.startTest();
         createTestData();
         userHelper.ValidateUser(usersList);
         test.stopTest();
      }
    }
    
     public static testmethod void updateContact_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.updateContact(con.id, true);
         test.stopTest();
      }
    }   
    
     public static testmethod void ShareAllDataToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareAllDataToNewUser(dealer.id, usr.id, DealerDelegatedAdmin.id);
         test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareVehicleToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareVehicleToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareVehicleRelationToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareVehicleRelationToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    } 
    
    public static testmethod void ShareAccountLinkToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareAccountLinkToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareRetailTaskToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareRetailTaskToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   
    
    public static testmethod void ShareCaseToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareCaseToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   

    public static testmethod void ShareLeadsToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareLeadsToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   
    
    public static testmethod void ShareRetailLeadsToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareRetailLeadsToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareAsRecordsToNewUser_test()
    {
      //Added community license switching mechanism
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
          retCamAsShare.AccessLevel = 'Edit';
          insert retCamAsShare;
          userHelper.ShareAsRecordsToNewUser(usr.id, existUserIds);
          test.stopTest();
      }
    }   
    
    public static testmethod void ShareAsYearlyTAToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
          test.startTest();
          createTestData();
          Retail_Campaign__c retCamAsY = new Retail_Campaign__c();
          retCamAsY.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
          retCamAsY.Dealer_Name__c = dealer.id;
          insert retCamAsY;
          
          Retail_Campaign__Share retCamAsYShare = new Retail_Campaign__Share();
          retCamAsYShare.ParentId = retCamAsY.id;
          retCamAsYShare.UserOrGroupId = usr.id;
          retCamAsYShare.AccessLevel = 'Edit';
          insert retCamAsYShare;
          userHelper.ShareAsYearlyTAToNewUser(usr.id, existUserIds);
          test.stopTest();
      }
    }   
    
    public static testmethod void ShareSmYearlyTAToNewUser_test()
    {
      //Added community license switching mechanism
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
          retCamSmShare.AccessLevel = 'Edit';
          insert retCamSmShare;
          userHelper.ShareSmYearlyTAToNewUser(usr.id, existUserIds);
          test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareSmRecordsToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
          test.startTest();
          createTestData();
          Retail_Campaign__c retCamSmEr = new Retail_Campaign__c();
          retCamSmEr.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
          retCamSmEr.Dealer_Name__c = dealer.id;
          insert retCamSmEr;
          
          Retail_Campaign__Share retCamSmErShare = new Retail_Campaign__Share();
          retCamSmErShare.ParentId = retCamSmEr.id;
          retCamSmErShare.UserOrGroupId = usr.id;
          retCamSmErShare.AccessLevel = 'Edit';
          insert retCamSmErShare;
          userHelper.ShareSmRecordsToNewUser(usr.id, existUserIds);
          test.stopTest();
      }
    }   
    
    
    public static testmethod void ShareRetailBestPracticeToNewUser_test()
    {
      //Added community license switching mechanism
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
           retCamMbShare.AccessLevel = 'Edit';
           insert retCamMbShare;
           userHelper.ShareRetailBestPracticeToNewUser(usr.id, existUserIds);
           test.stopTest();
      }
    }  
    
    public static testmethod void ShareAsCampaignToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareAsCampaignToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }  
    
    public static testmethod void ShareSmCampaignToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareSmCampaignToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }  
    
    public static testmethod void ShareBestPracticeToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareBestPracticeToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }  
    
    public static testmethod void ShareToolKitToNewUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareToolKitToNewUser(usr.id, existUserIds);
         test.stopTest();
      }
    }  
    
    public static testmethod void AssignPermissionSetForPortalUser_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {  
         test.startTest();
         createTestData();
         userHelper.AssignPermissionSetForPortalUser(existUserIds);
         test.stopTest();
      }
    }  
    
    public static testmethod void ShareAllDataToNewUserFuture_test()
    {
      //Added community license switching mechanism
      if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
      {
         test.startTest();
         createTestData();
         userHelper.ShareAllDataToNewUserFuture(usr.id, existUserIds, DealerDelegatedAdmin.id);
         test.stopTest();
      }
    }  
    
    
    public Static  void createTestData()
    {
        
        // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        // profiles
        
        
        
        //create user  
        
        usr = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            contactid=con.id,
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        insert usr;
        //  Insert person Account 
        
        Account person = new Account(
            RecordTypeId = personRecordtypeid,
            PersonMobilePhone = '1861001001',
            FirstName = 'First',
            LastName = 'Last',
            PersonEmail = 'test@test.com'
        );
        insert person;
        
        // Insert a Case 
        
        Case aCase = new Case(
            Subject = 'XX',
            AccountId = person.Id,
            Case_Class__c = 'Pre-Sales',
            Car_Type__c = 'Dealer contact method',
            Case_SubType__c = 'Dealership Contacts',
            Case_Dealer__c = dealer.id,
            Status = 'Open'
        );
        insert aCase;
        
        /*Id teamRoleId = [select Id from CaseTeamRole where Name = 'After-sales team' limit 1].id;
        caseTeamMember cstm = new caseTeamMember();
        cstm.MemberId = usr.id;
        cstm.ParentId = aCase.id;
        cstm.TeamRoleId = teamRoleId;
        insert cstm;*/
        
        // Insert a Task 
       
        Task task = new Task(
                Subject= 'SMS', 
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
        vehicleShare.AccessLevel = 'Read';
        vehicleShare.ParentId = vehicle.id;
        vehicleShare.UserOrGroupId = usr.id;
        insert vehicleShare;
       // create an Account Link
       
        Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'DealerCode', Vehicle__c = vehicle.Id);
        insert externalLink;
        Account_Link__Share alShare = new Account_Link__Share();
        alshare.ParentId = externalLink.id;
        alshare.UserOrGroupId = usr.id;
        alshare.AccessLevel = 'Read';
        insert alShare;
        
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;
        
        Retail_Task__Share rtShare = new Retail_Task__Share();
        rtShare.ParentId = contract.id;
        rtShare.UserOrGroupId = usr.id;
        rtShare.AccessLevel = 'Edit';
        insert rtShare;
        
        Lead__c testLead = new Lead__c();
            
            testLead.Assigned_Dealer__c = dealer.id;
            //testLead.Contact__c = con.id;
            testLead.RecordTypeId = afterSalesRecordTypeId;
            insert testLead;
        
        Lead__Share Leadshare = new Lead__Share();
        Leadshare.ParentId = testLead.id;
        Leadshare.UserOrGroupId = usr.id;
        Leadshare.AccessLevel = 'Edit';
         insert Leadshare;
        
            Lead__c testLead2 = new Lead__c();
            testLead2.Assigned_Dealer__c = dealer.id;
           // testLead2.Contact__c = con.id;
            testLead2.RecordTypeId = retailSalesleadRecordTypeID;
            insert testLead2;
        
        Lead__Share LeadShareRet = new Lead__Share();
        LeadShareRet.ParentId = testLead.id;
        LeadShareRet.UserOrGroupId = usr.id;
        LeadShareRet.AccessLevel = 'Edit';
        insert LeadShareRet;
        
        Vehicle_Relationship__c vehicleRs = new Vehicle_Relationship__c();
        vehicleRs.Vehicle_ID__c = vehicle.id;
        insert vehicleRs;
        
        Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
        vrShare.ParentId = vehicleRs.id;
        vrShare.UserOrGroupId = usr.id;
        vrShare.AccessLevel = 'Edit';
        insert vrShare;
        
             
        Campaign cmpAs = new Campaign();
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
        cmpAsShare.CampaignAccessLevel = 'Edit';
        insert cmpAsShare;
      
        
        Campaign cmpSm = new Campaign();
        cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
            cmpSm.IsActive = true; 
            cmpSm.Name = 'cmpSm';
            cmpSm.Status = 'Started';
            cmpSm.StartDate = System.today(); 
            cmpSm.EndDate = System.today();
            insert cmpSm;
        
        CampaignShare cmpSmShare = new CampaignShare();
        cmpSmShare.CampaignId = cmpSm.id;
        cmpSmShare.UserOrGroupId = usr.id;
        cmpSmShare.CampaignAccessLevel = 'Edit';
        insert cmpSmShare;
        
        
        Campaign cmpMb = new Campaign();
        cmpAs.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            cmpMb.IsActive = true; 
            cmpMb.Name = 'cmpMb'; 
            cmpMb.Status = 'Started'; 
            cmpMb.StartDate = System.today(); 
            cmpMb.EndDate = System.today();
            insert cmpMb;
        
        CampaignShare cmpMbShare = new CampaignShare();
        cmpMbShare.CampaignId = cmpMb.id;
        cmpMbShare.UserOrGroupId = usr.id;
        cmpMbShare.CampaignAccessLevel = 'Edit';
        insert cmpMbShare;
        
        Tool_Kit__c toolKit = new Tool_Kit__c();
        toolKit.RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
        toolKit.Dealer_Name__c = dealer.id;
        insert toolKit;
        
        Tool_Kit__Share toolKitshare = new Tool_Kit__Share();
        toolKitshare.ParentId = toolKit.id;
        toolKitshare.UserOrGroupId = usr.id;
        toolKitshare.AccessLevel = 'Edit';
        insert toolKitshare;
        
        
        
        existUserIds.add(usr.id);
        
        lstProfiles.add(DealerDelegatedAdmin);
        lstProfiles.add(CACSSICSR);
        lstProfiles.add(CACSSIQC);        
        usersList.add(usr);         
        UserHelper ush = new userHelper();
     
    }
    
    
    
}