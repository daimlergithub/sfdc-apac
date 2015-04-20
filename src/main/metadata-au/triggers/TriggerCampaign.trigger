/*
    Type:       Trigger
    Purpose:    Create Task when campaign is active and recordtype = Campaign Execution  
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    28-May-2013 Stephano Shi (Breakingpoint)    Created
    23-Sept-2013 Tony Li (Breakingpoint)    Created
*/
trigger TriggerCampaign on Campaign (after insert, after update, before update) {
    if (!TriggerUtil.isTriggerEnabled('TriggerCampaign')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        CampaignHelper.afterInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isupdate);
        CampaignHelper.afterInsertEvents(Trigger.new);      
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        CampaignHelper.afterInsertUpdateEvents(Trigger.new,trigger.oldmap,trigger.isupdate);
        CampaignHelper.afterUpdateEvents(Trigger.new,Trigger.old);
        CampaignHelper.afterInsertEvents_CampaignShare(Trigger.new,Trigger.oldmap); 
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        CampaignHelper.beforeUpdateEvents(Trigger.new,trigger.oldmap);
    }
}