/*
    Purpose:    Test Class
    Class:      UtilCampaignCity
    Trigger:    TriggerCampaignCity
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
       
        
        Test.stopTest();
        Account dealer1 =[select Name from Account where id=:dealer.id];
        system.assertEquals(dealer1.Name, dealer.Name);
    }
    
}