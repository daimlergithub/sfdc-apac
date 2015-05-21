/*
    Type:       Trigger
    Purpose:    Share Campaign according to the collaboration team object 
    User Story: US-Cpn-006
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
    2015-04-21 Gerhard Henning (NTTData)  Moved code to CampaignMemberAfterTriggerHandler
*/

trigger ShareCampaignByCollaboration on Collaboration_Team__c (before insert, before update, before delete, after insert) 
{
    TriggerUtil.handleTrigger('ShareCampaignByCollab');
    
    
}