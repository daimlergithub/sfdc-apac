/*
    Type:       Trigger
    Purpose:    Delete all Participating_Dealer__c when the campaignCity is deleted 
    User Story: US-Cpn-002, US-Cpn-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    08-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCampaignCityTriggerHandler
*/
public class TriggerCampaignCityTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}