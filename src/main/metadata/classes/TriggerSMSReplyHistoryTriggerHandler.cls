/*
    Type:       Trigger on SMS Replay History
    Purpose:    Send next SMS according to the user reply.
    User Story: 
    ---------------------------------------------------------------
    History:
    
    1. Justin Created on 2013-11-28
    2. Justin Updated on 2014-03-21
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerSMSReplyHistoryTriggerHandler
*/
public class TriggerSMSReplyHistoryTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,SMSReplyHistory__c> oldmap = (Map<Id,SMSReplyHistory__c>)trigger.oldmap;
        Map<Id,SMSReplyHistory__c> newmap = (Map<Id,SMSReplyHistory__c>)trigger.newmap;
        
        if(trigger.isBefore && trigger.isInsert)
        {
            SMSReplyHistoryHelper.beforeInsertEvents(Trigger.new);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}