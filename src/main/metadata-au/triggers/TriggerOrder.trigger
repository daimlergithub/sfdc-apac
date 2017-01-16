trigger TriggerOrder on PreOrder__c (before insert,before update,after insert, after update, after delete) 
{
    TriggerUtil.handleTrigger('TriggerOrder');
}