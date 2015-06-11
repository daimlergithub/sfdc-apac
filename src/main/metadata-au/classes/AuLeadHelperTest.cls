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
public class AuLeadHelperTest {
    private static Account customer;
	private static Account dealer;
    private static Account account;
    private static Account personaccount1;
	private static Lead__c lead;
    private static String personAccountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
    private static final String leadVehicleRt = Schema.sObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId(); 
    private static TestDataUtil testData = TestDataUtil.getInstance();

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
  

    @istest(seealldata = true)
    public static void LeadHelperTest2() {
       
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Service/Parts Lead').getRecordTypeId();

        Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
        User user2 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user2;

        system.runAs( user2 ) {
             dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
            insert dealer;
            Account dealer2 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'dealer2');
            insert dealer2;
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City__c = 'Anqing city';
            a1.Preferred_Language__c = 'English';
            //a1.Lead_Escalation_Recipient_Type__c='Immediate Notice';
            //a1.Dealer_Lead_Gate_Keeper__c=false;
            insert a1;
             
            
            Account a2 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao');
            a2.Gender__c = 'Male';
            a2.Province__c = 'Shanghai';
            a2.City__c = 'Anqing city';
            a2.Preferred_Language__c = 'English';
            a2.Dealer_Lead_System__c = 'Salesforce';
            a2.Allow_Data_Sharing__c = 'Yes';
            
            insert a2;
            Contact contact1 = new Contact ( AccountId = dealer.id,
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false);
            insert contact1;
           
            Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Assigned_Dealer__c = dealer.id;
            le1.Contact__c = a1.id;
            le1.RecordTypeId = afterSalesRecordTypeId;
            le1.CAC_Lead_Status__c = 'Qualified';
            insert le1;
            List<Lead__c> le2 = new List<Lead__c>();
            le2.add(getLead1(user2));
            
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
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user3;

       
       
           system.runAs( user3) {
          
            
            getLead(user3);
                dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
                insert dealer;
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                         Inactive__c=false,
                                         Business_Unit__c='Alliance',
                                         Sub_BusinessUnit__c='Finance',
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false);
                   insert contact1;
               
              Lead__c lead1=createLead2(user3);
               lead1.Assigned_Dealer__c=dealer.id;
               lead1.Business_Unit__c='Alliance';
               lead1.Sub_BusinessUnit__c='Finance & Insurance';
               update lead1;
           }
    }
     @istest(seealldata = true)
    public static void LeadHelperTest5() {
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
                  insert user3;

       
       
           system.runAs( user3) {
          
            
            getLead(user3);
                dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
                insert dealer;
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                               Inactive__c=false,
                                               Business_Unit__c='Alliance',
                                               Sub_BusinessUnit__c='Finance',
                                               FirstName = 'lai',
                                               LastName = 'sichao',
                                               Email = 'sichao.lai@nttdata.com',
                                               EOC_Recipient_Type__c = '60 Days Primary',
                                               Lead_Escalation_Recipient_Type__c='CC Lead Escalation Recipient',Dealer_Lead_Gate_Keeper__c=false);
                               insert contact1;
               
              Lead__c lead1=createLead(user3);
               lead1.Assigned_Dealer__c=dealer.id;
               lead1.Business_Unit__c='Alliance';
               lead1.Sub_BusinessUnit__c='Finance & Insurance';
               lead.X24H_Untouched__c=true;
               lead.X72H_Untouched__c=true;
               lead.Is_Finance_Send_Email_Before_60_Days__c=true;
               update lead1;
           }
    }
      @istest(seealldata = true)
    public static void LeadHelperTest4() {
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user3;

       
       
           system.runAs( user3) {
          
            
            getLead(user3);
                dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
                insert dealer;
               
               Contact contact1 = new Contact ( AccountId = dealer.id,
                                               
                                         Inactive__c=false,
                                         Business_Unit__c='Alliance',
                                         Sub_BusinessUnit__c='Finance',
                                         Finance_Lead_Type__c='Key 2 Key',
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false);
            insert contact1;
               Lead__c lead1=createLead(user3);
               update lead1;
           
           }
    }
     

    
    
     static void getLead(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
         account = new Account();
         account.Name = 'account name';
         account.Phone = '10086';
         account.Area_Code__c = '010';
         account.Dealer_Allocation__c='MBAuP';
         account.Activation_Date__c=system.today();
         account.Fax = '10086';
         account.BillingCity = 'San Francisco';
         account.BillingCountry = 'USA';
         account.BillingPostalCode = '94105';
         account.BillingState = 'CA';
         account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
         account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         insert account;
        
            personaccount1 = testData.standardPersonAccount;
        insert personaccount1;
         
        
      
    }
    static Lead__c createLead(User usr){
        lead = new Lead__c();
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadFinanceRT;
        lead.Lead_Type__c = 'New Car';
        lead.CAC_Lead_Status__c = 'New Enquiry';
        lead.Lead_Source__c = 'Campaign';
        lead.Nature_of_Request__c='Key 2 Key';
        lead.Business_Unit__c= 'Alliance';
        lead.Sub_BusinessUnit__c='Finance & Insurance';
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
        insert lead;
         //lead.CAC_Lead_Status__c = 'Qualified';
        
        
        return lead;
        
    }
    static Lead__c createLead2(User usr){
        
        
        lead = new Lead__c();
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadVehicleRt;
        lead.Lead_Type__c = 'New Car';
        lead.CAC_Lead_Status__c = 'New Enquiry';
        lead.Lead_Source__c = 'Campaign';
        lead.Nature_of_Request__c='Brochure Request';
        lead.Business_Unit__c= 'Alliance';
        lead.Sub_BusinessUnit__c='Parts';
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
        insert lead;
       
         lead.X24H_Untouched__c=true;
         lead.X72H_Untouched__c=true;
         lead.Is_Finance_Send_Email_Before_20_Days__c=true;
         update lead;
        
         return lead;
        
    }
    static Lead__c getLead1(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        account = new Account();
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
        
        customer = new Account();
        customer.Allow_Data_Sharing__c = 'Yes'; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = 'English';
        customer.Dealer_Lead_System__c = 'Salesforce';
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
        
        lead = new Lead__c();
        lead.Contact__c = customer.Id;
        lead.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
        lead.CAC_Lead_Status__c = 'Qualified';
       
         lead.Assigned_Dealer__c = account.Id;
         lead.Lead_Source__c = 'Campaign';
         lead.Nature_of_Request__c='Brochure Request';
         lead.Business_Unit__c= 'Alliance';
         lead.Sub_BusinessUnit__c='Parts';
         lead.CAC_Lead_Status__c = 'New Enquiry';

        insert lead;
        return lead;
    
    
      
    }
    

}