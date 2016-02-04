/*
    Type:       Trigger
    Purpose:    Auto modify SentTotal field on DM Material when DM Request Status changed to 'Sent'
    User Story: US-DM-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    11-Mar-2013 Chris Huang (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerDMRequestTriggerHandler
*/
trigger TriggerDMRequest on DM_Request__c (after insert, after update,before insert,before update) 
{
    TriggerUtil.handleTrigger('TriggerDMRequest'); 
}