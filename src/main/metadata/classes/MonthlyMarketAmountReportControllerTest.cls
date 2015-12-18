/*
    Type:       Test class
    Purpose:    Test Class for MonthlyMarketAmountReportController
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Shuang Li Created on 2014-8-19
*/
@isTest
public class MonthlyMarketAmountReportControllerTest {
    public Static  Map<String, Schema.RecordTypeInfo> SMRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
    public Static String RecordTypeId = SMRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId();
    public Static  Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
    public Static String  cpRecordTypeId=cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId();
    public Static String Approved='Approved';
    public Static String Joint='Joint';
    public Static String dealerdriven='dealer driven';
    public Static MonthlyMarketAmountReportController MonthlyMarketAmountReportCon;
    
    public static testMethod void testMonthlyMarketAmountReportController() {
    
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        Campaign campign = new Campaign(IsActive = true, Name = 'top', Status = 'Started', StartDate = System.today(), EndDate = System.today(), RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId());
        insert campign;
        List<Retail_Campaign__c> retailCampaigns = new List<Retail_Campaign__c>();
        Retail_Campaign__c retailCampaign1 = new Retail_Campaign__c(Name = 'Test ', Plan_End_Date__c = System.today(), Apply_Status__c =Approved, Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId =cpRecordTypeId, Driven__c = Joint,Relevant_Central_Campaign__c =campign.id);
        Retail_Campaign__c retailCampaign2 = new Retail_Campaign__c(Name = 'Testcampaign',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId = cpRecordTypeId, Driven__c = dealerdriven);
        Retail_Campaign__c retailCampaign3 = new Retail_Campaign__c(Name = 'Test Rc',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId =cpRecordTypeId, Driven__c = Joint,Relevant_Central_Campaign__c =campign.id);
        Retail_Campaign__c retailCampaign4 = new Retail_Campaign__c(Name = 'Test RetailC',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId = cpRecordTypeId, Driven__c = dealerdriven);
        retailCampaigns.add(retailCampaign1);
        retailCampaigns.add(retailCampaign2);
        retailCampaigns.add(retailCampaign3);
        retailCampaigns.add(retailCampaign4);
        insert retailCampaigns;
        // Start Test
        Test.startTest();
        
        PageReference MonthlyMarketAmountReportPage = new PageReference('/apex/MonthlyMarketAmountReport');
        Test.setCurrentPage(MonthlyMarketAmountReportPage);
        MonthlyMarketAmountReportCon = new MonthlyMarketAmountReportController();
        
        // Stop Test
        Test.stopTest();
        System.assertNotEquals(null,retailCampaigns);
    }
    
     public static testMethod void testMonthlyMarketAmountReportControllerElseCondition() {
     
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;

         
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        Campaign campign = new Campaign(IsActive = true, Name = 'top campaign', Status = 'Started', StartDate = System.today(), EndDate = System.today(), RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId());
        insert campign;
        List<Retail_Campaign__c> retailCampaigns = new List<Retail_Campaign__c>();
        Retail_Campaign__c retailCampaign1 = new Retail_Campaign__c(Name = 'top', Plan_End_Date__c = System.today(), Apply_Status__c =Approved, Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId =RecordTypeId, Driven__c = Joint,Relevant_Central_Campaign__c =campign.id);
        Retail_Campaign__c retailCampaign2 = new Retail_Campaign__c(Name = 'topRc',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId =RecordTypeId, Driven__c = dealerdriven);
        Retail_Campaign__c retailCampaign3 = new Retail_Campaign__c(Name = 'Test',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId = RecordTypeId, Driven__c = Joint,Relevant_Central_Campaign__c =campign.id);
        Retail_Campaign__c retailCampaign4 = new Retail_Campaign__c(Name = 'TestRc',Plan_End_Date__c = System.today(), Apply_Status__c =Approved,Dealer_Name__c = dealer.Id, Y_Dealer_Name__c = dealer.Id, RecordTypeId = RecordTypeId, Driven__c = dealerdriven);
        retailCampaigns.add(retailCampaign1);
        retailCampaigns.add(retailCampaign2);
        retailCampaigns.add(retailCampaign3);
        retailCampaigns.add(retailCampaign4);
        insert retailCampaigns;
        // Start Test
        Test.startTest();
        
        PageReference MonthlyMarketAmountReportPage = new PageReference('/apex/MonthlyMarketAmountReport');
        Test.setCurrentPage(MonthlyMarketAmountReportPage);
       // Stop Test
      MonthlyMarketAmountReportCon = new MonthlyMarketAmountReportController();
        Test.stopTest();
                System.assertNotEquals(null,retailCampaigns);
                  

    }
    
}