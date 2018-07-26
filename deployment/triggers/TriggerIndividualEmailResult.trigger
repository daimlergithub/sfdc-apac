/**
** Trigger on IndividualEmailResult
   Created By : Dhanamjaya Damaragunta
**/
trigger TriggerIndividualEmailResult on et4ae5__IndividualEmailResult__c (after insert,after update/*,before insert,before update*/)
{
TriggerUtil.handleTrigger('TriggerIndividualEmailResult');   
}