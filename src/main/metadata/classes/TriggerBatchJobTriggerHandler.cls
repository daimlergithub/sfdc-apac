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
public class TriggerBatchJobTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        if(trigger.isAfter)
        {
            BatchJobHelper.afterInsertEvents();  
        }
    }
}