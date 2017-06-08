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
        if(Trigger.isBefore && Trigger.isInsert)
        {
            DMRequestHelperJP.InsertDMRequest(trigger.new,isInsert);         
            DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
        }
        
        if (Trigger.isBefore && Trigger.isUpdate)
        { 
            DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
            DMRequestHelperJP.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate);                        
        }
        if (Trigger.isAfter && Trigger.isInsert){
        
             DMRequestHelperJP.afterInsertEvent(trigger.new);
        } 
        if (Trigger.isAfter && Trigger.isUpdate){
        
          DMRequestHelperJP.afterUpdateEvent(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap);
        
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        
			if(Trigger.isBefore && Trigger.isInsert)
			{
				DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
				DMRequestHelperJP.InsertDMRequest(trigger.new,isInsert);
			}
			
			if (Trigger.isBefore && Trigger.isUpdate)
			{ 
				DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
				DMRequestHelperJP.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate);                        
			}
			//Added changes related to SFDCJP-2609
			if (Trigger.isAfter && Trigger.isInsert){
        
             DMRequestHelperJP.afterInsertEvent(trigger.new);
           } 
		    if (Trigger.isAfter && Trigger.isUpdate)
			{
        
          DMRequestHelperJP.afterUpdateEvent(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap);
        
          }
    }
}