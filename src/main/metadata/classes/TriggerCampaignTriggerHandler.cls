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
public class TriggerCampaignTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);
            CampaignHelper.afterInsertEvents(Trigger.new);      
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);
            CampaignHelper.afterUpdateEvents(Trigger.new,Trigger.old);
            CampaignHelper.afterInsertEvents_CampaignShare(Trigger.new,oldmap); 
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            CampaignHelperBase.updatemarket(Trigger.New);
            CampaignHelper.beforeUpdateEvents(Trigger.new,oldmap);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}