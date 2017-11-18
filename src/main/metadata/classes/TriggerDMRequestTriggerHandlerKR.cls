/*********************************************************************************
	Class Name  : TriggerDMRequestTriggerHandlerKR
	Created By   : 
	Created Date : 17th November 2017
	Project      : Daimler APAC
	Usages       : This a KR market triggerhandler class used to call the corresponding
				   Helper class to perform the required functionality for DM Request. 
	
 ***********************************************************************************/
public class TriggerDMRequestTriggerHandlerKR 
	implements TriggerHandlerIf 
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	Map<Id,DM_Request__c> oldMap = (Map<Id,DM_Request__c>)trigger.oldmap;
    	list<DM_Request__c> newList = (list<DM_Request__c>)trigger.new;
    	DMRequestHelperJP.updateDMMaterialSentTotal(trigger.new,trigger.old,isUpdate,isBefore,isInsert,isAfter);
    	
    	if(isBefore && isInsert)
        {
            DMRequestHelperJP.InsertDMRequest(trigger.new,isInsert);         
            DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
        }
    	if (isBefore && isUpdate)
        { 
            DMRequestHelperJP.updateStatus(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isInsert,isUpdate);
            DMRequestHelperJP.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate);                        
        }
    	if(isAfter && isInsert)
    	{
    		DMRequestHelperKR.shareDMRequestRecordsWithinDealership(trigger.new);
    		DMRequestHelperJP.afterInsertEvent(trigger.new);
    	}
    	if(isAfter && isUpdate)
    	{
    		DMRequestHelperJP.afterUpdateEvent(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap);
    		for(DM_Request__c dmRqst : newList)
    		{
    			if(dmRqst.OwnerId != oldmap.get(dmRqst.Id).OwnerId)
	    		{
	    			DMRequestHelperKR.shareDMRequestRecordsWithinDealership(newList);
	    		}
    		}
    	}
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	
    }
}