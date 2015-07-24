public class TriggerSurveyQuestionResponseHandler 
implements TriggerHandlerIf
{
    public void handleTrigger()
    {
		if (trigger.isAfter && (trigger.isInsert || trigger.isDelete )) {
            // Call the method
            if(Trigger.isInsert)
             UtilSurveyQuestionResponse.countSurveyQuestionResponseRecordsOnParent(trigger.new);
            else 
            UtilSurveyQuestionResponse.countSurveyQuestionResponseRecordsOnParent(trigger.Old);
        }
    }
}