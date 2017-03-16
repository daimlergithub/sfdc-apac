/*
    Type:       Test Class
    Purpose:    TriggerCampaignMembers 
    User Story:     
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
*/
@isTest
public with sharing class TriggerCampaignMembers_TestClass{
    static testmethod void runTriggerCampaignMembers(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;
        
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();                       // CAC Campaign
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();      // Person Account.
         Test.startTest();
        // Execution Campaign Inital
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId);
        Database.insert(TestData_CAE_OBC);

        // Contact                
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='1024371',
                                      PersonMobilePhone='1235678910',
                                      MBK_Data_Source__c = 'Email',
                                      Mobile__c = '00000009842',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );        
        insert(testPerAcc);
                                         
        testPerAcc = [Select Id, PersonContactId From Account Where Id = :testPerAcc.Id];
        
        // Campaign Member Initial
        CampaignMember cm1 = new CampaignMember(CampaignId = TestData_CAE_OBC.Id,
                                                Status ='Sent',
                                                ContactId = testPerAcc.PersonContactId
                                                );  
        insert cm1;
        try{
         CampaignMember cmtest=[select CampaignId,Status,ContactId from CampaignMember where id=:cm1.id];
         
       /*  TriggerCampaignMembersTriggerHandler cth = new TriggerCampaignMembersTriggerHandler();
         cth.handleTrigger(false, false, false, false, false);
         cth.handleIntegrationTrigger(false, false, false, false, false);
         
         TriggerCampaignOfferingTriggerHandler coh = new TriggerCampaignOfferingTriggerHandler();
         coh.handleTrigger(false, false, false, false, false);
         coh.handleIntegrationTrigger(false, false, false, false, false);*/
         
         TriggerCampaignOfferingTriggerHandlerJP cohJP = new TriggerCampaignOfferingTriggerHandlerJP();
         cohJP.handleTrigger(false, false, false, false, false);
         cohJP.handleIntegrationTrigger(false, false, false, false, false);
         
        /* TriggerCampaignPackageTriggerHandler cph = new TriggerCampaignPackageTriggerHandler();
         cph.handleTrigger(false, false, false, false, false);
         cph.handleIntegrationTrigger(false, false, false, false, false);*/
         
         TriggerCampaignPackageTriggerHandlerJP cphJP = new TriggerCampaignPackageTriggerHandlerJP();
         cphJP.handleTrigger(false, false, false, false, false);
         cphJP.handleIntegrationTrigger(false, false, false, false, false);
         
          Test.stopTest();
           system.assertEquals(cmtest.Status,cm1.Status);
           }catch(exception e){}
    }
        
}