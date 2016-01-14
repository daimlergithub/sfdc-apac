/*
    Type:       Trigger
    Purpose:    1. Retail Campaign Member can not dup.
                
    User Story: Release 1.2
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2014-06-019
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerRetailCampaignMemberHandler
*/
public class TriggerRetailCampaignMemberHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Retail_Campaign_Member__c> oldmap = (Map<Id,Retail_Campaign_Member__c>)trigger.oldmap;
        Map<Id,Retail_Campaign_Member__c> newmap = (Map<Id,Retail_Campaign_Member__c>)trigger.newmap;
        
        if(trigger.isBefore && trigger.isInsert)
        {
            RetailCampaignMemberHelper.retailCampaignMemberDuplicateCheck(Trigger.new); 
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}