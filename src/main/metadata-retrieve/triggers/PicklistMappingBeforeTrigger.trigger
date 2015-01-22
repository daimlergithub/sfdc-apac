trigger PicklistMappingBeforeTrigger on Picklist_Mapping__c (before insert) {
    PicklistMappingHelper.updateExternalKey(Trigger.new, 'PM');
}