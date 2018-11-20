/**
** Trigger on IndividualEmailResult
   Description: Used to update status for Email__c
**/
trigger TriggerIndividualEmailResult on et4ae5__IndividualEmailResult__c (after insert,after update/*,before insert,before update*/)
{
TriggerUtil.handleTrigger('TriggerIndividualEmailResult');   
}