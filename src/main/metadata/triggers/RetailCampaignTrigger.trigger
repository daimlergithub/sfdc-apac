trigger RetailCampaignTrigger on Retail_Campaign__c (before insert, before update,before delete,after insert, after update,after delete) 
{
    TriggerUtil.handleTrigger('RetailCampaignTrigger');
}