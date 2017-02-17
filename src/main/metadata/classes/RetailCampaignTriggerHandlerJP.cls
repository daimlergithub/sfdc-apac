public class RetailCampaignTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Trigger.isBefore && Trigger.isDelete)
        {
           RetailCampaignHelper.beforeDeleteEvents(Trigger.old);
            
        }
		 if(Trigger.isAfter && Trigger.isInsert)
        {
           RetailCampaignHelper.afterInsertCopyRetailCampaign(Trigger.New);
		   RetailCampaignHelper.emailNotificationRetail(Trigger.New); 
            
        } 
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}