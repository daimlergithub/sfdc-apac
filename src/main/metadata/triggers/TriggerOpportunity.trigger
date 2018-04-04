/*
    Type:       Trigger
    Created By: Shashi Goswami 
    Date:       2018/03/28
*/
trigger TriggerOpportunity on Opportunity (before insert, before update, after update,after insert) 
{
    TriggerUtil.handleTrigger('TriggerOpportunity');
}