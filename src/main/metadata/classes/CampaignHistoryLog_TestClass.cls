/*
    Type:       Class
    Purpose:    Test in capaign history log generation  
    User Story: US-Cpn-017

    Used By:    
    ---------------------------------------------------------------
    History:

    18-June-2013 Stephano.shi (Breakingpoint)    Created
*/
@isTest
public class CampaignHistoryLog_TestClass{
     

    
    /* Centre Campaign */
    static Campaign dataPreparation(){
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();  
        // Central Campaign
        Id centCampaignRT = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         				
        // Centre Campaign Data Prepared
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=centCampaignRT);  
        insert TestData_CCA;
        return TestData_CCA;
    }
    
    
    /* Campaign Offering Trigger Test */
    static testmethod void runCampaignOfferingTrg(){
        
        Test.startTest();
    	// Data Prepared
        Campaign TestData_CCA = dataPreparation();
        Campaign_Offering__c co = new Campaign_Offering__c(Name='TEST CAMPAIGN OFFERING999',
                                                           Campaign__c=TestData_CCA.Id);
        
        insert co;
        co.Description__c = '123';
        update co;
        delete co;
        
        Test.stopTest();
    }
    
    /* Campaign Package Test */
    static testmethod void runCampaignPackageTrg(){
        Test.startTest();
    	// Data Prepared
        Campaign TestData_CCA = dataPreparation();
        Campaign_Package__c cp = new Campaign_Package__c(Name='TEST CAMPAIGN PACKAGE999',
                                                         Campaign__c=TestData_CCA.Id,
                                                         Package_Description__c='description');
        insert cp;
        cp.Package_Description__c = '123';
        update cp;
        delete cp;
        
        Test.stopTest();    	
    }

    /* Campaign Participating Dealer Trigger Test */
    static testmethod void runCampaignParticipatingDealerTrg(){
        Test.startTest();
    	// Data Prepared
        Campaign TestData_CCA = dataPreparation();
        
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
        Account dealer = new Account(Name='TEST Dealer999', ZipCode__c='123456', Phone='123456789', RecordTypeId=accDealerRT);
        insert dealer;
        
        Participating_Dealer__c pd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id,
                                                                 Dealer__c=dealer.Id);
        insert pd;
        update pd;
        delete pd;
        
        Test.stopTest();    	
    }    
}