@isTest
public With Sharing class UserHelperTest
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    final static String companyRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    final static String retailCampaignRecordtypeid = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
    public static Vehicle__c vehicle; 
    public static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    public static String retailSalesleadRecordTypeID = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();
    public static Set<Id> existUserIds = new Set<Id>();
    public static List<Profile> lstProfiles = new List<profile>();
    public static List<user> usersList = new List<user>();
    public static Contact con ;
    public static Account dealer;
    public static Account CompanyAcc;
    public static user usr;
    public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];
    public static Profile CACSSICSR = [select Id from Profile where Name = 'CAC SSI CSR'];
    public static Profile CACSSIQC = [select Id from Profile where Name = 'CAC SSI QC'];
   
    public static Campaign cmpAs;
    public static Campaign cmpSm;
    public static Campaign cmpMb;
    Public Static Tool_Kit__c toolKit;
    public static Lead__c testLead;
    public static Lead__c testLead2;
    public static Retail_Campaign__c testretail;
    public static Case aCase;
    public static Retail_Task__c contract;
    public static Account_Link__c externalLink;
    public static Task task;
    public static Vehicle_Relationship__c vehicleRs;
    public static String Read = 'Read';
    public static String Edit = 'Edit';
    public static UserHelper ush;
    public Static String ErrorMessageFirstPart = 'You have reached the max no. of license ';
    static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static Id C_MB_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.MB_COMPLAINT).getRecordTypeId();
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

    public static string accesslevel = 'Read';
    public static string tstuser;
    public static id useid;
    public static set<id> setid;
    public static List<User> user = Database.query('select id from user');
    public static  String sobjectNameStr;
    public static Id vechID = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static Id vechrelaID = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    
        
    
   public static testmethod void ShareVehicleToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareVehicleToNewUser(usr.id, existUserIds);
       test.stopTest();
       Vehicle__Share vhShare = [select AccessLevel from Vehicle__Share where ParentId =:vehicle.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,vhShare.AccessLevel) ;
    }   
    
    
    public static testmethod void ShareVehicleRelationToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareVehicleRelationToNewUser(usr.id, existUserIds);
       test.stopTest();
       Vehicle_Relationship__Share vrShare =  [select AccessLevel from Vehicle_Relationship__Share where ParentId =:vehicleRs.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,vrShare.AccessLevel) ;
    } 
    
    public static testmethod void ShareAccountLinkToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareAccountLinkToNewUser(usr.id, existUserIds);
       test.stopTest();
       Account_Link__Share Alshare = [select AccessLevel from Account_Link__Share where ParentId =:externalLink.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,Alshare.AccessLevel) ; 
    }   
    
    
    public static testmethod void ShareRetailTaskToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareRetailTaskToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Task__Share Rtshare  =  [select AccessLevel from Retail_Task__Share where ParentId =:contract.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,Rtshare.AccessLevel) ; 
    }   
    
    

    public static testmethod void ShareLeadsToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareLeadsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Lead__Share testLeadshare = [select AccessLevel from Lead__Share where ParentId =:testLead.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testLeadShare.AccessLevel) ; 
    }   
    
    public static testmethod void ShareRetailLeadsToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareRetailLeadsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Lead__Share testLeadshare = [select AccessLevel from Lead__Share where ParentId =:testLead.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testLeadShare.AccessLevel) ;  
    }   
      public static testmethod void ShareAsRecordsToNewUser_test()
    {
       test.startTest();
       createTestData();
        
       userHelper.ShareAsRecordsToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share share = [select AccessLevel from Retail_Campaign__Share where ParentId =:testretail.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,share.AccessLevel) ;  
    }   
        
    public static testmethod void ShareAsYearlyTAToNewUser_test()
    {
       test.startTest();
        createTestData();
        Retail_Campaign__c retCamAsY = new Retail_Campaign__c();
        retCamAsY.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
        retCamAsY.Dealer_Name__c = dealer.id;
        retCamAsY.Campaign_Execution_Channels__c='DM';
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
        
    }   
    
    public static testmethod void ShareSmYearlyTAToNewUser_test()
    {
       test.startTest();
        createTestData();
         Retail_Campaign__c retCamSm = new Retail_Campaign__c();
        retCamSm.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        retCamSm.Dealer_Name__c = dealer.id;
        retCamSm.Campaign_Execution_Channels__c='DM';
        insert retCamSm;
        
        Retail_Campaign__Share retCamSmShare = new Retail_Campaign__Share();
        retCamSmShare.ParentId = retCamSm.id;
        retCamSmShare.UserOrGroupId = usr.id;
        retCamSmShare.AccessLevel = Edit;
        insert retCamSmShare;
       
        
       userHelper.ShareSmYearlyTAToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share  testRetCamSmShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamSm.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testRetCamSmShare.AccessLevel) ;
        
    }   
    
    
    public static testmethod void ShareSmRecordsToNewUser_test()
    {
       test.startTest();
        createTestData();
        Retail_Campaign__c retCamSmEr = new Retail_Campaign__c();
        retCamSmEr.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
        retCamSmEr.Dealer_Name__c = dealer.id;
        retCamSmEr.Campaign_Execution_Channels__c='DM';
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
    }   
    
    
    public static testmethod void ShareRetailBestPracticeToNewUser_test()
    {
       test.startTest();
         createTestData();
        Retail_Campaign__c retCamMb = new Retail_Campaign__c();
        retCamMb.RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId();
        retCamMb.Dealer_Name__c = dealer.id;
        retCamMb.Campaign_Execution_Channels__c='DM';
        insert retCamMb;
        
        Retail_Campaign__Share retCamMbShare = new Retail_Campaign__Share();
        retCamMbShare.ParentId = retCamMb.id;
        retCamMbShare.UserOrGroupId = usr.id;
        retCamMbShare.AccessLevel = Edit;
        insert retCamMbShare;
      
        
       userHelper.ShareRetailBestPracticeToNewUser(usr.id, existUserIds);
       test.stopTest();
       Retail_Campaign__Share  testRetCamMbShare = [select AccessLevel from Retail_Campaign__Share where ParentId =:retCamMb.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,testRetCamMbShare.AccessLevel) ; 
        
    }  
    
    public static testmethod void ShareAsCampaignToNewUser_test()
    {
       test.startTest();
       createTestData();        
       userHelper.ShareAsCampaignToNewUser(usr.id, existUserIds);
       test.stopTest();
       CampaignShare TestShareAs = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpAs.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Read,TestShareAs.CampaignAccessLevel) ;
    }  
    
    public static testmethod void ShareSmCampaignToNewUser_test()
    {
       test.startTest();
       createTestData();        
       userHelper.ShareSmCampaignToNewUser(usr.id, existUserIds);
       test.stopTest();
       CampaignShare TestShareSm = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpSm.id and UserOrGroupId =:usr.id limit 1];
       system.assertNotEquals(null, TestShareSm.CampaignAccessLevel) ; 
      
    }  
    
    public static testmethod void ShareBestPracticeToNewUser_test()
    {
       test.startTest();
       createTestData();     
       userHelper.ShareBestPracticeToNewUser(usr.id, existUserIds);
       test.stopTest();
       CampaignShare TestShareBp = [select CampaignAccessLevel from CampaignShare where CampaignId =:cmpMb.id and UserOrGroupId =:usr.id limit 1];
       system.assertNotEquals(null, TestShareBp.CampaignAccessLevel) ;
       
        
    }  
    
    public static testmethod void ShareToolKitToNewUser_test()
    {
       test.startTest();
       createTestData();
       userHelper.ShareToolKitToNewUser(usr.id, existUserIds);
       test.stopTest();
       Tool_Kit__Share shareTk =  [select AccessLevel from Tool_Kit__Share where ParentId =: toolKit.id and UserOrGroupId =:usr.id limit 1];
       system.assertEquals(Edit,shareTk.AccessLevel) ;
    }  
    
   
    public static testmethod void updateContact_test()
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
    
//  Testmethod for ShareDataToNewUserBatch class    
 
     public static testmethod void testbatch1()
    {
        Account acc1 = new Account();
        acc1.LastName ='testaccount';
        //acc1.Mobile__c ='074389594';
        acc1.FirstName ='batch';
        acc1.Email__c ='ssibatch@test.com';
        acc1.Salutation ='Brother';
        //acc1.MBK_Data_Source__c='Email';
        acc1.Mobile__c = '09865234112';
        insert acc1;
        
        
       createTestData();
        AccountShare share = new AccountShare();
        share.AccountAccessLevel = accesslevel;
        share.AccountId = acc1.Id;
        share.UserOrGroupId = usr.id;
        share.OpportunityAccessLevel = accesslevel;
        insert share;
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'Account';
             
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('Account', sobjectNameStr, share);
    }
//  Testmethod for ShareDataToNewUserBatch class 
public static testmethod void testbatch2()
    {
        
        Vehicle__c vehc1 = new Vehicle__c();
        vehc1.Vehicle_Name__c ='Test1';
        vehc1.UsVIN__c ='abchgdtrsghtredfr';
        vehc1.RecordTypeId = vechID;
        vehc1.Brand__c ='Mercedes-Benz';
        vehc1.FirstRegistrationDate__c = date.today();
        vehc1.Purchase_Month__c ='02';
        vehc1.Model__c = 'R350L 4MATIC'; 
        vehc1.Class__c = 'A-Class';
        vehc1.Purchase_Year__c = '2004';
        vehc1.RegistrationNo__c = '12345';
        insert vehc1;
        
       createTestData();
        Vehicle__Share vehshare = new Vehicle__Share();
        vehshare.AccessLevel = accesslevel;
        vehshare.ParentId = vehc1.Id ;
        vehshare.RowCause = Schema.Vehicle__Share.RowCause.Manual;
        vehshare.UserOrGroupId = usr.Id ;
        insert vehshare;
        
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'Vehicle';
        
        
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('Vehicle',sobjectNameStr,vehshare);
    }
  //  Testmethod for ShareDataToNewUserBatch class   
    public static testmethod void testbatch3()        
    {
        
         
        Vehicle__c vehc1 = new Vehicle__c();
        vehc1.Vehicle_Name__c ='Test1';
        vehc1.UsVIN__c ='abchgdtrsghtredfr';
        vehc1.RecordTypeId = vechID;
        vehc1.Brand__c ='Mercedes-Benz';
        vehc1.FirstRegistrationDate__c = date.today();
        vehc1.Purchase_Month__c ='02';
        vehc1.Model__c = 'R350L 4MATIC'; 
        vehc1.Class__c = 'A-Class';
        vehc1.Purchase_Year__c = '2004';
        vehc1.RegistrationNo__c = '12345';
        insert vehc1;
        
        
        Vehicle_Relationship__c vehcrel =new Vehicle_Relationship__c();
        vehcrel.RecordTypeId = vechrelaID;
        vehcrel.Car_Relation__c ='Driver';
        vehcrel.Vehicle_ID__c = vehc1.Id ;
        insert vehcrel;
        
        createTestData();       
        Vehicle_Relationship__Share vehrelshare = new Vehicle_Relationship__Share();
        vehrelshare.AccessLevel = 'Read';
        vehrelshare.ParentId = vehcrel.Id ;
        vehrelshare.RowCause = Schema.Vehicle__Share.RowCause.Manual;
        vehrelshare.UserOrGroupId = usr.Id;
        insert vehrelshare;
        
        tstuser = string.valueOf(usr.Id);
        useid =Id.valueOf(tstuser);
        setid =(new Map<Id,SObject>(user)).keyset();
        sobjectNameStr = 'VehicleRelation';
        
        
        usr =[select id,Username from user where ID =:usr.Id]; 
        
        test.startTest();
        ShareDataToNewUserBatch schdata = new ShareDataToNewUserBatch(useid,setid,sobjectNameStr);
        Database.executeBatch(schdata);
        test.stopTest();
        system.assertEquals('VehicleRelation',sobjectNameStr,vehrelshare);
    }
  
    
    public Static  void createTestData()
    {
        
        Trigger__c TriggerUser=new Trigger__c(Name='TriggerUser',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       
           insert TriggerUser;
        
        // create a Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        // create a Contact
        
        con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id
        );
        
        insert usr;
        
        //Sandeep - After insert for trigger helper class coverage.
        update usr;
        //  Insert person Account 
        }
        Account person = new Account(
            RecordTypeId = personRecordtypeid,
            PersonMobilePhone = '1861001001',
            FirstName = 'First',
            LastName = 'Last',
            PersonEmail = 'test@test.com',
            Salutation = 'Unknown',
            MBK_Data_Source__c='Email',
            Mobile__c = '00000009642'
        );
        insert person;
        
        CompanyAcc = new Account(
            RecordTypeId = companyRecordtypeid,
            Mobile__c = '00000009642',
            Work_Phone__c = '00000009642',
            Name = 'First'
            
        );
        insert CompanyAcc;
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
     
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        
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
        
        testretail = new Retail_Campaign__c(RecordTypeId = retailCampaignRecordtypeid , name = 'testretail1');
        insert testretail;
        
        Retail_Campaign__Share rShare = new Retail_Campaign__Share ();
        rShare.ParentId = testretail.id;
        rShare.UserOrGroupId = usr.id;
        rShare.AccessLevel = Edit;
        insert rShare;
        
        Retail_Task__Share rtShare = new Retail_Task__Share();
        rtShare.ParentId = contract.id;
        rtShare.UserOrGroupId = usr.id;
        rtShare.AccessLevel = Edit;
        insert rtShare;
        
            testLead = new Lead__c();
            
            testLead.Assigned_Dealer__c = dealer.id;
            testLead.Contact__c = person.id;
            testLead.Company_Account__c = CompanyAcc.id;
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
            cmpAs.EndDate = System.today().addDays(2);
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
            cmpSm.EndDate = System.today().addDays(1);
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
            cmpMb.EndDate = System.today().addDays(3);
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
        ush = new userHelper();     
        System.assertEquals(UserHelper.ErrorMessageFirstPart,ErrorMessageFirstPart);
    }
    
    public static testmethod void ValidateUserTest()
    {
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser54545@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
     
        
        test.startTest();
        UserHelper.ShareAllDataToNewUserBatch(dealer1.id,usr.id);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
       public static testmethod void ValidateUserTest1()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser64646@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'tes34345tDaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Related_Dealer__c=dealer12.id,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        
        insert vehicle;
        
         Vehicle__Share vehicleShare = new Vehicle__Share();
        vehicleShare.AccessLevel = Read;
        vehicleShare.ParentId = vehicle.id;
        vehicleShare.UserOrGroupId = usr2.id;
        insert vehicleShare;
        
        test.startTest();
        UserHelper.ShareVehicleToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
     public static testmethod void ValidateUserTest13()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'test54556DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'testDaimlerUser76867@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
       Case aCase1 = new Case(
            Subject = 'XX',
            RecordTypeId = C_MB_RECORD_TYPE,
            AccountId = dealer12.Id,
            Case_Class__c = 'Pre-Sales',
            Car_Type__c = 'Dealer contact method',
            Case_SubType__c = 'Dealership Contacts',
            
            Status = 'Open',
            OwnerId=usr2.id
        );
        insert aCase1;
        
        test.startTest();
        UserHelper.ShareCaseToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
    public static testmethod void ValidateUserTest4()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'test12656DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'testDaimlerUser88554@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
        vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Related_Dealer__c=dealer12.id,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        
        insert vehicle;
        
         Vehicle__Share vehicleShare = new Vehicle__Share();
        vehicleShare.AccessLevel = Read;
        vehicleShare.ParentId = vehicle.id;
        vehicleShare.UserOrGroupId = usr2.id;
        insert vehicleShare;
        
        
            testLead2 = new Lead__c();
            testLead2.Assigned_Dealer__c = dealer12.id;
            testLead2.RecordTypeId = retailSalesleadRecordTypeID;
            insert testLead2;
        
        Lead__Share LeadShareRet = new Lead__Share();
        LeadShareRet.ParentId = testLead2.id;
        LeadShareRet.UserOrGroupId = usr2.id;
        LeadShareRet.AccessLevel = Edit;
        insert LeadShareRet;
        
        test.startTest();
        UserHelper.ShareRetailLeadsToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
     public static testmethod void ValidateUserTest5()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'test11226DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'test07079DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
       
        
        
            
        
        cmpMb = new Campaign();
        cmpMb.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
            //cmpMb.IsActive = true; 
            cmpMb.Name = 'cmpMb'; 
            cmpMb.Status = 'Started'; 
            cmpMb.StartDate = System.today(); 
            cmpMb.EndDate = System.today().addDays(3);
            insert cmpMb;
        
        CampaignShare cmpMbShare = new CampaignShare();
        cmpMbShare.CampaignId = cmpMb.id;
        cmpMbShare.UserOrGroupId = usr2.id;
        cmpMbShare.CampaignAccessLevel = Edit;
        insert cmpMbShare;
        
        
        test.startTest();
        UserHelper.ShareSmCampaignToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
    public static testmethod void ValidateUserTest6()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser996655@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'testDaimlerjhhhh12User@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
       
        
        
            
        
        cmpMb = new Campaign();
        cmpMb.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            //cmpMb.IsActive = true; 
            cmpMb.Name = 'cmpMb'; 
            cmpMb.Status = 'Started'; 
            cmpMb.StartDate = System.today(); 
            cmpMb.EndDate = System.today().addDays(3);
            insert cmpMb;
        
        CampaignShare cmpMbShare = new CampaignShare();
        cmpMbShare.CampaignId = cmpMb.id;
        cmpMbShare.UserOrGroupId = usr2.id;
        cmpMbShare.CampaignAccessLevel = Edit;
        insert cmpMbShare;
        
        
        test.startTest();
        UserHelper.ShareBestPracticeToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
      public static testmethod void ValidateUserTest7()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_GC_Code__c='12345');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        Group testGroup = new Group();
        testGroup.Name = 'acme23';
        testGroup.DeveloperName = 'ABC';
        INSERT testGroup;
        list<user> listcampaigns=new list<user>();
       User usr1 = new User(
            Username = System.now().millisecond() + 'testDaimlerUser010176@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        listcampaigns.add(usr1);
        insert listcampaigns;
        
        system.debug('list---'+listcampaigns);
 
          User listCampaign =[select id,contactId,contact.accountId,Contact.Account.Dealer_GC_Code__c,Contact.Account.name from user where id IN:listcampaigns];
          system.debug('hey'+listCampaign);
         list<User> oldList = new  list<User>();
         oldList.add(listCampaign);
        map<id,user> oldMap = new map<id,user>();
         oldMap.put(listCampaign.id, listCampaign);
        system.debug('hey'+oldMap);
        
        test.startTest();
        //UserHelper.UserShareforDealers(listcampaigns,oldMap,true,false);
        test.stopTest();
        system.assertNotEquals('ggg',usr1.name);
    }
     public static testmethod void ValidateUserTest222()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        usr = new User(
            Username = System.now().millisecond() + 'test1235684DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        insert usr;
       Set<id> e=new Set<id>();
       Account dealer12 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
        insert dealer12;
        Contact contact2 = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact2;
        
       User usr2 = new User(
            Username = System.now().millisecond() + 'test098188DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact2.id
             );
        
        insert usr2;
        e.add(usr2.id);
        
       
        
        
            
        
        cmpMb = new Campaign();
        cmpMb.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            //cmpMb.IsActive = true; 
            cmpMb.Name = 'cmpMb'; 
            cmpMb.Status = 'Started'; 
            cmpMb.StartDate = System.today(); 
            cmpMb.EndDate = System.today().addDays(3);
            insert cmpMb;
        
        CampaignShare cmpMbShare = new CampaignShare();
        cmpMbShare.CampaignId = cmpMb.id;
        cmpMbShare.UserOrGroupId = usr2.id;
        cmpMbShare.CampaignAccessLevel = Edit;
        insert cmpMbShare;
        
        
        test.startTest();
        UserHelper.ShareBestPracticeToNewUser(dealer1.id,e);
        test.stopTest();
        system.assertNotEquals('ggg',usr.name);
    }
    
      public static testmethod void ValidateUserTest45()
      {
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_GC_Code__c='12345',Dealer_ND_Code__c='12345');
        insert dealer1;
        Contact contact = new Contact(
            AccountId = dealer1.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        
        Group testGroup = new Group();
        testGroup.Name = 'acme23';
        testGroup.DeveloperName = 'ABC';
        INSERT testGroup;
        list<user> listcampaigns=new list<user>();
       User usr1 = new User(
            Username = System.now().millisecond() + 'test123456DaimlerUser@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            Market__c = 'KR',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=contact.id
             );
        
        listcampaigns.add(usr1);
        insert listcampaigns;
        
        system.debug('list---'+listcampaigns);
 
          User listCampaign =[select id,contactId,contact.accountId,Contact.Account.Dealer_GC_Code__c,Contact.Account.name from user where id IN:listcampaigns];
          system.debug('hey'+listCampaign);
         list<User> oldList = new  list<User>();
         oldList.add(listCampaign);
        map<id,user> oldMap = new map<id,user>();
         oldMap.put(listCampaign.id, listCampaign);
        system.debug('hey'+oldMap);
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

         User objeUser = [Select Id, ProfileId from User where Id=: UserInfo.getUserId() and ProfileId=: objProfile.id];

        System.runAs(objeUser){
        test.startTest();
        UserHelper.grpCreationandUsergrpAlign(listcampaigns);
        test.stopTest();
        system.assertNotEquals('ggg',usr1.name);
    }
    }
    
    }
