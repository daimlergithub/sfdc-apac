public class UserTriggerHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    /*if(Trigger.isAfter&&trigger.isInsert){
        UserHelperTH.createGroup(Trigger.new);
        UserHelperTH.AfterInsertANDUpdateMethod(Trigger.new,Trigger.Isinsert,Trigger.isUpdate);
        UserHelperTH.ShareUsersToDealersAfterInsertAndUpdate(Trigger.new,Trigger.isupdate,trigger.old);
    }*/
        if(Trigger.isAfter && (trigger.isUpdate||trigger.isInsert)){
            //UserHelperTH.ShareUsersToDealersAfterInsertAndUpdate(Trigger.new,Trigger.isupdate,trigger.old);
			//UserHelperTH.AddUserstoPGsTH(Trigger.newMap,Trigger.oldMap);
            UserHelperTH.shareRecordsAfterInsertAndUpdate(Trigger.newMap,Trigger.oldMap);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}