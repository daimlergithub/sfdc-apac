/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:    1. If Vehicle_Relationship__c Validity has change, just assign the changed value to 
                corresponding Vehicle
                2.  share the VR record to "Portal Role and Subordinates" with read only. 
                    Partner Name should be Account Name + " " + "Partner Executive", e.g. ??????4S? Partner Executive
    User Story: US-CP-008, US-CP-007,  ISSUE-0757
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-05
    2. Sinow Modified on 2013-06-20
    3. CC Modified on 2014-06-12
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerVehicleRelationshipTriggerHandler
*/
trigger TriggerVehicleRelationship on Vehicle_Relationship__c(after insert,after update, before update, before insert,after delete) 
{
    TriggerUtil.handleTrigger('TriggerVehicleRelationship');
}