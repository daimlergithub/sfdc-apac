/*
    Type:      Trigger
    Purpose:   1.Update record id for customer/VR
 
*/
trigger TriggerInsightResponse on Insights_Response__c (before insert, before update,before delete, after insert, after update,after delete) {
TriggerUtil.handleTrigger('TriggerInsightResponse');
}