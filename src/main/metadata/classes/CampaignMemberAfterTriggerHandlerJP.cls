/*
    Type:       Trigger 
    ---------------------------------------------------------------
    History:
    
    2014-02-18 Created by Justin Yu
    2015-04-21 Gerhard Henning (NTTData)  Moved code to CampaignMemberAfterTriggerHandler
*/
public class CampaignMemberAfterTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}