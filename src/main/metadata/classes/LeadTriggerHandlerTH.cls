public class LeadTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        LeadHelperTH leadRS= new LeadHelperTH();
                
        if(Trigger.isbefore && Trigger.isUpdate){
            leadRS.leadValidation(Trigger.new);
            leadRS.updateOwner(Trigger.new);   
        }
        
        if(Trigger.isbefore && Trigger.isinsert){
            leadRS.leadValidation(trigger.new);
            leadRS.updateOwnerwithDealer(Trigger.new);   
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    } 
}