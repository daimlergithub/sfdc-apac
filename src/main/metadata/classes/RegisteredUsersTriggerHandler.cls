public class RegisteredUsersTriggerHandler
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    if(trigger.isInsert && trigger.isAfter){
        RegisteredUsersTriggerHelper.submitForApproval(trigger.new);        
    }
    if(trigger.isupdate && trigger.isAfter){
        
        RegisteredUsersTriggerHelper.communityUserCreation((Registered_users__c)trigger.new[0]);        
    }    
    
       
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}