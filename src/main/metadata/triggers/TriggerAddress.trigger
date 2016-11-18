/*
    Type:      Trigger
    Purpose:   1.Validates SameAddressType 
    Create By: Sriram kalluri
*/
trigger TriggerAddress on Address__c (before insert, before update, after insert, after update , After Delete) {
    
    TriggerUtil.handleTrigger('TriggerAddress');

}