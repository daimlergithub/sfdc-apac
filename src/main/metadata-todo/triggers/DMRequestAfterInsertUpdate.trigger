/*
    Type:       Trigger
    Purpose:    Auto modify SentTotal field on DM Material when DM Request Status changed to 'Sent'
    User Story: US-DM-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    11-Mar-2013 Chris Huang (Breakingpoint)    Created
*/
trigger DMRequestAfterInsertUpdate on DM_Request__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('DMRequestAfterInsertUpdate')) {
        return;
    }

    // update sent total
     DMRequestTriggerHandler.updateDaterialSentTotal(trigger.new, trigger.old);         
    
    // update activity status
    if(trigger.isUpdate){
        DMRequestTriggerHandler.updateActivityStatus(trigger.new);            
    }  
}