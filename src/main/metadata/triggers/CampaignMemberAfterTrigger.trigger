/*
    Type:       Trigger 
    ---------------------------------------------------------------
    History:
    
    2014-02-18 Created by Justin Yu
    2015-04-21 Gerhard Henning (NTTData)  Moved code to CampaignMemberAfterTriggerHandler
*/
trigger CampaignMemberAfterTrigger on CampaignMember (after insert, after update) 
{
    TriggerUtil.handleTrigger('CampaignMemberAfterTrigger');
}