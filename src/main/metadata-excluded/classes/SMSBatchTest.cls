/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class SMSBatchTest {
    public static testMethod void testActiveAll() {
        
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=paid
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Salutation = 'mr',
                                         MobilePhone='1234567',
                                         SMSOptOut__c=false,
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon); 
        //SMSTestRecipient__c
        TestRecipientGroup__c testRecipientGroup = new TestRecipientGroup__c(IsActive__c=true
                                     );
        insert(testRecipientGroup); 
        SMSTestRecipient__c testRecipient = new SMSTestRecipient__c(TestRecipientName__c=testPerCon.id,
                                      TestRecipientGroup__c=testRecipientGroup.id
                                     );
        insert(testRecipient); 
        // SMS Template
        Id smsTem_RecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq',Message_Detail__c='lalala Test 001{CONTACT_NAME}aaaa{CONTACT_SALUTATION}22222{CONTACT_NAME}rege{CONTACT_SALUTATION}');
        insert(tcSMS); 
        // Campaign
        Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();                       
        Campaign TestCampaign = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA5',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             Template__c=tcSMS.id,
                                             Execution_Type__c='SMS',
                                             Create_Unique_Code__c=true,
                                             RecordTypeId=centCampaignRT);  
        insert(TestCampaign); 
        //SMS_Batch__c
        SMS_Batch__c testSMSBatch = new SMS_Batch__c(Batch_Start__c=DateTime.now().addSeconds(2),
                                      Batch_Status__c='new',
                                      TestRecipientGroup__c=testRecipientGroup.id,
                                      Campaign__c=TestCampaign.id,
                                      Batch_Size__c =2
                                     );
        insert(testSMSBatch); 
        /*Task task = new Task(
                Subject= 'SMS', 
                RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId(),
                Activity_Status__c = 'Need Verification',
                Phone__c = '18611445766',
                WhoId = testPerCon.Id,
                WhatId = TestCampaign.id,
                ActivityDate = date.today(),
                SMS_Content__c = 'testaaa',
                SMSTemplateID__c = tcSMS.id);
        insert(task); */
        Test.startTest();
        SMSBatchService.ActiveAll(TestCampaign.id);
        Test.stopTest();
       
    }
    public static testMethod void testSuspendAll() {
        
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        
        // Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678910',
                                      RecordTypeId=paid
                                     );
        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Salutation = 'mr',
                                         MobilePhone='1234567',
                                         SMSOptOut__c=false,
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon); 
        //SMSTestRecipient__c
        TestRecipientGroup__c testRecipientGroup = new TestRecipientGroup__c(IsActive__c=true
                                     );
        insert(testRecipientGroup); 
        SMSTestRecipient__c testRecipient = new SMSTestRecipient__c(TestRecipientName__c=testPerCon.id,
                                      TestRecipientGroup__c=testRecipientGroup.id
                                     );
        insert(testRecipient); 
        // SMS Template
        Id smsTem_RecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq',Message_Detail__c='lalala Test 001{CONTACT_NAME}aaaa{CONTACT_SALUTATION}22222{CONTACT_NAME}rege{CONTACT_SALUTATION}');
        insert(tcSMS); 
        // Campaign
        Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();                       
        Campaign TestCampaign = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA5',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             Template__c=tcSMS.id,
                                             Execution_Type__c='SMS',
                                             Create_Unique_Code__c=true,
                                             RecordTypeId=centCampaignRT);  
        insert(TestCampaign); 
        //SMS_Batch__c
        SMS_Batch__c testSMSBatch = new SMS_Batch__c(Batch_Start__c=DateTime.now().addSeconds(2),
                                      Batch_Status__c='new',
                                      TestRecipientGroup__c=testRecipientGroup.id,
                                      Campaign__c=TestCampaign.id,
                                      Batch_Size__c =2
                                     );
        insert(testSMSBatch); 
        Task task = new Task(
                Subject= 'SMS', 
                RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId(),
                Activity_Status__c = 'Need Verification',
                Phone__c = '18611445766',
                WhoId = testPerCon.Id,
                WhatId = TestCampaign.id,
                ActivityDate = date.today(),
                SMS_Content__c = 'testaaa',
                SMSTemplateID__c = tcSMS.id);
        insert(task); 
        Test.startTest();
        SMSBatchService.ActiveAll(TestCampaign.id);
        SMSBatchService.SuspendAll(TestCampaign.id);
        Test.stopTest();
       
    }
    public static testMethod void testError() {
        // SMS Template
        Id smsTem_RecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq',Message_Detail__c='lalala Test 001{CONTACT_NAME}aaaa{CONTACT_SALUTATION}22222{CONTACT_NAME}rege{CONTACT_SALUTATION}');
        insert(tcSMS); 
        // Campaign
        Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();                       
        Campaign TestCampaign = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA5',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             Template__c=tcSMS.id,
                                             Execution_Type__c='SMS',
                                             RecordTypeId=centCampaignRT);  
        insert(TestCampaign); 
        Test.startTest();
        SMSBatchService.ActiveAll(TestCampaign.id);
        SMSBatchService.SuspendAll(TestCampaign.id);
        Test.stopTest();
    }
    
    public static testMethod void testBigData() {
        TestRecipientGroup__c testRecipientGroup = new TestRecipientGroup__c(IsActive__c=true
                                     );
        insert(testRecipientGroup); 
        Id paid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Id smsTem_RecordTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();                       
        Account testPerAcc = new Account(LastName='TEST ACC',
                              Type='Company',
                              Status__c='VIP',
                              Province__c='Shanghai',
                              City_CN__c='宝山区',
                              ZipCode__c='123456',
                              PersonMobilePhone='12345678910',
                              RecordTypeId=paid
                             );
        // Contact 

        
        Contact testPerCon = new Contact(LastName='TEST ACC',
                                         AccountId = testPerAcc.Id,
                                         email = '11@11.com',
                                         Salutation = 'mr',
                                         MobilePhone='1234567',
                                         SMSOptOut__c=false,
                                         Phone='12345678910');
        insert(testPerAcc);
        insert(testPerCon); 
        //SMSTestRecipient__c

        SMSTestRecipient__c testRecipient = new SMSTestRecipient__c(TestRecipientName__c=testPerCon.id,
                                      TestRecipientGroup__c=testRecipientGroup.id
                                     );
        insert(testRecipient); 

    
        // SMS Template
        Template__c tcSMS = new Template__c(Name='TEST CAMPAIGN TEMPLATE', RecordTypeId=smsTem_RecordTypeId, Active__c=True, Type__c='Price List', Car_Series__c='A-Class', Template_ID__c='a0lO0000000LOKq',Message_Detail__c='lalala Test 001{CONTACT_NAME}aaaa{CONTACT_SALUTATION}22222{CONTACT_NAME}rege{CONTACT_SALUTATION}');
        insert(tcSMS); 
        // Campaign
        
        Campaign TestCampaign = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA2',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             Template__c=tcSMS.id,
                                             Execution_Type__c='SMS',
                                             RecordTypeId=centCampaignRT);  
        insert(TestCampaign); 
        Lead__c testLead = new Lead__c(
                                       CAC_Lead_Status__c='Assigned',
                                       Lead_Type__c='New Car',
                                       Lead_Desired_Service__c='Buy',
                                       Purchase_Time__c='No Plans',
                                       Interested_Vehicle_Brand__c='Smart',
                                       Interested_Vehicle_Class__c='Smart',
                                       Interested_Vehicle_Model__c='Other',
                                       Interested_Vehicle_Tridion_Cell_Colour__c='40 黑色',
                                       Interested_Vehicle_Interior_Color__c='黑色',
                                       Contact__c=testPerAcc.Id);

        insert(testLead);
        //insert(testPerCon);                                 

        
        // Campaign Lead Initial
        Campaign_Lead__c testCamLead1 = new Campaign_Lead__c(Campaign__c = TestCampaign.Id,Lead__c = testLead.Id);
        insert(testCamLead1);
         list<Task> taskList = new list<Task>();
        for (Integer i = 0; i < 70; i++) {
            taskList.add(new Task(
            Subject= 'SMS', 
            RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('SMS').getRecordTypeId(),
            Activity_Status__c = 'Need Verification',
            Phone__c = '18611445766',
            WhoId = testPerCon.Id,
            WhatId = TestCampaign.id,
            ActivityDate = date.today(),
            SMS_Content__c = 'testaaa',
            SMSTemplateID__c = tcSMS.id)
            );
            
        }
        insert(taskList);
        //SMS_Batch__c
        SMS_Batch__c testSMSBatch = new SMS_Batch__c(Batch_Start__c=DateTime.now().addSeconds(2),
                                      Batch_Status__c='new',
                                      TestRecipientGroup__c=testRecipientGroup.id,
                                      Campaign__c=TestCampaign.id,
                                      Batch_Size__c =200
                                     );
        insert(testSMSBatch); 
        Test.startTest();
        SMSBatchService.ActiveAll(TestCampaign.id);
        Test.stopTest();
       
    }
}