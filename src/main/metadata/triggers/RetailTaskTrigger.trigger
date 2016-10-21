trigger RetailTaskTrigger on Retail_Task__c (before insert, before update,after insert, after update) 
{
    TriggerUtil.handleTrigger('RetailTaskTrigger');
}