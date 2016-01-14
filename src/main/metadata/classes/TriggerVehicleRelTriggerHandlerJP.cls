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
public class TriggerVehicleRelTriggerHandlerJP 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Vehicle_Relationship__c> oldmap = (Map<Id,Vehicle_Relationship__c>)trigger.oldmap;
        Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
        VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
        
        system.debug('Entered handler...' +trigger.isBefore);
        system.debug('Entered handler1...' +isBefore);
        if(trigger.isBefore)
        {
            system.debug('Entered isBefore...' +trigger.isUpdate);
            // US-CP-007
            if (trigger.isInsert){
                system.debug('Entered insert block...');
                system.debug('Trigger Block...' +trigger.old);
                vrHelperJP.validateOverlappingVehicleRelationship(trigger.new, 'insert');
            }else if (trigger.isUpdate){
                system.debug('Entered update block...');
                system.debug('Trigger Block...' +Trigger.oldMap);
                vrHelperJP.validateOverlappingVehicleRelationship(trigger.new, 'update');
            }
            
        }
        
     }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
      // Implementation to addedd as required in market
    }
}