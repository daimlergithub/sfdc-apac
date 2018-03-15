public class CaseCommentTriggerHandlerTH implements TriggerHandlerIf {
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    	if(trigger.Isafter)
        {
            if(trigger.IsInsert || trigger.IsUpdate)
                CaseCommentHelperTH.SendCaseCommentsToCOS(trigger.newMap);
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}