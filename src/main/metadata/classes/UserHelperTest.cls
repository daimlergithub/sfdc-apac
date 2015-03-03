/*
    Type:       Test Class for UserHelper
    Purpose:    Validate NoOfLicense when create a Portal user
    User Story: US-DP-007
    Used By:    
    History:
    
    1. Sinow Created on 2013-04-24
*/
@isTest(seeAllData=true)
public class UserHelperTest {
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void UserHelperTest() {
        // Create Dealer
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        //dealer.No_of_Dealer_Portal_Licenses__c = 0;
        //update dealer;
        
        // Create Contact
        Contact con = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Delegate Admin'];
        Profile CACSSICSR = [select Id from Profile where Name = 'CAC SSI CSR'];
        Profile CACSSIQC = [select Id from Profile where Name = 'CAC SSI QC'];
        
        // Create a portal user and validate No of Dealer Portal Licenses
        User usr = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = con.Id,
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
        try {
            insert usr;
        }
        catch(exception ex) {}
        
        //Update a user
        try {
            usr = [select Id, isActive from User where ProfileId = :DealerDelegatedAdmin.Id and isActive = true and ContactId != null limit 1];
            usr.isActive = false;
            update usr;
        }
        catch(exception ex) {}
        
        con = [select Id, Dealer_Lead_Gate_Keeper__c, Dealer_Complaint_Gate_Keeper__c from Contact where Id = :con.Id];
        dealer.No_of_Dealer_Portal_Licenses__c = 0;
        update dealer;
        
        usr = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = con.Id,
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
        try {
            insert usr;
        }
        catch(exception ex) {}
        
        usr = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = con.Id,
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
        try {
            insert usr;
        }
        catch(exception ex) {}
        
        usr = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ProfileId = CACSSICSR.Id,
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
            Account person = new Account(
            RecordTypeId = personRecordtypeid,
            PersonMobilePhone = '18610011001',
            FirstName = 'First',
            LastName = 'Last',
            PersonEmail = 'test@test.com'
        );
        insert person;
        Person = [select PersonMobilePhone, Name, PersonEmail, PersonContactId from Account where Id = :person.Id];
        
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
        //Update a user
        Test.startTest();
        try {
        usr = [select Id, isActive from User where ProfileId = :CACSSICSR.Id  limit 1];
        usr.ProfileId = CACSSIQC.Id;
        update usr;
        }
        catch(exception ex) {}
        Test.stopTest();
    }
    
    public static testMethod void UserHelperTest01() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact con = new Contact(AccountId = dealer.Id, LastName = 'Huang', Phone = '8412877', email = 'HuangTest@163.com', Dealer_Complaint_Gate_Keeper__c = true);
        insert con;        
        Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Dealer Delegate Admin'];
        User usr = UtilTestData.createPortalUser('Dealer','Dealer Delegate Admin');
         try {
            insert usr;
            System.debug('HSL: insert first user successfully.');
        } catch (DMLException e) {
            System.debug('HSL: insert user error : ' + e.getDMLMessage(0));
        }
        
        Account acc = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        AccountShare accShare = new AccountShare(
            AccountAccessLevel = 'Edit',
            OpportunityAccessLevel = 'Read',
            AccountId = acc.id,
            UserOrGroupId = usr.id
        );
        try {
            insert accShare;
        } catch (DMLException e) {
            System.debug('HSL: share account error : ' + e.getDMLMessage(0));
        }
        
        Vehicle__c vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), null);
        Vehicle__Share vehShare = new Vehicle__Share(
            AccessLevel = 'Edit',
            ParentID = vehicle.id,
            RowCause = Schema.Vehicle__Share.RowCause.Manual,
            UserOrGroupId = usr.id
        );
        try {
            insert vehShare;
        } catch (DMLException e) {
            System.debug('HSL: share vehicle error : ' + e.getDMLMessage(0));
        }
        
        Vehicle_Relationship__c vehicleRs = (Vehicle_Relationship__c )UtilTestData.createSobject(new Vehicle_Relationship__c(), null);
        Vehicle_Relationship__Share vehRsShare = new Vehicle_Relationship__Share(
            AccessLevel = 'Edit',
            ParentID = vehicleRs.id,
            RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual,
            UserOrGroupId = usr.id
        );
        try {
            insert vehRsShare;
        } catch (DMLException e) {
            System.debug('HSL: share vehicleRelationship error : ' + e.getDMLMessage(0));
        }
        
        Case cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        caseTeamMember casShare = new caseTeamMember(
            TeamRoleId = [select Id from CaseTeamRole where Name = 'Dealer' limit 1].id,
            ParentID = cas.id,
            MemberId = usr.id
        );
        try {
            insert casShare;
        } catch (DMLException e) {
            System.debug('HSL: share case error : ' + e.getDMLMessage(0));
        }
        
        Lead__c ld = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilTestData.LEAD_RT_SALES_LEADS);
        Lead__Share  ldShare = new Lead__Share (
                AccessLevel = 'Edit',
                ParentID = ld.id,
                RowCause = Schema.Lead__Share.RowCause.Manual,
                UserOrGroupId = usr.id
        );
        try {
            insert ldShare;
        } catch (DMLException e) {
            System.debug('HSL: share lead error : ' + e.getDMLMessage(0));
        }
        
        Test.startTest();
        Contact conNew = new Contact(AccountId = dealer.Id, LastName = 'Huang', Phone = '8412877', email = 'HuangTest@163.com', Dealer_Lead_Gate_Keeper__c = true);
        insert conNew;
        
        User usrNew = new User(
            Username = System.now().millisecond() + 'HuangTest@163.com',
            ContactId = conNew.Id,
            ProfileId = DealerDelegatedAdmin.Id,
            Alias = 'HuangTestNew',
            Email = 'HuangTestNew@163.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Huang',
            CommunityNickname = System.now().millisecond() + 'NTT-TEST',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        try {
            insert usrNew;
            System.debug('HSL: insert new user successfully.');
        } catch (DMLException e) {
            System.debug('HSL: insert new user error : ' + e.getDMLMessage(0));
        }
        
        Test.stopTest();
    }
    
    public static testMethod void UserHelperTest02() {
        Account dealer = [SELECT id,name FROM account limit 1];      
        Contact conNew = new Contact(AccountId = dealer.Id, LastName = 'Huang', Phone = '8412877', email = 'HuangTest@163.com', Permission_Set_Settings__c = 'AS_Retail_Campaign;AS_Yearly_TA');
        insert conNew;      
        User usrNew= UtilTestData.createPortalUser('Dealer','Dealer Community User');
        Test.startTest();
        Set<Id> userIds = new Set<Id>();
        userIds.add(usrNew.id);
        UserHelper.AssignPermissionSetForPortalUser(userIds);
       
        Test.stopTest();
    }
}