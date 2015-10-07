/*
    Type:       Trigger
    Purpose:    Generate Campaign Package History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
    2.  Gerhard Henning on 2015-04-23 Moved code to TriggerCampaignPackageTriggerHandler
*/
public class TriggerCampaignPackageTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        
        
        if(trigger.isAfter && trigger.isInsert)
        {
            CampaignPackageHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            CampaignPackageHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
        if(trigger.isBefore && trigger.isdelete)
        {
            CampaignPackageHelper.GenerateCampaignOfferingHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
        }
    }
}