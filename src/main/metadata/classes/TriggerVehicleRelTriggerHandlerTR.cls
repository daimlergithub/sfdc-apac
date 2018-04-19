/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
             
    Used By:  Hildaa 
    
*/

public class TriggerVehicleRelTriggerHandlerTR implements TriggerHandlerIf{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){ 
       
        if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
            if(trigger.isBefore && Trigger.isUpdate){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperTR.OnAfterInsert(Trigger.new);          
            }
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperTR.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);         
            } 
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperTR.OnAfterDelete(Trigger.old);
            }
            if(trigger.isAfter && trigger.isInsert)
            {
                UtilVehicleRelationship.checkVehcileValidity(trigger.new);
                VehicleRelationshipHelper.shareVR(Trigger.new);
            }           
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && vehicleNewList[0].MD__c == Label.TR){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperTR.OnAfterInsert(Trigger.new);
            }
            if(trigger.isAfter && Trigger.isUpdate) {
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperTR.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
            }    
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperTR.OnAfterDelete(Trigger.old);
            }
        }
    }
}