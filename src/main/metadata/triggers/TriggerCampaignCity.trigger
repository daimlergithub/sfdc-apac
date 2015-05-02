/*
    Type:       Trigger
    Purpose:    Delete all Participating_Dealer__c when the campaignCity is deleted 
    User Story: US-Cpn-002, US-Cpn-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignCityTriggerHandler
*/
trigger TriggerCampaignCity on Campaign_City__c (before delete) 
{
    TriggerUtil.handleTrigger('TriggerCampaignCity');
}