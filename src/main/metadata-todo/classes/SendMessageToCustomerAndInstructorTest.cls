/**
 * This class contains unit tests for validating the behavior of 
 * SendMessageToCustomerAndInstructor trigger.
 */
@isTest
private class SendMessageToCustomerAndInstructorTest {

    static testMethod void testSendMessageToCustomerAndInstructor() {
        // Create test data
        String personalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account testAccount = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 2', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322343');
        Account testAccount2 = new Account(RecordTypeId = dealerAccRecordTypeId, Name = 'Test Dealer');
        insert new List<Account>{testAccount, testAccount2};
        
        User testPartnerUser = [select Id, Name from User where IsActive = true and ContactId != null limit 1];
        Id testUserId = testpartnerUser.Id;
        
        String mbdaLeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MBDA Leads').getRecordTypeId();
        String otherLeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        Lead__c testLead1 = new Lead__c(RecordTypeId = mbdaLeadRecordTypeId, Lead_Type__c = 'No Need Follow Up', CAC_Lead_Status__c = 'Plan to Purchase', Interested_Vehicle_Brand__c = 'Interested Vehicle Class', Contact__c = testAccount.Id, Recommended_Dealer__c = testAccount2.Id, Instructor__c = testUserId, Need_Contact__c = true, Visit_Dealer__c = true);
        Lead__c testLead2 = new Lead__c(RecordTypeId = mbdaLeadRecordTypeId, Lead_Type__c = 'No Need Follow Up', CAC_Lead_Status__c = 'Plan to Purchase', Interested_Vehicle_Brand__c = 'Interested Vehicle Class', Contact__c = testAccount.Id, Recommended_Dealer__c = testAccount2.Id, Instructor__c = testUserId, Visit_Dealer__c = true, Need_Contact__c = true);
        Lead__c testLead3 = new Lead__c(RecordTypeId = mbdaLeadRecordTypeId, Lead_Type__c = 'No Need Follow Up', CAC_Lead_Status__c = 'Plan to Purchase', Interested_Vehicle_Brand__c = 'Interested Vehicle Class', Contact__c = testAccount.Id, Recommended_Dealer__c = testAccount2.Id, Instructor__c = testUserId, Visit_Dealer__c = true, Need_Contact__c = true);
        Lead__c testLead4 = new Lead__c(RecordTypeId = otherLeadRecordTypeId, Contact__c = testAccount.Id);
        Lead__c testLead5 = new Lead__c(RecordTypeId = otherLeadRecordTypeId, Contact__c = testAccount.Id);
        insert new List<Lead__c>{testLead1, testLead2, testLead3, testLead4, testLead5};
        
        system.assertEquals(6, [select Id from Task where Subject = 'SMS' and Status = 'Closed'].size());
    }
}