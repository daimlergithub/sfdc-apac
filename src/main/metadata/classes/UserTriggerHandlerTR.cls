public class UserTriggerHandlerTR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){

    if(Trigger.isAfter && (trigger.isUpdate||trigger.isInsert)){
            
            UserHelperTR.shareRecordsAfterInsertAndUpdate(Trigger.new,label.TR);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}