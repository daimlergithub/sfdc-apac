public class TriggerCampaignTriggerHandlerKR implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);      
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);
        }
	}
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}