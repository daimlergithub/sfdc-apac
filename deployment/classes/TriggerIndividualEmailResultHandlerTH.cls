public class TriggerIndividualEmailResultHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
    if(Trigger.isAfter&&(Trigger.isInsert||Trigger.isUpdate))
        IndividualEmailResultHelperTH.updateEmailSeStatus(Trigger.new);
}
 public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
 
 }

}