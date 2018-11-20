/*
    Type:       Test class for UtilRecordType
    Purpose:    Get Record Type Name By Id or Id by Name
    User Story: US-DD-002
    Used By:    
    History:   
    1. Mouse Created on 2013-4-10.

*/
@isTest
private class UtilRecordTypeTest {
   
    public static testMethod void testRecordTypeUtility() {
        // Test getRecordTypeIdByName method
        Id dealerRecordTypeId = UtilRecordType.getRecordTypeIdByName('Account', 'Dealer');
        Test.startTest();
        RecordType dealerRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Dealer'];
        System.assert(dealerRT.Id == dealerRecordTypeId);
        // Test getRecordTypeNameById method
        String recordTypeName = UtilRecordType.getRecordTypeNameById('Account', dealerRecordTypeId);
        System.assert(recordTypeName == 'Dealer');
        // Test getRecordTypeNameByName method
        String recordTypeName1 = UtilRecordType.getRecordTypeNameByName('Account', 'Dealer');
        // Test GetAvailableRecordTypeNamesForSObject method
		List<String> availableCaseTypes =  UtilRecordType.GetAvailableRecordTypeNamesForSObject(Opportunity.SObjectType );
        Test.stopTest();
        System.assert(recordTypeName == 'Dealer');
    }
}