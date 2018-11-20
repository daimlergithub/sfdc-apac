public class UserTriggerHandlerIN implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    Map<Id,User> oldmap = (Map<Id,User>)trigger.oldmap;
        Map<Id,User> newmap = (Map<Id,User>)trigger.newmap;
    if(Trigger.isAfter && trigger.isInsert){
     
        UserHelper.InvokePermissionHandlerForUserCreation((List<User>)Trigger.new);
      }
        if(Trigger.isAfter && trigger.isUpdate){
             UserHelper.InvokePermissionHandler((List<User>)Trigger.new);
            
        }
    
    if(Trigger.isAfter && (trigger.isUpdate||trigger.isInsert)){
            UserHelperIN.shareRecordsAfterInsertAndUpdate(Trigger.new,label.IN);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}