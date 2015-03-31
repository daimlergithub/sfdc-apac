/*
    Type:       Trigger
    Purpose:    Generate Campaign Package History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
*/
trigger TriggerCampaignPackage on Campaign_Package__c (after insert, after update, before delete) 
{
    if (!UtilCustomSettings.isEnabled('TriggerCampaignPackage'))
    {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        CampaignPackageHelper.GenerateCampaignPackageHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        CampaignPackageHelper.GenerateCampaignPackageHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
    if(trigger.isBefore && trigger.isdelete)
    {
        CampaignPackageHelper.GenerateCampaignPackageHistoryLOG(trigger.new,trigger.old,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}