/*
    Type:       Test Class for LeadHelper
    Purpose:    Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
    User Story: US-QC-022, US-QC-023, US-DP-022, US-DP-023, US-IB-001
    Used By:
    ---------------------------------------------------------------
    History:

    1. Sinow Created on 2013-04-25
    2. Justin
*/
@isTest
public class LeadHelperTest {

    //add in 11/27
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;

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
    private static Id getUserRoleId(String roleName) {
        return getUserRoleMapInstance().get(roleName);
    }

    // Get ProfileId by Profile Name
    private static Id getProfileId(String profileName) {
        return getProfileMapInstance().get(profileName);
    }

    private static User createUser(String userRolex, String profilex) {
        User usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = userRolex;
        usr.ProfileId = profilex;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'test';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.localesidkey='en_US';
        usr.isActive = true;
        insert usr;
        return usr;
    }

    // add in 11/27
    public static testMethod void LeadHelperTest1() {
        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        Profile profileCAC = [select Id from Profile where Name = 'CAC IB CSR'];
        userRole roleId1 = [select Id from userRole where Name = 'smart DM (E1)'];
        User user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user1;

        User SmartDM = createUser(roleId1.id, profileCAC.id);
        String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332111';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = DealerRecordtypeid;
        dealer.Star_Elite_Account_Owner__c = SmartDM.Id;
        dealer.Smart_Account_Owner__c = SmartDM.Id;
        dealer.Dealer_LMS__c = 'No';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'Yes';
        dealer.Province__c = 'jiangsu';
        dealer.City_CN__c = 'nanjing';
        dealer.Preferred_Language__c = 'English';
        dealer.Dealer_LMS__c = 'No';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';

        system.runAs( user1 ) {
            insert dealer;
            Lead__c lead = getLead(user1);
            Contact c = new Contact(Dealer_Lead_Gate_Keeper__c = true);
            user1.Contact = c;
            user1.Contact.Dealer_Lead_Gate_Keeper__c = true;
            lead.Assigned_Dealer__c = user1.AccountId;
            update lead;

            lead.Assigned_Dealer__c = dealer.Id;
            update lead;
        }
    }

    @istest(seealldata = true)
    public static void LeadHelperTest2() {
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();

        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user2 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user2;

        system.runAs( user2 ) {
            Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
            insert dealer;
            Account dealer2 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'dealer2');
            insert dealer2;
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City_CN__c = 'Anqing city';
            a1.Preferred_Language__c = 'English';
            insert a1;
            Account a2 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a2.Gender__c = 'Male';
            a2.Province__c = 'Shanghai';
            a2.City_CN__c = 'Anqing city';
            a2.Preferred_Language__c = 'English';
            a2.Dealer_LMS__c = 'No';
            a2.Allow_Data_Sharing__c = 'Yes';
            insert a2;
            Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Assigned_Dealer__c = dealer.id;
            le1.Contact__c = a1.id;
            le1.RecordTypeId = afterSalesRecordTypeId;
            insert le1;
            List<Lead__c> le2 = new List<Lead__c>();
            le2.add(getLead(user2));
            
            le2[0].Contact__c = a1.id;
            le2[0].Lead_Type__c = 'New Car';
            le2[0].Relation_With_The_Leads__c = 'I owner';
            le2[0].CAC_Lead_Status__c = 'Assigned';
            le2[0].Purchase_Time__c = '0 - 3 months';
            le2[0].Interested_Vehicle_Brand__c = 'MB';
            le2[0].Lead_Desired_Service__c = 'Test Drive';
            update le2[0];
        }
    }

    @istest(seealldata = true)
    public static void LeadHelperTest3() {
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user3;

        system.runAs( user3 ) {
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City_CN__c = 'Anqing city';
            a1.Preferred_Language__c = 'English';
            insert a1;
            Case c1 = new Case();
            insert c1;
            Lead__c le1 = new Lead__c();
            le1.Case__c = c1.id;
            le1.Contact__c = a1.id;
            insert le1;
        }
    }


    @istest(seealldata = true)
    public static void LeadHelperTest4() {
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();

        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        UserRole userRole = [select Id from UserRole where Name = 'smart DM (E1)'];
        User user2 = new User(ProfileId = profile.Id, isActive = true, UserRoleId = userRole.Id, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user2;

        system.runAs( user2 ) {
            Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
            insert dealer;
            Account dealer2 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'dealer2');
            insert dealer2;
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City_CN__c = 'Anqing city';
            a1.Preferred_Language__c = 'English';
            a1.Star_Elite_Account_Owner__c = user2.id;
            insert a1;
            Account a2 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a2.Gender__c = 'Male';
            a2.Province__c = 'Shanghai';
            a2.City_CN__c = 'Anqing city';
            a2.Preferred_Language__c = 'English';
            a2.Dealer_LMS__c = 'No';
            a2.Allow_Data_Sharing__c = 'Yes';
            a2.Smart_Account_Owner__c = user2.id;
            insert a2;
            Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Assigned_Dealer__c = dealer.id;
            le1.Contact__c = a1.id;
            le1.RecordTypeId = afterSalesRecordTypeId;
            insert le1;
            List<Lead__c> le2 = new List<Lead__c>();
            
            le2.add(getLead(user2));
            system.debug('le2========================'+le2);
            le2[0].Contact__c = a1.id;
            le2[0].Lead_Type__c = 'New Car';
            le2[0].Relation_With_The_Leads__c = 'I owner';
            le2[0].CAC_Lead_Status__c = 'Assigned';
            le2[0].Purchase_Time__c = '0 - 3 months';
            le2[0].Interested_Vehicle_Brand__c = 'MB';
            le2[0].Lead_Desired_Service__c = 'Test Drive';
            update le2[0];

            a1.Allow_Data_Sharing__c = 'Yes';
            update a1;
        }
    }
    
    
     static Lead__c getLead(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        Account account = new Account();
        account.Name = 'account name';
        account.Phone = '10086';
        account.Area_Code__c = '010';
        account.Fax = '10086';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
        
        Account customer = new Account();
        customer.Allow_Data_Sharing__c = 'Yes'; 
        customer.Province__c = 'jiangsu'; 
        customer.City_CN__c = 'nanjing';
        customer.Preferred_Language__c = 'English';
        customer.Dealer_LMS__c = 'No';
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '200235';
        customer.Type = '0=Company';
        customer.Phone = '12332111'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        customer.Dealer_Lead_Gate_Keeper__c = usr.id;
        customer.Area_Code__c = '010';
        insert customer;
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = customer.Id;
        lead.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'test';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'test';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'test';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.Assigned_Dealer__c = account.Id;
        insert lead;
        return lead;
    }
}