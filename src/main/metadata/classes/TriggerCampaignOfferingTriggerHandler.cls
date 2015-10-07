/*
    Type:       Trigger
    Purpose:    Generate Campaign Offering History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
    2.  Gerhard Henning on 2015-04-23 Moved code to TriggerCampaignOfferingTriggerHandler
*/
public class TriggerCampaignOfferingTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        
        
        if(trigger.isAfter && trigger.isInsert)
        {
            CampaignOfferingHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignOfferingHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
        if(trigger.isBefore && trigger.isdelete)
        {
            CampaignOfferingHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
    }
}