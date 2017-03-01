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

    private static Account dealer;
    private static User SmartDM;
    private static User user1;
    private static Account perAcc;
    Private static List<Account> accList=new List<Account>();
    Private static Lead__c lead;
    private static User createUser(String userRolex, String profilex) {
        
        Profile profileCAC = [select Id from Profile where Name =:profilex];
        userRole userRoleIds= [select Id from userRole where Name =:userRolex];
        User usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
        if(userRoleIds!=Null){
        usr.UserRoleId = userRoleIds.Id;}
        if(profileCAC!=Null){
        usr.ProfileId = profileCAC.Id;}
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'Atest';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.localesidkey='en_US';
        usr.isActive = true;     
        insert usr;       
        return usr;
    }
    public Static void preparedTestData()
      {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        SmartDM = createUser('MBJ IT Department','CAC IB CSR');
        
        dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = SmartDM.Id;
        dealer.Smart_Account_Owner__c = SmartDM.Id;
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'english';
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
        system.debug('$$$$$$$$$$$$$$$$$'+dealer.Id);
        //insert dealer;
        accList.add(dealer);
        perAcc= new Account();
        perAcc.Allow_Data_Sharing__c = 'yes'; 
        perAcc.Province__c = 'jiangsu'; 
        perAcc.City__c = 'nanjing';
        perAcc.Preferred_Language__c = 'english';
        perAcc.Dealer_Lead_System__c = 'salesforce';
        perAcc.LastName = 'Customer';
        perAcc.Gender__c = '0=Male';
        perAcc.ZipCode__c = '2002351';
        perAcc.Type = '0=Company';
        perAcc.Phone = '01233214'; 
        perAcc.Status__c = '0=Customer';
        perAcc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        perAcc.Dealer_Lead_Gate_Keeper__c = SmartDM .Id;
        perAcc.Area_Code__c = '030';
        //insert perAcc;
        accList.add(perAcc);
        insert accList;
        lead = new Lead__c();
        system.debug('$$$$$$$$$$$$$$$$$'+perAcc.Id);
        lead.Contact__c = perAcc.Id;
        lead.recordTypeId =Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
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
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;       
      }

    public static void createuserrecord(String profilename)
     {
       Profile prof = [select Id from Profile where Name = 'System Administrator'];
       user1 = new User(ProfileId = prof.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichaof',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
       insert user1;
     }
    public static testMethod void testInsertLeadSharing() { 
       Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>(); 
       Map<Id, Id> newdealerIdGateKeeperIds = new Map<Id, Id>(); 
       createuserrecord('System Administrator');     
        system.runAs(user1) {
        preparedTestData();
        //User usr=createUser('MBJ IT Department','CAC IB CSR');                
            for(Account acc : accList)
            {
               dealerIdGateKeeperIds.put(acc.Id,acc.Id);
               newdealerIdGateKeeperIds.put(acc.Id,acc.Id);
            }
       LeadHelper.insertLeadSharing(dealerIdGateKeeperIds, newdealerIdGateKeeperIds);
      }
    }
    public static testMethod void testUpdateLeadOwner() {       
       List<Lead__c> leadsForUpdate= new List<Lead__c>(); 
       Set<id> setDealerId = new Set<id>();
	    map<id,Lead__c> leadMap = new map<id, Lead__c>();
       createuserrecord('System Administrator');     
         system.runAs(user1) {
         preparedTestData();  
         User usr=createUser('MBJ IT Department','CAC IB CSR');     
         setDealerId.add(dealer.id);          
         Contact con = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='testL',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332116');
         con.AccountId=dealer.id;       
         insert con;
         usr.Contact = con; 
         usr.isActive = true;
         lead.Assigned_Dealer__c = usr.AccountId;
         lead.Assigned_Dealer__c = dealer.Id;
         update lead;
         update usr;
             
        leadMap.put(lead.id, lead);
         leadsForUpdate.add(lead); 
          LeadHelper.UpdateLeadOwner(setDealerId,leadsForUpdate);
          LeadHelper.UpdateLeadOwnerFromDealerLeadGateKeeper(setDealerId,leadsForUpdate,leadMap);
      }
    }
     public static testMethod void testUpdateLeadOwnerFromContact() {       
       List<Lead__c> leadsForUpdate= new List<Lead__c>(); 
       Set<id> setDealerId = new Set<id>();
       createuserrecord('System Administrator');     
         system.runAs(user1) {
         preparedTestData();  
         User usr=createUser('MBJ IT Department','CAC IB CSR');     
         setDealerId.add(dealer.id);          
         Contact con = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='testL',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332116');
         insert con;
         usr.Contact = con;         
         usr.Contact.Dealer_Lead_Gate_Keeper__c = true;
         system.debug('*************'+usr.AccountId);
         lead.Assigned_Dealer__c = usr.AccountId;
         system.debug('*************'+dealer.Id);
         lead.Assigned_Dealer__c = dealer.Id;
         update lead;
         update usr; 
         leadsForUpdate.add(lead); 
          LeadHelper.UpdateLeadOwnerFromContact(setDealerId,leadsForUpdate);
      }
    }
    public static testMethod void testUpdateLeadOwnerFromContact1() {       
       List<Lead__c> leadsForUpdate= new List<Lead__c>(); 
       Set<id> setDealerId = new Set<id>();
       createuserrecord('System Administrator');     
         system.runAs(user1) {
         preparedTestData();  
         User usr=createUser('MBJ IT Department','CAC IB CSR');     
         setDealerId.add(dealer.id);          
         Contact con = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='testL',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332116');
         insert con;
         usr.Contact = con;         
         usr.Contact.Dealer_Lead_Gate_Keeper__c = true;
         system.debug('$$$$$$$$$$$$$$$$$'+usr.AccountId);
         lead.Assigned_Dealer__c = usr.AccountId;
         system.debug('$$$$$$$$$$$$$$$$$'+dealer.Id);
         lead.Assigned_Dealer__c = dealer.Id;
         update lead;
         update usr; 
         leadsForUpdate.add(lead); 
          LeadHelper.UpdateLeadOwnerFromContact(setDealerId,leadsForUpdate);
      }
    }
     public static testMethod void testShareToGateKeeper() {       
       List<Lead__c> leadsForUpdate= new List<Lead__c>(); 
       Set<id> setDealerId = new Set<id>();
       createuserrecord('System Administrator');     
         system.runAs(user1) {
         preparedTestData();  
         User usr=createUser('MBJ IT Department','CAC IB CSR');     
         setDealerId.add(dealer.id);          
         Contact con = new Contact(Dealer_Lead_Gate_Keeper__c = true,LastName='testL',Federation_ID__c='test federation',Email='test001@daimler.com.full',Phone='12332116');
         insert con;
         usr.Contact = con;         
         usr.Contact.Dealer_Lead_Gate_Keeper__c = true;
         lead.Assigned_Dealer__c = usr.AccountId;
         lead.Assigned_Dealer__c = dealer.Id;
         update lead;
         update usr; 
         leadsForUpdate.add(lead); 
          LeadHelper.ShareToGateKeeper(setDealerId,leadsForUpdate);
          LeadHelper.createdNewSMSTaskForCustomer(lead,usr,dealer,dealer,'testsrting');
      }
    }
     public static testMethod void testUpdateCasesWithLeadId() {
       map<id,id> caseLead = new map<id,id>();       
       createuserrecord('System Administrator');            
       system.runAs(user1) { 
        preparedTestData();   
        caseLead.put(lead.id,lead.id);      
        LeadHelper.UpdateCasesWithLeadId(caseLead);
       }
     } 
     public static testMethod void testshareToAssignedDealer() { 
       Set<String> oldDealerIds = new Set<String>();
       Set<String> leadIds = new Set<String>();
       createuserrecord('System Administrator');            
        system.runAs(user1) { 
          preparedTestData(); 
          oldDealerIds.add(dealer.Id);  
          leadIds.add(lead.Id);    
          LeadHelper.shareToAssignedDealer(oldDealerIds,leadIds);
       }
    }
     public static testMethod void testbeforeInsert_UpdateEvents() { 
       List<Lead__c> leadsnew= new List<Lead__c>();
       Map<Id,Lead__c> leadOldMap= new  Map<Id,Lead__c>();
        createuserrecord('System Administrator');            
        system.runAs(user1) { 
          preparedTestData();          
          leadsnew.add(lead); 
          leadOldMap.put(lead.Id,lead);   
          LeadHelper.beforeInsert_UpdateEvents(leadsnew,leadOldMap,true,true);
          }
     }
     public static testMethod void testafterInsert_UpdateEvents() { 
       List<Lead__c> leadsnew= new List<Lead__c>();
       Map<Id,Lead__c> leadOldMap= new  Map<Id,Lead__c>();
        createuserrecord('System Administrator');            
        system.runAs(user1) { 
          preparedTestData();          
          leadsnew.add(lead); 
          leadOldMap.put(lead.Id,lead);   
          LeadHelper.afterInsert_UpdateEvents(leadsnew,leadOldMap,true,true);
          }
     }
    public static testMethod void testShareLeadsToCampaignUser() { 
       List<Lead__c> leadsnew= new List<Lead__c>();
       Map<Id,Lead__c> leadOldMap= new  Map<Id,Lead__c>();
       Map<Id,Lead__c> leadNewMap= new  Map<Id,Lead__c>();
        createuserrecord('System Administrator');            
        system.runAs(user1) { 
          preparedTestData();          
          leadsnew.add(lead); 
          leadOldMap.put(lead.Id,lead);
          leadNewMap.put(lead.Id,lead);   
          LeadHelper.ShareLeadsToCampaignUser(leadsnew,leadOldMap,leadNewMap,true,false);
          LeadHelper.ShareLeadsToCampaignUser(leadsnew,leadOldMap,leadNewMap,false,true);
          }
     }
    public static testMethod void testcreatedNewSMSTaskForInstructor() { 
      createuserrecord('IntegrationAPI'); 
       system.runAs(user1){
        preparedTestData();  
        User usr=createUser('MBJ IT Department','CAC IB CSR');  
        LeadHelper.createdNewSMSTaskForInstructor(lead,usr,user1,perAcc,dealer);
       }  
     }
     
    public static testMethod void testEPIntegrationUser() { 
       createuserrecord('IntegrationAPI'); 
       system.runAs(user1){     
              Profile prof = [select Id from Profile where Name = 'IntegrationAPI'];
               User use21 = new User(ProfileId = prof.Id, isActive = true, Username = 'lai12@nttdata.com', LastName = 'ep.user1',
                                  Email = 'sichao.lai@test.com', Alias = 'laisc', CommunityNickname = 'barney12',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
              insert use21;
        LeadHelper.getEPIntegrationUser();
       }
 }
   
    
}