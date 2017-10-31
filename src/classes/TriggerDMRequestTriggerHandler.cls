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
public class TriggerDMRequestTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,DM_Request__c> oldmap = (Map<Id,DM_Request__c>)trigger.oldmap;
        Map<Id,DM_Request__c> newmap = (Map<Id,DM_Request__c>)trigger.newmap;
        
        // update sent total
        DMRequestTriggerHandler.updateDaterialSentTotal(trigger.new, trigger.old);         
        
        // update activity status
        if(trigger.isUpdate){
            DMRequestTriggerHandler.updateActivityStatus(trigger.new);            
        }  
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}