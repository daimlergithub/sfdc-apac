/*
    Type:       Trigger
    Purpose:    Trigger when update/insert participating_dealer__c 
    User Story: US-Cpn-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerParticipatingDealerTriggerHandler
*/
trigger TriggerParticipatingDealer on Participating_Dealer__c (after insert, after update, before delete) 
{
    TriggerUtil.handleTrigger('TriggerParticipatingDealer');
}