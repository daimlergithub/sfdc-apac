trigger ToolKitTrigger on Tool_Kit__c (before insert,before update, after insert, after update, after delete)
{
    TriggerUtil.handleTrigger('ToolKitTrigger');
}