/**
* Utility for lead trigger handler for TH(Thailand)
* Author: Dhanamjaya
* Created Date : 2017-01-23
*/
public class LeadTriggerHandlerTH implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    boolean flag=true;
        LeadHelperTH leadRS= new LeadHelperTH();
                
        if(Trigger.isbefore && Trigger.isUpdate){
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
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}