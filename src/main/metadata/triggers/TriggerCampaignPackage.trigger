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
trigger TriggerCampaignPackage on Campaign_Package__c (after insert, after update, before delete) 
{
    TriggerUtil.handleTrigger('TriggerCampaignPackage');
}