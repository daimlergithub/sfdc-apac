public class TaskTriggerHandlerKr implements TriggerHandlerIf {
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        if(trigger.isAfter && trigger.isInsert)
        {
            if (TriggerUtil.isTriggerEnabled('TriggerTask'))
            TaskHelper.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
            TaskHelperKr.updateAccountMobile(trigger.new);
        }
         if(trigger.isBefore && trigger.isInsert)
        {
        	TaskHelperKr.updateAccountMobile(trigger.new); 
            TaskHelperKr.CustomerConsenment(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
         	TaskHelperKr.updateAccountMobile(trigger.new); 
         	//TaskHelperKr.CustomerConsenment(trigger.new);  
        }
    }
   	
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}

