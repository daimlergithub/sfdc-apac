trigger smartSSIBeforeUpdateInsert on smart_SSI__c (before update, before insert) {
    if (!UtilCustomSettings.isEnabled('smartSSIBeforeUpdateInsert')) {
        return;
    }
        
    if(Trigger.isUpdate){
        // fields update
        smartSSITriggerHandler.fieldUpdates(Trigger.newMap, Trigger.oldMap);
        
        // field validate    
        smartSSITriggerHandler.fieldsValidationRule(Trigger.newMap, Trigger.oldMap);
    }  
}