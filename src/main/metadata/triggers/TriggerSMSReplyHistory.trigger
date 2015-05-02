/*
    Type:       Trigger on SMS Replay History
    Purpose:    Send next SMS according to the user reply.
    User Story: 
    ---------------------------------------------------------------
    History:
    
    1. Justin Created on 2013-11-28
    2. Justin Updated on 2014-03-21
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerSMSReplyHistoryTriggerHandler
*/
trigger TriggerSMSReplyHistory on SMSReplyHistory__c (before insert) 
{
    TriggerUtil.handleTrigger('TriggerSMSReplyHistory');
}