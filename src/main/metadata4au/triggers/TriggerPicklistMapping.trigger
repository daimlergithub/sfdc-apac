trigger TriggerPicklistMapping on Picklist_Mapping__c (before insert)
{
    if(trigger.isBefore && trigger.isInsert)
    {
        PicklistMappingHelper.updateExternalKey(Trigger.new, 'PM');
    }
}