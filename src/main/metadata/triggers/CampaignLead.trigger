trigger CampaignLead on Campaign_Lead__c(before insert, before update) 
{
    TriggerUtil.handleTrigger('TriggerCampaignLeads');
}