/*
    Type:       Trigger
    Purpose:    1. Retail Campaign Member can not dup.
                
    User Story: Release 1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2014-06-019
*/
trigger TriggerRetailCampaignMember on Retail_Campaign_Member__c (before insert) 
{
    if (!TriggerUtil.isTriggerEnabled('TriggerRetailCampaignMember')) {
        return;
    }

    if(trigger.isBefore && trigger.isInsert)
    {
        RetailCampaignMemberHelper.retailCampaignMemberDuplicateCheck(Trigger.new); 
    }
}