/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:    1. If Vehicle_Relationship__c Validity has change, just assign the changed value to 
                corresponding Vehicle
                2.  share the VR record to "Portal Role and Subordinates" with read only. 
                    Partner Name should be Account Name + " " + "Partner Executive", e.g. ??????4S? Partner Executive
                3. Update Vehicle amount based on vehicle Relationship associated with an "Account".
                4. Update status of an "Account" record if related vechicle relationship has validity as "Yes".
                5. Create "Account_Link__C" Based on "Owner_Relation__c" field which describes relationship to the Purchaser, 
                    for Sales Contact Target related to the same vehicle.
              
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
        VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
        Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
        Map<Id,Vehicle_Relationship__c> oldmapVehicleRelation = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
         // US-CP-007
         if (trigger.isBefore && trigger.isInsert){
                //vrHelperJP.validateOverlappingVehicleRelationshiponInsert(trigger.new);
                VehicleRelationshipHelperJP.updatePortalApplyStatus(Trigger.New, new Map<Id,Vehicle_Relationship__c>());
         }
         if(trigger.isBefore && trigger.isUpdate){
                //vrHelperJP.validateOverlappingVehicleRelationshiponUpdate(trigger.new,oldmapVehicleRelation);
                VehicleRelationshipHelperJP.updatePortalApplyStatus(Trigger.New,(Map<Id,Vehicle_Relationship__c>) Trigger.oldMap);
                VehicleRelationshipHelperJP.beforeupdateEventAddress(Trigger.New,(Map<Id,Vehicle_Relationship__c>) Trigger.oldMap);
         }
       // Update Status , Update Vehicle Relationship and Create Account Link 
        /*
        * Added By: Siva Krishna
        * Desc: trigger hanler code for sharing record creation for after insert and after update event
        * Updated: Dec 12, 2016
        */
        Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
       if(trigger.isAfter && (trigger.isInsert))
        {
          VehicleRelationshipHelperJP.OnAfterInsert(Trigger.new);
          VehicleRelationshipHelperJP.afterInsertEvent(Trigger.new);
          VehicleRelationshipHelperJP.updateOnVehicleRelation(Trigger.new,oldmapVehicleRelship,true,false);
        }
        if(trigger.isAfter && Trigger.isUpdate) {
          
          
          if(LeadUtil.vrTrigger ){
          LeadUtil.accountTrigger = false;

          
          VehicleRelationshipHelperJP.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
          }
          
          
          VehicleRelationshipHelperJP.afterUpdateEvent(Trigger.new, oldmapVehicleRelship);
          VehicleRelationshipHelperJP.updateOnVehicleRelation(Trigger.new,oldmapVehicleRelship,true,false);
        } 
       if(trigger.isAfter && Trigger.isDelete) {
          VehicleRelationshipHelperJP.OnAfterDelete(Trigger.old);
        } 
    
     }
   public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {

      // Implementation to addedd as required in market
         VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
        Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
        Map<Id,Vehicle_Relationship__c> oldmapVehicleRelation = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
         // US-CP-007
        /* if (trigger.isBefore && trigger.isInsert){
                vrHelperJP.validateOverlappingVehicleRelationshiponInsert(trigger.new);
                VehicleRelationshipHelperJP.updatePortalApplyStatus(Trigger.New, new Map<Id,Vehicle_Relationship__c>());
         }
         if(trigger.isBefore && trigger.isUpdate){
                vrHelperJP.validateOverlappingVehicleRelationshiponUpdate(trigger.new,oldmapVehicleRelation);
                VehicleRelationshipHelperJP.afterInsertEvent(Trigger.new);
                 VehicleRelationshipHelperJP.updatePortalApplyStatus(Trigger.New,(Map<Id,Vehicle_Relationship__c>) Trigger.oldMap);
         }*/
       // Update Status , Update Vehicle Relationship and Create Account Link     
      
        
       if(trigger.isAfter && (trigger.isInsert))
        {
          VehicleRelationshipHelperJP.OnAfterInsert(Trigger.new);
          VehicleRelationshipHelperJP.afterInsertEvent(Trigger.new);
          VehicleRelationshipHelperJP.updateOnVehicleRelation(Trigger.new,oldmapVehicleRelation,true,false);
          
        }
        if(trigger.isAfter && Trigger.isUpdate) {
          Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
          if(LeadUtil.vrTrigger ){
          LeadUtil.accountTrigger = false;          
          VehicleRelationshipHelperJP.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
          }
          
          VehicleRelationshipHelperJP.afterUpdateEvent(Trigger.new, oldmapVehicleRelship);
          VehicleRelationshipHelperJP.updateOnVehicleRelation(Trigger.new,oldmapVehicleRelation,true,false);
        } 
       if(trigger.isAfter && Trigger.isDelete) {
          VehicleRelationshipHelperJP.OnAfterDelete(Trigger.old);
        }
       
}
}
