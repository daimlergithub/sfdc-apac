/*
    Type:       Trigger
    Purpose:    Batch Job Auto Trigger  
    User Story: Campaign Execution Task Generation
    Used By:    
    ---------------------------------------------------------------
    History:

  24-June-2013  Stephano Shi (Breakingpoint)    Created
  23-September-2013  Tony Li (Breakingpoint)    Created
*/
trigger TriggerBatchJob on Batch_Job__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('TriggerBatchJob')) {
        return;
    }

    if(trigger.isAfter)
    {
        BatchJobHelper.afterInsertEvents();  
    }
}