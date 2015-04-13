/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes ?Recall? flag on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Lio Huang Created on 2013-11-05
*/
/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags ?Recall? on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sichao Lai Created on 2013-06-07
*/
trigger TriggerRecall on Recall__c (after insert,before Delete) {
    
    if(trigger.isAfter && trigger.isInsert)
    { 
        if(UtilCustomSettings.isEnabled('RecallAfterInsertUpdate'))
            RecallHelper.AfterInsertEvent(Trigger.new);
    }
    if(trigger.isbefore && trigger.isDelete)
    {
        if(UtilCustomSettings.isEnabled('RecallBeforeDelete'))
            RecallHelper.beforeDeleteEvent(Trigger.old);
   }
}