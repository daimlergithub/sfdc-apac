public class TriggerDMRequestTriggerHandlerTH
    implements TriggerHandlerIf 
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Trigger.isBefore && Trigger.isInsert)
        {
            DMRequestHelperTH.InsertDMRequest(trigger.new,isInsert);         
            DMRequestHelperTH.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
        }
        
        if (Trigger.isBefore && Trigger.isUpdate)
        { 
            DMRequestHelperTH.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
            DMRequestHelperTH.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate);                        
        } 
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Trigger.isBefore && Trigger.isInsert)
        {
            DMRequestHelperTH.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
            DMRequestHelperTH.InsertDMRequest(trigger.new,isInsert);
        }
        
        if (Trigger.isBefore && Trigger.isUpdate)
        { 
            DMRequestHelperTH.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
            DMRequestHelperTH.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate);                        
        }
    }
}