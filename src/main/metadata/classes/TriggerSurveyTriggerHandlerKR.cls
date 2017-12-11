/*********************************************************************************
	Class Name  : TriggerSurveyTriggerHandlerKR
	Created By   : 
	Created Date : 8th December 2017
	Project      : Daimler APAC
	Usages       : This is KR market triggerhandler class used to call the corresponding
				   Helper class to perform the required functionality for Survey. 
	
 ***********************************************************************************/
public with sharing class TriggerSurveyTriggerHandlerKR 
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	if(isAfter && isInsert)
    	{
    		SurveyHelperKR.shareSurverWithDealer(trigger.new);
    	}
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	
    }
}