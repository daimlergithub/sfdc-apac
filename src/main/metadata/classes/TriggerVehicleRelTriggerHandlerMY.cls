/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
                
    Used By:  Mohammed Touseef Ahmed  
    ---------------------------------------------------------------
    History: 
    Created: 09-20-2017
   
*/
public class TriggerVehicleRelTriggerHandlerMY 
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
       //Harshit added to check for User permission-Access Management- on 09-10-2017
      if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
          
       if(trigger.isAfter && (trigger.isInsert))
        {
          VehicleRelationshipHelperBase.OnAfterInsert(Trigger.new);          
        }
        if(trigger.isAfter && Trigger.isUpdate) {
          Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
          VehicleRelationshipHelperBase.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);         
        } 
       if(trigger.isAfter && Trigger.isDelete) {
          VehicleRelationshipHelperBase.OnAfterDelete(Trigger.old);
        } 
      }
     }
   public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      
    List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && vehicleNewList[0].MD__c == 'TH')
        {
       if(trigger.isAfter && (trigger.isInsert))
      {
        VehicleRelationshipHelperBase.OnAfterInsert(Trigger.new);
      }
        if(trigger.isAfter && Trigger.isUpdate) {
        Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
        VehicleRelationshipHelperBase.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
      } 
       if(trigger.isAfter && Trigger.isDelete) {
      VehicleRelationshipHelperBase.OnAfterDelete(Trigger.old);
      }
    }

    }
}