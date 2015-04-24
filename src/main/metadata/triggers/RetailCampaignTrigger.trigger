trigger RetailCampaignTrigger on Retail_Campaign__c (before insert, before update,after insert, after update) 
{
    TriggerUtil.handleTrigger('RetailCampaignTrigger');
}