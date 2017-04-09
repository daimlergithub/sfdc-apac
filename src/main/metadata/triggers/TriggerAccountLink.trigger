/**
** Trigger on AccountLink Custom object
** Created By: CC
** Date: 2014-6-15
   Modified By : Mohammed Touseef AHmed
   Modified date : 03-12-2016
**/
trigger TriggerAccountLink on Account_Link__c (after insert,after update,before insert,before update) 
{
   TriggerUtil.handleTrigger('TriggerAccountLink');

}