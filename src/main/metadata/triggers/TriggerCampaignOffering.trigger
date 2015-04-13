/*
    Type:       Trigger
    Purpose:    Generate Campaign Offering History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
*/
trigger TriggerCampaignOffering on Campaign_Offering__c (after insert, after update, before delete) {
    if (!UtilCustomSettings.isEnabled('TriggerCampaignOffering')) {
        return;
    }
    
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