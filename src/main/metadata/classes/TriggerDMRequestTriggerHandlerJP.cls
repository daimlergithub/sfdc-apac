/*
    Type:       Trigger
    Purpose:    Auto modify SentTotal field on DM Material when DM Request Status changed to 'Sent'
    User Story: US-DM-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    11-Mar-2013 Chris Huang (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerDMRequestTriggerHandler
*/
public class TriggerDMRequestTriggerHandlerJP 
    implements TriggerHandlerIf 
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        
        // Implementation to addedd as required in market  
        
        if (Trigger.isBefore && Trigger.isUpdate){ 
            DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap);
            // DMRequestHelperJP.intigrationAPICheck(trigger.new);
            
        } 
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	
    	// Implementation to addedd as required in market
    	if ((Trigger.isBefore && Trigger.isUpdate)){
            DMRequestHelperJP.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
        }
    }
}