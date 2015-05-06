/*
    Purpose:    Test Class
    Class:      UtilCampaignCity
    Trigger:    TriggerCampaignCity
    Used By:    
    ---------------------------------------------------------------
    History:
    
    26-June-2013 Stephano (Breakingpoint)    Created
*/
@isTest
public class TriggerCampaignCity_TestClass{
    
    static testmethod void runTrigerCampaignCity(){
        // START TEST
        Test.startTest();
        // Record Type
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id dealer_RecordTypeId = accRecordTypeMap_test.get('Dealer').getRecordTypeId();         // Dealer
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id cac_RecordTypeId = cpRecordTypeMap_test.get('CAC Campaign').getRecordTypeId();                       // CAC Campaign
        Id caeCom_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Complex').getRecordTypeId();    // Campaign Execution - Complex
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();     // Campaign Execution - Simple
        
        // Centrel Campaign
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=cca_RecordTypeId);  

        insert TestData_CCA;
        
        // Dealer
        Account dealer = new Account(RecordTypeId=dealer_RecordTypeId, Name='TEST Dealer 999', phone='12345678');
        insert dealer;
        
        // Participating Dealer
        //Participating_Dealer__c pd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id, Dealer__c=dealer.Id);
       // insert pd;
        
        Test.stopTest();
    }
    
}