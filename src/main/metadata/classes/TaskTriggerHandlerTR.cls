/**
* Handler for Trigger on Task for TR(Turkey)
* Author: Hildaa
*/
public class TaskTriggerHandlerTR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    if(trigger.isInsert || trigger.isUpdate){
         
          TaskHelperTR.TaskFailBlacklist(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
         
         }
        if(trigger.isAfter && trigger.isInsert)
        {
            
              TaskHelperTR.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
               
            
        }
         
     if(trigger.isAfter && trigger.isUpdate)
        {
            
              TaskHelperTR.updateCampaignMemberStatus(Trigger.new,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
                    
        }
         if(trigger.isBefore && trigger.isInsert)
        {
            TaskHelperTR.updateAccountMobile(trigger.new); 
             TaskHelperTR.updateAssignees(Trigger.new); 
           
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TaskHelperTR.updateAccountMobile(trigger.new); 
             
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to be added as required in market.
    }
}