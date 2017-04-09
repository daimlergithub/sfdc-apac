/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
                
    Used By:  Mohammed Touseef Ahmed  
    ---------------------------------------------------------------
    History: 
    Created: 03-06-2017
   
*/
public class TriggerVehicleRelTriggerHandlerTH 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    { 
        
       // Update Status , Update Vehicle Relationship and Create Account Link 
        /*
        * Added By: Mohammed Touseef Ahmed
        * Desc: trigger hanler code for sharing record creation for after insert and after update event
        * Updated: march 4th, 2017
        */
       if(trigger.isAfter && (trigger.isInsert))
        {
          VehicleRelationshipHelperTH.OnAfterInsert(Trigger.new);          
        }
        if(trigger.isAfter && Trigger.isUpdate) {
          Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
          VehicleRelationshipHelperTH.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);         
        } 
       if(trigger.isAfter && Trigger.isDelete) {
          VehicleRelationshipHelperTH.OnAfterDelete(Trigger.old);
        } 
    
     }
   public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      
        
       if(trigger.isAfter && (trigger.isInsert))
        {
          VehicleRelationshipHelperTH.OnAfterInsert(Trigger.new);
        }
        if(trigger.isAfter && Trigger.isUpdate) {
          Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
          VehicleRelationshipHelperTH.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
        } 
       if(trigger.isAfter && Trigger.isDelete) {
          VehicleRelationshipHelperTH.OnAfterDelete(Trigger.old);
        }
    }
}