trigger SSITrigger on SSI__c (after update, after insert,before update, before insert) 
{
    TriggerUtil.handleTrigger('SSITrigger');
}