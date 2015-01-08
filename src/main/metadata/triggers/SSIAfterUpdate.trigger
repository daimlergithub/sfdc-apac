trigger SSIAfterUpdate on SSI__c (after update) {
    if (!UtilCustomSettings.isEnabled('SSIAfterUpdate')) {
        return;
    }

    // reassign related ssi record ssi tasks owner
    //SSITriggerHandler.reassignSSITaskOwner(Trigger.newMap, Trigger.oldMap);
    
    // auto generate 2nd survey tasks when user upload ssi record by data loader, related US-SSI-014
    SSITriggerHandler.autoGenerate2ndSurveyTasks(Trigger.newMap, Trigger.oldMap);

    // auto calculate ssi data cleansing result
    SSITriggerHandler.calculateDataCleansingResult(Trigger.newMap, Trigger.oldMap);
    
}