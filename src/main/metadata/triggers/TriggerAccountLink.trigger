trigger TriggerAccountLink on Account_Link__c (after insert,after update,before insert,before update) 
{
   TriggerUtil.handleTrigger('TriggerAccountLink');

}