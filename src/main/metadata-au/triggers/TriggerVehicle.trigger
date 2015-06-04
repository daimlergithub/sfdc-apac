/*
    Type:       Trigger
    Purpose:    The vehicle object needs to be enhanced by a field called Vehicle Group.    
                
    User Story: US_AU-CD-001.2
*/
trigger TriggerVehicle on Vehicle__c (before insert, before update) {
    
    TriggerUtil.handleTrigger('TriggerVehicle');
}