trigger TriggerAccountLink on Account_Link__c (before insert,before update,after insert, after update, after delete) 
{
	TriggerUtil.handleTrigger('TriggerAccountLink');
}