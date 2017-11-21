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
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Campaign_Offering__c> oldmap = (Map<Id,Campaign_Offering__c>)trigger.oldmap;
        Map<Id,Campaign_Offering__c> newmap = (Map<Id,Campaign_Offering__c>)trigger.newmap;
        
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
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}