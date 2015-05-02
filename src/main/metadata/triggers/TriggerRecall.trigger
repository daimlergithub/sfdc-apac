/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes ?Recall? flag on related vehicle, vehicle relationship and customer record automatically. 
                2.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags ?Recall? on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Lio Huang Created on 2013-11-05
    2. Sichao Lai Created on 2013-06-07
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerRecallTriggerHandler
*/
trigger TriggerRecall on Recall__c (after insert,before Delete) 
{
    TriggerUtil.handleTrigger('TriggerRecall');
}