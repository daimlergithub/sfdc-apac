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
    public void handleTrigger()
    {
        
        
        // update sent total
        DMRequestTriggerHandler.updateDaterialSentTotal(trigger.new, (Map<Id,DM_Request__c>)trigger.oldmap);         
        
        // update activity status
        if(trigger.isUpdate){
            DMRequestTriggerHandler.updateActivityStatus((Map<Id,DM_Request__c>)trigger.newmap);            
        }  
    }
}