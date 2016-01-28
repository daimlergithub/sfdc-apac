/*
    Type:       Trigger
    Purpose:    Batch Job Auto Trigger  
    User Story: Campaign Execution Task Generation
    Used By:    
    ---------------------------------------------------------------
    History:

    24-June-2013  Stephano Shi (Breakingpoint)    Created
    23-September-2013  Tony Li (Breakingpoint)    Created
    2015-04-21 Gerhard Henning (NTTData)  Moved code to TriggerBatchJobTriggerHandler
*/
public class TriggerBatchJobTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        /*if(trigger.isAfter)
        {
            BatchJobHelper.afterInsertEvents();  
        }*/
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market specific implementation.
    }
	
	
}