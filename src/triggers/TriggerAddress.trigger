/*
    Type:      Trigger
    Purpose:   1.Validates SameAddressType 
    Create By: Sriram kalluri
    Modified By : Mohammed Touseef Ahmed
    Modified Date: 03-12-2017
*/
trigger TriggerAddress on Address__c (before insert, before update,before delete, after insert, after update,after delete) {
    
    TriggerUtil.handleTrigger('TriggerAddress');
    TriggerUtil.handleTrigger('TriggerAddressTH');
}