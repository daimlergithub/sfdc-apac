/**
 * This class contains unit tests for validating the behavior of trigger CreateOBTaskForMBDACase.
 */
@isTest
private class CreateOBTaskForMBDACaseTest {

    static testMethod void testCreateOBTaskForMBDACase() {
        // Create test data
        String mbdaComplaintId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MBDA Complaint').getRecordTypeId();
        String mbdaInquiryId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MBDA Inquiry').getRecordTypeId();
        String CAC_MBDA_QueueId = [select Id from Group where DeveloperName = 'CAC_MBDA' and Type = 'Queue' order by CreatedDate desc limit 1].Id;
        String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
        String personalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account testPersonalAccount = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 29', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322943');
        insert testPersonalAccount;
        
        Case testCase1 = new Case(RecordTypeId = mbdaComplaintId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 01', OwnerId = CAC_MBDA_QueueId);
        Case testCase2 = new Case(RecordTypeId = mbdaComplaintId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 02', OwnerId = CAC_MBDA_QueueId);
        Case testCase3 = new Case(RecordTypeId = mbdaInquiryId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 03', OwnerId = CAC_MBDA_QueueId);
        Case testCase4 = new Case(RecordTypeId = mbdaInquiryId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 04', OwnerId = CAC_MBDA_QueueId);
        Case testCase5 = new Case(RecordTypeId = mbdaInquiryId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 05');
        Case testCase6 = new Case(RecordTypeId = mbdaInquiryId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 06');
        Case testCase7 = new Case(RecordTypeId = mbdaInquiryId, AccountId = testPersonalAccount.Id, Car_Type__c = 'CBU', Status = 'Open', Subject = 'Test MBDA - 07');
        insert new List<Case>{testCase1, testCase2, testCase3, testCase4, testCase5, testCase6, testCase7};
        
        List<Task> obTasks = [select Id from Task where RecordTypeId = :OBTaskRecordTypeId];
        System.assertEquals(4, obTasks.size());
        
        update new List<Case>{new Case(Id = testCase5.Id, OwnerId = CAC_MBDA_QueueId), new Case(Id = testCase6.Id, OwnerId = CAC_MBDA_QueueId), new Case(Id = testCase7.Id, OwnerId = CAC_MBDA_QueueId)};
        List<Task> obTasks2 = [select Id from Task where RecordTypeId = :OBTaskRecordTypeId];
        System.assertEquals(7, obTasks2.size());
    }
}