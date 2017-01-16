/*
    Type:       Trigger
    Purpose:    Campaign Member  
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignMembersTriggerHandler
*/
trigger TriggerCampaignMembers on CampaignMember (after insert) 
{
    TriggerUtil.handleTrigger('TriggerCampaignMembers');
}