/**
* Utility for Trigger on Campaign Members for TR(Turkey)
* Author: Hildaa
*/
public class TriggerCampaignMembersTriggerHandlerTR
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(isBefore && isInsert)
        {
            CampaignMemberHelperBase.updateCampaignMembermarket(trigger.new);
            campaignMemberHelperTR.beforeInsertevents(trigger.new);
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