/**
 * This class contains unit tests for validating the behavior of trigger SumReservationDurationToOrder.
 */
@isTest
private class SumReservationDurationToOrderTest {

    static testMethod void testSumReservationDurationToOrder() {
    	
        String reservationEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MBDA-Reservation').getRecordTypeId();
        String personalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account testPersonalAccount = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 29', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322943');
        insert testPersonalAccount;
        
        String mbdaOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MBDA Order').getRecordTypeId(); 
        Order testOrder1 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Payment_type__c = '汇款', MBDA_Vehicle_Model__c = 'B-Class', EffectiveDate = Date.today().addDays(5));
        Order testOrder2 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Payment_type__c = '汇款', MBDA_Vehicle_Model__c = 'B-Class', EffectiveDate = Date.today().addDays(5));
        insert new Order[]{testOrder1, testOrder2};
        
        List<User> partnerUsers = [select Id, Name from User where ContactId != null and isActive = true limit 1];
        String partnerUserId;
        if(partnerUsers.size() > 0)
        {
            partnerUserId = partnerUsers[0].Id;
        }
        
        Id testPersonalContactId = [select Id, PersonContactId from Account where Id = :testPersonalAccount.Id limit 1].PersonContactId;
        
        Event testEvent1 = new Event(RecordTypeId = reservationEventRecordTypeId, OwnerId = partnerUserId, Subject = 'Test Reservation 1', StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(5), whatId = testOrder1.Id, WhoId = testPersonalContactId);
        Event testEvent2 = new Event(RecordTypeId = reservationEventRecordTypeId, OwnerId = partnerUserId, Subject = 'Test Reservation 1', StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(6), whatId = testOrder1.Id, WhoId = testPersonalContactId);
        Event testEvent3 = new Event(RecordTypeId = reservationEventRecordTypeId, OwnerId = partnerUserId, Subject = 'Test Reservation 1', StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(5), whatId = testOrder2.Id, WhoId = testPersonalContactId);
        Event testEvent4 = new Event(RecordTypeId = reservationEventRecordTypeId, OwnerId = partnerUserId, Subject = 'Test Reservation 1', StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(5), whatId = testOrder2.Id, WhoId = testPersonalContactId);
        insert new Event[]{testEvent1, testEvent2, testEvent3, testEvent4};
        
        system.assertEquals(11, [select Id, Used_hours__c from Order where Id = :testOrder1.Id].Used_hours__c);
        
        update new Event[]{new Event(Id = testEvent1.Id, StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(7)), new Event(Id = testEvent2.Id, StartDateTime = Datetime.now().addMonths(1), EndDateTime = Datetime.now().addMonths(1).addHours(8))};
        system.assertEquals(15, [select Id, Used_hours__c from Order where Id = :testOrder1.Id].Used_hours__c);
        
        delete new Event(Id = testEvent1.Id);
        
        system.assertEquals(8, [select Id, Used_hours__c from Order where Id = :testOrder1.Id].Used_hours__c);
    }
}