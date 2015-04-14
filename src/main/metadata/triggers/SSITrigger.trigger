trigger SSITrigger on SSI__c (after update, after insert,before update, before insert) {
    if (!TriggerUtil.isTriggerEnabled('SSITrigger')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        // auto generate 2nd survey tasks when user upload ssi record by data loader, related US-SSI-014
        SSITriggerHandler.autoGenerate2ndSurveyTasks(Trigger.newMap, Trigger.oldMap);
        
        // auto calculate ssi data cleansing result
        //SSITriggerHandler.calculateDataCleansingResult(Trigger.newMap, Trigger.oldMap);   
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {
        SSITriggerHandler.fieldUpdates(Trigger.newMap, Trigger.oldMap);
        // field validate    
        SSITriggerHandler.fieldsValidationRule(Trigger.newMap, Trigger.oldMap);
    }
}