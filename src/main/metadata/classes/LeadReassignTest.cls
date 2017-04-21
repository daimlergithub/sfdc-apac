@isTest
public with sharing class LeadReassignTest {

private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();

static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    System.runAs (user1) {
   

        test.starttest();
        set<id> accid=new set<id>();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = user1.Id;
        dealer.Smart_Account_Owner__c = user1.Id;
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
       insert dealer;
       
       Account dealer1 = new Account();
        dealer1.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer1.Phone = '12332121';
        dealer1.Dealer_GC_Code__c = 'gc code';
        dealer1.Dealer_GS_Code__c = 'gs code';
        dealer1.Name = 'test dealer';
        dealer1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer1.Star_Elite_Account_Owner__c = user2.Id;
        dealer1.Smart_Account_Owner__c = user2.Id;
        dealer1.Dealer_Lead_System__c = 'salesforce';
        dealer1.Dealer_Lead_Gate_Keeper__c = user2.id;
        dealer1.Allow_Data_Sharing__c = 'yes';
        dealer1.Province__c = 'jiangsu';
        dealer1.City__c = 'nanjing';
        dealer1.Preferred_Language__c = 'english';
        dealer1.Dealer_Lead_System__c = 'salesforce';
        dealer1.Gender__c = '0=Male';
        dealer1.ZipCode__c = '200235';
        dealer1.Type = '0=Company';
        dealer1.Status__c = '0=contac1';
        dealer1.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer1.Dealer_Region__c = 'EAST';
       insert dealer1;
       
        
        Account perAcc= new Account();
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
        perAcc.Dealer_Lead_Gate_Keeper__c = user1.Id;
        perAcc.Area_Code__c = '030';
       
        insert perAcc;

        accid.add(perAcc.id);
        
        
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = perAcc.Id;
        //lead.recordTypeId =Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
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
        lead.md__c='TH';
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;
        lead.Assigned_Dealer__c = dealer1.Id;
        update lead;
        
        list<Lead__c> ld=new  list<Lead__c>();
        ld.add(lead);
        system.debug('+++' + ld);
  
        
         LeadReassign lr=new LeadReassign();
        // lr.updateOwner(ld);
         LeadReassign.updateOwnership(accid,ld);
         test.stoptest();
          
        }     
        }
}