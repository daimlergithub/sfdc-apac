/*
    Type:       Test class of TriggerRetailCampaign
    Purpose:    Test class of TriggerRetailCampaign
    
  
    
    1. Shuang Li Created on 2014-05-13
*/
@isTest
public class TriggerRetailCampaignTest {
    private static Id SMYearRecordTypeId = 
                Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
    private static Id ASYearRecordTypeId = 
                Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
    private static Id ASRecordTypeId = 
                Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('AS Retail Campaign').getRecordTypeId();
    private static Id RMRecordTypeId = 
                Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail MB Best Practice').getRecordTypeId();
    private static Id CBRecordTypeId = 
                Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
    private static Id RSRecordTypeId = 
                Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Retail smart Best Practice').getRecordTypeId();
    private static Account dealer;
    private static User dealerUser;
    @isTest
    public static  void testTriggerRetailCampaign1() {
        MonthlyRule__c mr = new MonthlyRule__c(
                            KPI_Type__c = 'Marketing Budget',
                            Brand__c= 'MB + StarElite',
                            Driven__c = 'Joint',
                            Name = '1'
                            );
        insert mr;
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com', Dealer_Marketing_Manager__c = true);
        insert dealerContact;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];
        dealerUser = new User(Username = 'test.daimler.asia@test.com', ProfileId = portalProfile.Id, Alias = 't12345', Email = 'test12345daimler@test.com', EmailEncodingKey = 'UTF-8', LastName = 'Kumar', CommunityNickname = 'test112345', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
       // insert dealerUser;
        test.startTest();
        Retail_Campaign__c cp1 = new Retail_Campaign__c(
        Y_Dealer_Name__c = dealer.id,
        Campaign_Execution_Channels__c = 'DM',
        //Y_Status__c = 'Confirmed',
        Y_Apply_Deadline__c = system.today(),
                    RecordTypeId = SMYearRecordTypeId);
        insert cp1;                                        
        Retail_Campaign__c cp2 = new Retail_Campaign__c(
        Y_Dealer_Name__c = dealer.id,
        Campaign_Execution_Channels__c = 'DM',
        Y_Apply_Deadline__c = system.today(),
                    RecordTypeId = ASYearRecordTypeId);
        insert cp2;
        Retail_Campaign__c cp3 = new Retail_Campaign__c(
                    Yearly_TA__c = cp2.id,
                    Dealer_Name__c = dealer.id,
                    Campaign_Execution_Channels__c = 'DM',
                    RecordTypeId = ASRecordTypeId);
        insert cp3;
        test.stopTest();
         list<Retail_Campaign__c> listRetailCampaign = new list<Retail_Campaign__c>();
        listRetailCampaign.add(cp3);
        Retail_Campaign__c retailCampaignCheck = [select Dealer_Name__c,Y_Dealer_Name__c,Campaign_Execution_Channels__c,Brand__c from Retail_Campaign__c where id IN: listRetailCampaign];
        system.assertEquals(retailCampaignCheck.Dealer_Name__c, cp3.Dealer_Name__c);
    }
    @isTest
    public static  void testTriggerRetailCampaign2() {

        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        
        Campaign TestData_MBBestPractice = new Campaign(Name='TestData_MBBestPractice_Campaign',
                                     Campaign_Code__c='Code_MBBestPractice',
                                     Region_Best_Number__c = 2,
                                     RecordTypeId=CBRecordTypeId);
        insert TestData_MBBestPractice;

        test.startTest();
        Retail_Campaign__c cp4 = new Retail_Campaign__c(
                    Y_Dealer_Name__c = dealer.id,
                    Parent_Campaign__c = TestData_MBBestPractice.id,
                    Region_Best_Practice__c = false,
                    Region_Recommendation__c = false,
                    Final_Best_Practice__c = false,
                    Campaign_Execution_Channels__c = 'DM',
                    RecordTypeId = RMRecordTypeId);
        insert cp4;
        cp4.Region_Best_Practice__c = true;
        cp4.Region_Recommendation__c = true;
        update cp4;
        cp4.Region_Recommendation__c = false;
        cp4.Final_Best_Practice__c = true;
        update cp4;

        test.stopTest();
         list<Retail_Campaign__c> listRetailCampaign = new list<Retail_Campaign__c>();
        listRetailCampaign.add(cp4);
        Retail_Campaign__c retailCampaignCheck = [select Dealer_Name__c,Y_Dealer_Name__c,Brand__c,Campaign_Execution_Channels__c from Retail_Campaign__c where id IN: listRetailCampaign];
        system.assertEquals(retailCampaignCheck.Dealer_Name__c, cp4.Dealer_Name__c);
    }
    @isTest
    public static  void testTriggerRetailCampaign3() {

        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        
        Campaign TestData_MBBestPractice = new Campaign(Name='TestData_MBBestPractice_Campaign',
                                     Campaign_Code__c='Code_MBBestPractice',
                                     Region_Best_Number__c = 2,
                                     RecordTypeId=CBRecordTypeId);
        insert TestData_MBBestPractice;

        test.startTest();
        Retail_Campaign__c cp5 = new Retail_Campaign__c(
                    Y_Dealer_Name__c = dealer.id,
                    Parent_Campaign__c = TestData_MBBestPractice.id,
                    Region_Best_Practice__c = true,
                    Region_Recommendation__c = true,
                    Campaign_Execution_Channels__c = 'DM',
                    Final_Best_Practice__c = false,
                    Final_Best_Practice_Forsmart__c = true,
                    
                    RecordTypeId = RSRecordTypeId);
        insert cp5;

        cp5.BP_Status__c = 'Retail Submit';
        update cp5;
        TriggerRetailCampaignMemberHandlerJP rcmhJP = new TriggerRetailCampaignMemberHandlerJP();
        rcmhJP.handleTrigger(false, false, false, false, false);
        rcmhJP.handleIntegrationTrigger(false, false, false, false, false);
        

       /* TriggerRetailTaskTriggerHandler rth = new TriggerRetailTaskTriggerHandler();
        rth.handleTrigger(false, false, false, false, false);
        rth.handleIntegrationTrigger(false, false, false, false, false);*/

        
        TriggerRetailTaskTriggerHandlerJP rthJP = new TriggerRetailTaskTriggerHandlerJP();
        rthJP.handleTrigger(false, false, false, false, false);
        rthJP.handleIntegrationTrigger(false, false, false, false, false);
        
        test.stopTest();
        list<Retail_Campaign__c> listRetailCampaign = new list<Retail_Campaign__c>();
        listRetailCampaign.add(cp5);
        Retail_Campaign__c retailCampaignCheck = [select Dealer_Name__c,Y_Dealer_Name__c,Brand__c from Retail_Campaign__c where id IN: listRetailCampaign];
        system.assertEquals(retailCampaignCheck.Dealer_Name__c, cp5.Dealer_Name__c);
    }
}