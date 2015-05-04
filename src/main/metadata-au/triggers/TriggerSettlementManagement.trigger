/*
    Type:       Trigger
    Purpose:    1. Calculate Total amount when settlement is changed
                2. if Settlement Type = "No Settlement". Disable these fields in that case and default to 0 when saving.
    User Story: US-DPCR-001, Defect#1487
    Used By:    
    ---------------------------------------------------------------
    History:
    
    15-July-2013 Sinow Zhang (NTTData) Created
    6-May-2014   Cyril Huang (NTTData) Updated
    15-Oct-2013 Fanny Tang (NTTData) Created
    28-Apr-2014 Cyril Huang (NTTData) Updated
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerSettlementManagementHandler
*/
trigger TriggerSettlementManagement on Settlement_Management__c (after update, after insert,after delete,before update, before insert)
{
    TriggerUtil.handleTrigger('TriggerSettlementManagement');
}