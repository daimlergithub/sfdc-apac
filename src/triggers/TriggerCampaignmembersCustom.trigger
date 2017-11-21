trigger TriggerCampaignmembersCustom on Campaign_Member__c(after insert,after update,before insert,before update,before delete,after delete) 
{
    TriggerUtil.handleTrigger('TriggerCampaignmembersCustom');
}