public class CaseCommentTriggerHandlerTH implements TriggerHandlerIf {
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    	CaseCommentHelperTH.SendCaseCommentsToCOS(trigger.newMap);
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}