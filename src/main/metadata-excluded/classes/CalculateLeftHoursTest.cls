/**
 * This class contains unit tests for validating the behavior of Apex trigger CalculateLeftHours
 */
@isTest
private class CalculateLeftHoursTest {

    static testMethod void testCalculateLeftHours() {
        // Create personal account
        String personalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account testPersonalAccount1 = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 29', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322943');
        Account testPersonalAccount2 = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 29', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322943');
        insert new List<Account>{testPersonalAccount1, testPersonalAccount2};
        // Create orders
        String mbdaOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MBDA Order').getRecordTypeId();
        Order testOrder1 = new Order(AccountId = testPersonalAccount1.Id, Status = '未付款', EffectiveDate = Date.today().addDays(5), MBDA_Vehicle_Model__c = 'B-Class', Payment_type__c = '汇款');
        Order testOrder2 = new Order(AccountId = testPersonalAccount2.Id, Status = '未付款', EffectiveDate = Date.today().addDays(5), MBDA_Vehicle_Model__c = 'B-Class', Payment_type__c = '汇款');
        insert new List<Order>{testOrder1, testOrder2};
        
        //system.assertEquals(0, [select Id, LeftHours__c from Order where Id = :testOrder1.Id].LeftHours__c);
    }
}