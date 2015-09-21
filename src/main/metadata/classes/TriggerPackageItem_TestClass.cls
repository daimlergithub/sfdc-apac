/*
    Type:       Test Class
    Purpose:    TriggerPackgeItem_TestClass
    User Story: US--005
    29-June-2013 Stephano (Breakingpoint)    Created
*/
@isTest
public with sharing class TriggerPackageItem_TestClass{
    static testmethod void runTriggerPackgeItem(){
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> acRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();        
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        Id dl_RecordTypeId = acRecordTypeMap_test.get('Dealer').getRecordTypeId();      // Dealer.
        Test.startTest();
        // Central Campaign Inital
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
        
        
        // Campaign Offering
        Campaign_Offering__c co = new Campaign_Offering__c(Name='TEST Campaign Offering DATA',
                                                          Campaign__c=TestData_CCA.Id);
        insert co;
        
        
        // Campaign Package
        Campaign_Package__c cp = new Campaign_Package__c(Name='Campaign Package',
                                                        Campaign__c=TestData_CCA.Id,
                                                        Package_Description__c='12313');
        insert cp;
        
        // Dealer
        Account acc = new Account(Name='TEST DATA DEALER', Phone='12345678', RecordTypeId=dl_RecordTypeId);
        insert acc;
        
        // Package Item
        Package_Item__c pi = new Package_Item__c(Package_Name__c=cp.Id,
                                                Offering__c=co.Id);
        insert pi;
                
        // Participating Dealer
        Participating_Dealer__c pd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id,Dealer__c=acc.Id, Campaign_Package__c=cp.Id);
        insert pd;
                
        delete pi;
        
        // Package Item
        Package_Item__c pi1 = new Package_Item__c(Package_Name__c=cp.Id,
                                                Offering__c=co.Id);
        insert pi1;  
        
        Package_Item__c piTest = [select Package_Name__c,Offering__c from Package_Item__c where id=:pi1.id];
        Test.stopTest();
        system.assertEquals(piTest.Package_Name__c, pi1.Package_Name__c);
  
    }
}