/*
    Type:       Trigger
    Purpose:    Create Task when campaign is active and recordtype = Campaign Execution  
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    28-May-2013 Stephano Shi (Breakingpoint)  Created
    23-Sept-2013 Tony Li (Breakingpoint)      Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignTriggerHandler
*/
trigger TriggerCampaign on Campaign (before insert ,after insert, after update, before update,before delete,after delete) 
{
    TriggerUtil.handleTrigger('TriggerCampaign');
}