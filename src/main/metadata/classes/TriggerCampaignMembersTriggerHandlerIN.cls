/**
* Utility for Trigger on Campaign Members for IN(India)
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/
public class TriggerCampaignMembersTriggerHandlerIN
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(isBefore && isInsert)
        {
            CampaignMemberHelperBase.updateCampaignMembermarket(trigger.new);
      campaignMemberHelperIN.beforeInsertevents(trigger.new);
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