public class TriggerCampaignTriggerHandlerKR implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate); 
            CampaignHelper.shareCampaignPlainingAndDesignRecordsWithDealers(Trigger.new);  
            CampaignHelper.afterInsertSharefromSCtoMan(Trigger.new);            
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignHelper.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);
        }
        if(trigger.isBefore && trigger.isUpdate){
          CampaignHelperBase.updatemarket(Trigger.New);
        }
    }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}