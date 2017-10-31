/**
* Handler for Trigger on Campaign for TH(Thailand)
* Author: Bhushan
* Created Date : 2017-03-02
*/
public class TriggerCampaignTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        
        Map<Id,Campaign> oldmap = (Map<Id,Campaign>)trigger.oldmap;
        Map<Id,Campaign> newmap = (Map<Id,Campaign>)trigger.newmap;
         
     /* if(trigger.isUpdate || trigger.isInsert)
        {
            CampaignHelperTH.beforeUpdateEvents(Trigger.new,oldmap);      
        } */
        if(trigger.isUpdate)
        {
       CampaignHelperTH.beforeUpdateEvents(Trigger.new,oldmap);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
        
            CampaignHelperTH.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate); 
         //   CampaignHelperTH.afterInsertEvents_CampaignShare(Trigger.new,oldmap);
                 
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignHelperTH.afterInsertUpdateEvents(Trigger.new,oldmap,trigger.isupdate);
        }
  }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}