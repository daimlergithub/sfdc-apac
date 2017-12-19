/**
* Utility for lead trigger handler for MY(Malaysia)
* Author: Honey
* Created Date : 2017-10-10
*/
public class LeadTriggerHandlerMY implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        boolean flag=true;
        LeadHelperMY leadRS= new LeadHelperMY();
        
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                
            if(Trigger.isbefore && Trigger.isUpdate){
                LeadHelperBase.updatemarket(Trigger.New);
                leadRS.updateAllWorkflowsActionsAfterInsert(Trigger.new,trigger.isupdate);
                leadRS.leadValidation(Trigger.new);
                
                leadRS.updateOwner(Trigger.new);   
            }
            
            if(Trigger.isbefore && Trigger.isinsert){
                leadRS.leadValidation(trigger.new);
                leadRS.updateOwnerwithDealer(Trigger.new);   
            }
            if(Trigger.isafter && Trigger.isinsert){
                 leadRS.updateAllWorkflowsActionsAfterInsert(Trigger.new,trigger.isupdate);  
            }
        }
  
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}