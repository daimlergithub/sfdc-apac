/*
    Type:Test Class for LeadHelper
    Purpose: Create a custom sharing to share the lead record with Smart -
    Account Owner or the Star Elite Account Owner (from dealer record) 
    with Read Only access.)
    User Story: US-QC-022, US-QC-023, US-DP-022, US-DP-023, US-IB-001
    Used By:1. Sinow Created on 2013-04-25,2. Justin
*/
@isTest
public with sharing class LeadHelperTest {

    //add in 11/27
    private static String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();    
    private static String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    private static Account dealer;
    private static User SmartDM;
    private static User user1;
    private static Profile profile = [select Id from Profile where Name = 'IntegrationAPI'];
    private static Profile profileCAC = [select Id from Profile where Name = 'CAC IB CSR'];
    private static userRole roleId1 = [select Id from userRole where Name = 'IB CSR'];
    private static string en_US='en_US';
    private static string english='english';
    private static string salesforce='salesforce';
    private static string yes='yes';
    

    private static User createUser(String userRolex, String profilex) {
        User usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = userRolex;
        usr.ProfileId = profilex;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'Atest';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = en_US;
        usr.localesidkey=en_US;
        usr.isActive = true;
        insert usr;
        return usr;
    }

    // add in 11/27
    public static testMethod void LeadHelperTest() {       
       user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US);
        insert user1;

          system.runAs( user1 ) {
           preparedTestData();
            set<id> setDealerId = new set<id>();
            setDealerId.add(dealer.id);
            Lead__c lead = getLead(user1);
            Contact c = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='testL',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332116');
            insert c;
            user1.Contact = c;
           // user1.AccountId = dealer.Id;
            user1.Contact.Dealer_Lead_Gate_Keeper__c = true;
            lead.Assigned_Dealer__c = user1.AccountId;
            update lead;

            lead.Assigned_Dealer__c = dealer.Id;
            
           
         
            update lead;
            list<Lead__c> listLead = new list<Lead__c>();
            listLead.add(lead);
            map<id,id> caseLead = new map<id,id>();
            caseLead.put(lead.id, lead.id);
             string tempTitle = 'testTemplate';
             Test.startTest();
            LeadHelper.UpdateLeadOwnerFromContact(setDealerId,listLead);
            LeadHelper.ShareToGateKeeper(setDealerId,listLead);
            LeadHelper.UpdateCasesWithLeadId(caseLead);
            LeadHelper.createdNewSMSTaskForInstructor(lead,user1,user1,dealer,dealer);
            LeadHelper.createdNewSMSTaskForCustomer(lead,user1,dealer,dealer,tempTitle);
            Test.stopTest();
            System.assertNotEquals(null,user1);
            System.assert(dealer!=null);
        }
    }
   @istest
    public static void TestLeadHelper() {
        createuserrecord();
        system.runAs(user1) {
        Test.startTest();
            Account dealer1 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
            insert dealer1;
            Account dealer2 = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392244', Name = 'dealer2');
            insert dealer2;
            Account a1 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392245', RecordTypeId = PersonRecordtypeid, LastName = 'sichaos');
            a1.Gender__c = 'Male';
            a1.Province__c = 'Shanghai';
            a1.City__c = 'Anqing city';
            a1.Preferred_Language__c = english;
            a1.Star_Elite_Account_Owner__c = user1.id;
            insert a1;
            Account a2 = new Account(Allow_Data_Sharing__c = 'No', Phone = '58392246', RecordTypeId = PersonRecordtypeid, LastName = 'sichaod');
            a2.Gender__c = 'Male';
            a2.Province__c = 'Shanghai';
            a2.City__c = 'Anqing city';
            a2.Preferred_Language__c = english;
            a2.Dealer_Lead_System__c = salesforce;
            a2.Allow_Data_Sharing__c = yes;
            a2.Smart_Account_Owner__c = user1.id;
            insert a2;
            Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Assigned_Dealer__c = dealer1.id;
            le1.Contact__c = a1.id;
            le1.RecordTypeId = afterSalesRecordTypeId;
            insert le1;
            List<Lead__c> le2 = new List<Lead__c>();
            
            le2.add(getLead(user1));
            system.debug('le2========================'+le2);
            le2[0].Contact__c = a1.id;
            le2[0].Lead_Type__c = 'New Car';
            le2[0].Relation_With_The_Leads__c = 'I owner';
            le2[0].CAC_Lead_Status__c = 'Assigned';
            le2[0].Purchase_Time__c = '0 - 3 months';
            le2[0].Interested_Vehicle_Brand__c = 'MB';
            le2[0].Lead_Desired_Service__c = 'Test Drive';
            update le2[0];

            a1.Allow_Data_Sharing__c = yes;
            update a1;
            Test.stopTest();
            System.assertNotEquals(null,user1);
            System.assert(dealer1!=null);
        }
    }
    
   public Static void preparedTestData()
   {
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();   
       insert updatecustomsettings; 
       
       Trigger__c TriggerLeadJP=new Trigger__c(Name='TriggerLeadJP',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
       insert TriggerLeadJP;
        
       Trigger__c TriggerLeadKR=new Trigger__c(Name='TriggerLeadKR',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       insert TriggerLeadKR;
       
        SmartDM = createUser(roleId1.Id,profileCAC.Id);
       
        dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = DealerRecordtypeid;
        dealer.Star_Elite_Account_Owner__c = SmartDM.Id;
        dealer.Smart_Account_Owner__c = SmartDM.Id;
        dealer.Dealer_Lead_System__c = salesforce;
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = yes;
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = english;
        dealer.Dealer_Lead_System__c = salesforce;
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
         insert dealer;
   
   }

       static Lead__c getLead(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
        Account account = new Account();
        account.Name = 'account name';
        account.Phone = '10086';
        account.Area_Code__c = '040';
        account.Fax = '10087';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId =dealerRecordTypeId;
        insert account;
        
        Account customer = new Account();
        customer.Allow_Data_Sharing__c = yes; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = english;
        customer.Dealer_Lead_System__c = salesforce;
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '200235';
        customer.Type = '0=Company';
        customer.Phone = '12332113'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId =PersonRecordtypeid;
        customer.Dealer_Lead_Gate_Keeper__c = usr.id;
        customer.Area_Code__c = '050';
        insert customer;
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = customer.Id;
        lead.recordTypeId =afterSalesRecordTypeId;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.Assigned_Dealer__c = account.Id;
        insert lead;
        return lead;
    }
    
    static Lead__c getLead1(User usr){
        Account account = new Account();
        account.Name = 'account name';
        account.Phone = '10088';
        account.Area_Code__c = '020';
        account.Fax = '10089';
        account.BillingCity = 'San Francisco';
        account.BillingCountry = 'USA';
        account.BillingPostalCode = '94105';
        account.BillingState = 'CA';
        account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        account.RecordTypeId =dealerRecordTypeId;
        insert account;
        
        Account customer = new Account();
        customer.Allow_Data_Sharing__c = yes; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = english;
        customer.Dealer_Lead_System__c = salesforce;
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '200235';
        customer.Type = '0=Company';
        customer.Phone = '12332114'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId =PersonRecordtypeid;
        customer.Dealer_Lead_Gate_Keeper__c = usr.id;
        customer.Area_Code__c = '030';
        insert customer;
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = customer.Id;
        lead.recordTypeId =afterSalesRecordTypeId;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'Used Car';
        lead.Relation_With_The_Leads__c = 'testrelation';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testInt';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testTrade';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.Assigned_Dealer__c = account.Id;
        insert lead;
        return lead;
    }
    public static testMethod void TestLeadHelperElse() {
    createuserrecord();
        SmartDM = createUser(roleId1.Id,profileCAC.Id);        
       
        system.runAs( user1 ) {
             preparedTestData();
             Test.startTest();
            set<id> setDealerId = new set<id>();
            setDealerId.add(dealer.id);
            Lead__c lead = getLead1(user1);
            Contact c = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='Ltest',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332115');
            insert c;
            user1.Contact = c;
           // user1.AccountId = dealer.Id;
            user1.Contact.Dealer_Lead_Gate_Keeper__c = true;
            lead.Assigned_Dealer__c = user1.AccountId;
            update lead;

            lead.Assigned_Dealer__c = dealer.Id;
            
           
         
            update lead;
            list<Lead__c> listLead = new list<Lead__c>();
            listLead.add(lead);
             
           // LeadHelper.createdNewSMSTaskForInstructor(lead,user1,user1,dealer,dealer);
            LeadHelper.ShareToGateKeeper(setDealerId,listLead);
            LeadHelper.getEPIntegrationUser();
            Test.stopTest();
            System.assertNotEquals(null,user1);
            System.assertEquals(lead.Assigned_Dealer__c,dealer.id);
            System.assert(dealer!=null);
            
        }
    }
    
    public static void createuserrecord()
     {
         
         user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichaof',
                          Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                          TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
                          EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US);
         insert user1;
         
         
       }

}