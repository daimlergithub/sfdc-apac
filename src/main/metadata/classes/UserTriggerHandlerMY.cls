public class UserTriggerHandlerMY 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,User> oldmap = (Map<Id,User>)trigger.oldmap;
        Map<Id,User> newmap = (Map<Id,User>)trigger.newmap;
        
       
        if (trigger.isAfter && trigger.isUpdate) {
            
           
           UserHelper.InvokePermissionHandler((List<User>)Trigger.new);
          /* MRC_PermissionHandler mrcp=new MRC_PermissionHandler();
           mrcp.assignMarketBasedPermisionSetsToUsers((List<User>)Trigger.new);*/
           
        }
       
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}