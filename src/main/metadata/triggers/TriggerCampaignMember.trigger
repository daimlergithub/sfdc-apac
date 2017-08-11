trigger TriggerCampaignMember on CampaignMember (after delete, after insert, after update, before delete, before insert, before update) 
{
	TriggerUtil.handleTrigger('TriggerCampaignMember');    
}