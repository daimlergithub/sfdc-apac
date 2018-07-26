/**
** Trigger on Vehicle__c 
** Created By: Dhanamjaya Damaragunta
** Date: 06-06-2018
** This trigger will shares Vehicle Products Records to the Dealers and its subordinates
**/

trigger TriggerVehicle on Vehicle__c (before insert, before update, after insert, after update) 
{
    TriggerUtil.handleTrigger('TriggerVehicle');
}