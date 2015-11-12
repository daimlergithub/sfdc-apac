public class TriggerSurveyQuestionResponseHandler 
implements TriggerHandlerIf
{
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
	{
		if (trigger.isAfter && (trigger.isInsert || trigger.isDelete || trigger.isUpdate )) 
		{
			// Call the method
			if(Trigger.isInsert || Trigger.isUpdate)
			UtilSurveyQuestionResponse.countSurveyQuestionResponseRecordsOnParent(trigger.new);
			else 
			UtilSurveyQuestionResponse.countSurveyQuestionResponseRecordsOnParent(trigger.Old);
		}
	}
	public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}