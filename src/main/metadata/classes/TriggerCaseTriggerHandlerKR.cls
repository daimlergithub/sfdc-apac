public class TriggerCaseTriggerHandlerKR implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isInsert');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isUpdate');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
        }
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}