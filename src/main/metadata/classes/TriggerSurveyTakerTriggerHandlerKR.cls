/*
Type:       Trigger on Survey Taken
Created By: Sudhir
Date: 		2017-05-12

*/

public class TriggerSurveyTakerTriggerHandlerKR implements TriggerHandlerIf
{
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
         	SurveyTakerHelperKR.shareSurverTakertoDealer(trigger.new);   
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
         	SurveyTakerHelperKR.shareSurverTakertoDealer(trigger.new);   
        }
    }
}