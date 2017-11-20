/*********************************************************************************
	Class Name  : TriggerDMMaterialTriggerHandlerKR
	Created By   : 
	Created Date : 16th November 2017
	Project      : Daimler APAC
	Usages       : This a KR market triggerhandler class used to call the corresponding
				   Helper class to perform the required functionality for DM Material. 
	
 ***********************************************************************************/
public class TriggerDMMaterialTriggerHandlerKR 
	implements TriggerHandlerIf 
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	Map<Id,DM_Material__c> oldMap = (Map<Id,DM_Material__c>)trigger.oldmap;
    	list<DM_Material__c> newList = (list<DM_Material__c>)trigger.new;
    	if(isAfter && isInsert)
    	{
    		DMMaterialHelperKR.shareDMMaterialRecordsWithinDealership(trigger.new);
    	}
    	if(isAfter && isUpdate)
    	{
    		for(DM_Material__c dmMtrl : newList)
    		{
    			if(dmMtrl.OwnerId != oldmap.get(dmMtrl.Id).OwnerId)
	    		{
	    			DMMaterialHelperKR.shareDMMaterialRecordsWithinDealership(newList);
	    		}
    		}
    	}
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	
    }
}