/*
    Type:       Trigger
    Purpose:    Trigger when update/insert participating_dealer__c 
    User Story: US-Cpn-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
*/

trigger TriggerParticipatingDealer on Participating_Dealer__c (after insert, after update, before delete) {
    if (!TriggerUtil.isTriggerEnabled('TriggerParticipatingDealer')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.newmap,Trigger.oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
            return;
        }
        ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.newmap,Trigger.oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
            return;
        }
        ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
    }
    if(trigger.isBefore && trigger.isdelete)
    {
        ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.newmap,Trigger.oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
            return;
        }
        ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
    }
}