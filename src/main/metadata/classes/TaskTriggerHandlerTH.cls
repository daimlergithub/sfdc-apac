public class TaskTriggerHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    if(trigger.isInsert || trigger.isUpdate){
         
          TaskHelperTH.TaskFailBlacklist(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
         
         }
        if(trigger.isAfter && trigger.isInsert)
        {
            
              TaskHelperTH.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
               // TaskHelperTH.updateAccountMobile(trigger.new); 
            
        }
         
     if(trigger.isAfter && trigger.isUpdate)
        {
            
              TaskHelperTH.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
                    
        }
         if(trigger.isBefore && trigger.isInsert)
        {
            TaskHelperTH.updateAccountMobile(trigger.new); 
           // TaskHelperKR.CustomerConsenment(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TaskHelperTH.updateAccountMobile(trigger.new); 
            //TaskHelperKR.CustomerConsenment(trigger.new);  
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to be added as required in market.
    }
}