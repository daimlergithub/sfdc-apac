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
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
        Map<Id,Campaign_Package__c> oldmap = (Map<Id,Campaign_Package__c>)trigger.oldmap;
        Map<Id,Campaign_Package__c> newmap = (Map<Id,Campaign_Package__c>)trigger.newmap;
        
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
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}