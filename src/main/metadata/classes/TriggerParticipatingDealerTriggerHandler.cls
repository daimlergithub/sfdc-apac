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
public class TriggerParticipatingDealerTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Participating_Dealer__c> oldmap = (Map<Id,Participating_Dealer__c>)trigger.oldmap;
        Map<Id,Participating_Dealer__c> newmap = (Map<Id,Participating_Dealer__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,newmap,oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
            if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
                return;
            }
            ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,newmap,oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
            if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
                return;
            }
            ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        }
        if(trigger.isBefore && trigger.isdelete)
        {
            ParticipatingDealerHelper.afterinsertUpdateDeleteEvents(Trigger.new,Trigger.old,newmap,oldmap,trigger.isAfter,trigger.isinsert,trigger.isupdate,trigger.isDelete);
            if (!TriggerUtil.isTriggerEnabled('TriggerCampaignParticipatingDealer')) {
                return;
            }
            ParticipatingDealerHelper.GenerateCampaignParticipatingDealerHistoryLOG(Trigger.new,Trigger.old,trigger.isinsert,trigger.isupdate,trigger.isDelete);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}