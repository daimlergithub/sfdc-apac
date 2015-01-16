trigger ExternalPicklistBeforeTrigger on External_Picklist__c (before insert) {
    PicklistMappingHelper.updateExternalKey(Trigger.new, 'EP');
}