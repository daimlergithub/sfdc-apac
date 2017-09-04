/**
** Shares new retail tasks to dealers
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: CC
** Date: 2014-6-15
**/
public class TriggerRetailTaskTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
        {
            RetailTaskHelperJP.RetailTaskDetails(trigger.new,(map<id,retail_task__c>)trigger.oldmap,trigger.isInsert,trigger.isUpdate);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
        {
            RetailTaskHelperJP.RetailTaskDetails(trigger.new,(map<id,retail_task__c>)trigger.oldmap,trigger.isInsert,trigger.isUpdate);
        }
    }
}