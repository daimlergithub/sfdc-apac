trigger IntegrationPicklistBeforeTrigger on Integration_Picklist__c (before insert) {
    PicklistMappingHelper.updateExternalKey(Trigger.new, 'IP');
}