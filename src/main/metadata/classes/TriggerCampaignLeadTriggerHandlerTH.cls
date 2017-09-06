public class TriggerCampaignLeadTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   CamapaignLeadsHelperTH campleads;    
          if(trigger.isBefore && (trigger.isInsert||trigger.isupdate))
        {
          campleads=new CamapaignLeadsHelperTH(); 
          campleads.updateCampaignleads(Trigger.new);           
        }
    }        
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}