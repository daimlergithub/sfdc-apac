public class TriggerSurveyQuestionResponseHandler 
implements TriggerHandlerIf
{
    public void handleTrigger()
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
}
