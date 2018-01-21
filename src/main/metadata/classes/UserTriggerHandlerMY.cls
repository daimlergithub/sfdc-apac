public class UserTriggerHandlerMY implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    Map<Id,User> oldmap = (Map<Id,User>)trigger.oldmap;
        Map<Id,User> newmap = (Map<Id,User>)trigger.newmap;
    if(Trigger.isAfter&&trigger.isInsert){
			/*    if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){ 
					UserHelperMY.createGroup(Trigger.new);
					UserHelperMY.AfterInsertANDUpdateMethod(Trigger.new,Trigger.Isinsert,Trigger.isUpdate);
					UserHelperMY.ShareUsersToDealersAfterInsertAndUpdate(Trigger.new,Trigger.isupdate,trigger.old);
				}*/
			}
        if(Trigger.isAfter && trigger.isUpdate){
             UserHelper.InvokePermissionHandler((List<User>)Trigger.new);
            /*if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){ 
                UserHelperMY.ShareUsersToDealersAfterInsertAndUpdate(Trigger.new,Trigger.isupdate,trigger.old);
            }*/
			
        }
		
		if(Trigger.isAfter && (trigger.isUpdate||trigger.isInsert)){
            //UserHelperTH.ShareUsersToDealersAfterInsertAndUpdate(Trigger.new,Trigger.isupdate,trigger.old);
            UserHelperMY.shareRecordsAfterInsertAndUpdate(Trigger.new,label.MY);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}