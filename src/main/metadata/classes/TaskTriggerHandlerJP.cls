public class TaskTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {       
          if(trigger.isBefore && trigger.isInsert)
        {
            TaskHelper.UpdateLinkedLeads(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);             
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TaskHelper.UpdateLinkedLeads(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);             
        }
    }        
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}