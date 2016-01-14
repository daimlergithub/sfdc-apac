/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes ?Recall? flag on related vehicle, vehicle relationship and customer record automatically. 
                2.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags ?Recall? on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Lio Huang Created on 2013-11-05
    2. Sichao Lai Created on 2013-06-07
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerRecallTriggerHandler
*/
public class TriggerRecallTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Recall__c> oldmap = (Map<Id,Recall__c>)trigger.oldmap;
        Map<Id,Recall__c> newmap = (Map<Id,Recall__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        { 
            RecallHelper.AfterInsertEvent(Trigger.new);
        }
        if(trigger.isbefore && trigger.isDelete)
        {
            RecallHelper.beforeDeleteEvent(Trigger.old);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}