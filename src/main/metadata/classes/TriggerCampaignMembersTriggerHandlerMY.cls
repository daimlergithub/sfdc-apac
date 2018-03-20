/*
    Type:       Trigger
    Purpose:    Campaign Member  
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    

*/
public class TriggerCampaignMembersTriggerHandlerMY
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(isBefore && isInsert)
        {
            CampaignMemberHelperBase.updateCampaignMembermarket(trigger.new);
			campaignMemberHelperMY.beforeInsertevents(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate){
           CampaignMemberHelperBase.updateCampaignMembermarket(Trigger.New);
		   
		 
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}