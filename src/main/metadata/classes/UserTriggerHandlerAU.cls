public class UserTriggerHandlerAU implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    Map<Id,User> oldmap = (Map<Id,User>)trigger.oldmap;
        Map<Id,User> newmap = (Map<Id,User>)trigger.newmap;
        
        User usr = [Select Id,ProfileId,Profile.Name,market__c from User WHERE ID = : UserInfo.getUserId()];
        
    if(Trigger.isAfter && trigger.isInsert){
      
        UserHelper.InvokePermissionHandlerForUserCreation((List<User>)Trigger.new);
      }
        if(Trigger.isAfter && trigger.isUpdate){
             UserHelper.InvokePermissionHandler((List<User>)Trigger.new);
                
        }
    
    if(Trigger.isAfter && (trigger.isUpdate||trigger.isInsert)){            
            UserHelperAU.shareRecordsAfterInsertAndUpdate(Trigger.new,usr.Market__c);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}