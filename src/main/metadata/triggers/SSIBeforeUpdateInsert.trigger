trigger SSIBeforeUpdateInsert on SSI__c (before update, before insert) {
    if (!UtilCustomSettings.isEnabled('SSIBeforeUpdateInsert')) {
        return;
    }
        
    if(Trigger.isUpdate){
        // fields update
        SSITriggerHandler.fieldUpdates(Trigger.newMap, Trigger.oldMap);
        
        // field validate    
        SSITriggerHandler.fieldsValidationRule(Trigger.newMap, Trigger.oldMap);
    }  
}