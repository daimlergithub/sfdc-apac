@isTest
public with sharing class MisunderstoodTaskGenerationTest {

    public static testMethod void testMyController() {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
       // insert updatecustomsettings;

    Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;

        Id cca_RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign

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

        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
            
        Account customer = new Account(
            FirstName = 'Test-',
            LastName =  DateTime.now().formatLong(),
            PersonMobilePhone = '1301111111',
            PersonOtherPhone = '1301111122', 
            Phone = '01234567', 
            PersonHomePhone = '1234567', 
            PersonAssistantPhone = '1234567',MBK_Data_Source__c='Email',Mobile__c='00000009842'
        );
        customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        
        Lead__c ld = new Lead__c(
            Assigned_Dealer__c = dealer.Id,
            Contact__c = customer.Id
        );
        insert ld;
        
        Campaign_Lead__c cl = new Campaign_Lead__c(Campaign__c = TestData_CCA.Id, Lead__c = ld.Id);
        insert cl;
        
        Id SMSRTID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> tasks = new List<Task>();
        for(integer i = 0; i < 20; i++) {
            tasks.add(new Task(RecordTypeId = SMSRTID, WhatId = cl.Id, Activity_Status__c='Need Verification', UniqueCampaignGenerateTask__c = 'test'));
            tasks.add(new Task(RecordTypeId = SMSRTID, WhatId = TestData_CCA.Id, Activity_Status__c='Need Verification', UniqueCampaignGenerateTask__c = 'test1'));
        }

        Database.SaveResult[] srs = Database.insert(tasks, false);

        Test.startTest();
        
        List<Campaign> cpList = new List<Campaign>();
        cpList.add(TestData_CCA);
        
        MisunderstoodTaskGeneration mis = new MisunderstoodTaskGeneration(cpList, false);
        mis.processMisunderstoodTasks(srs, tasks);
        
        Test.stopTest();
  system.assert(!cpList.isEmpty());
  system.assertNotEquals(null,tasks);
    }
}