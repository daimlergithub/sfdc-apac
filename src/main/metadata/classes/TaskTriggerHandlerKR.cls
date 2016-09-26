public class TaskTriggerHandlerKR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        if(trigger.isAfter && trigger.isInsert)
        {
            if (TriggerUtil.isTriggerEnabled('TriggerTask'))
            TaskHelper.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
            TaskHelperKR.updateAccountMobile(trigger.new);
        }
         if(trigger.isBefore && trigger.isInsert)
        {
            TaskHelperKR.updateAccountMobile(trigger.new); 
            TaskHelperKR.CustomerConsenment(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TaskHelperKR.updateAccountMobile(trigger.new); 
            //TaskHelperKR.CustomerConsenment(trigger.new);  
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to be added as required in market.
    }
}