/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
                
    Used By:  Mohammed Touseef Ahmed  
    ---------------------------------------------------------------
    History: 
    Created: 03-06-2017
   
*/
public class TriggerVehicleRelTriggerHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter){
        List<Vehicle_Relationship__c> vrNewList2 = Trigger.new;
        List<Vehicle_Relationship__c> vrNewList = new List<Vehicle_Relationship__c>();
        List<Vehicle_Relationship__c> vrOldList2 = Trigger.old;
        List<Vehicle_Relationship__c> vrOldList = new List<Vehicle_Relationship__c>();
        if(vrNewList2!=null && vrNewList2.size()>0)
        {
            for(Vehicle_Relationship__c vehRelNew: vrNewList2){
                if(vehRelNew.MD__c == 'TH' || vehRelNew.Market__c == 'TH'){
                    vrNewList.add(vehRelNew);
                }
            }
        }
        if(vrOldList2!=null && vrOldList2.size()>0)
        {
            for(Vehicle_Relationship__c vehRelOld : vrOldList2){
                if(vehRelOld.MD__c == 'TH' || vehRelOld.Market__c == 'TH'){
                    vrOldList.add(vehRelOld);
                }
            }
        }
        
        // Update Status , Update Vehicle Relationship and Create Account Link 
        /*
         * Added By: Mohammed Touseef Ahmed
         * Desc: trigger hanler code for sharing record creation for after insert and after update event
         * Updated: march 4th, 2017
         */
        if(!vrNewList.isEmpty() && vrNewList.size() > 0){
            if (Trigger.isBefore && Trigger.isUpdate){
                UtilVehicleRelationship.updatemarket(vrNewList);
            }
            if (trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperTH.OnAfterInsert(vrNewList);
                VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vrNewList, true);
            }
            if (trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperTH.OnAfterUpdate(vrNewList, oldmapVehicleRelship);
                VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vrNewList, false);
            }
        }
        if (!vrOldList.isEmpty() && vrOldList.size() > 0 && trigger.isAfter && Trigger.isDelete){
            VehicleRelationshipHelperTH.OnAfterDelete(vrOldList);
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter){
        List<Vehicle_Relationship__c> vehicleNewList2 = Trigger.new;
        List<Vehicle_Relationship__c> vehicleNewList = new List<Vehicle_Relationship__c>();
        List<Vehicle_Relationship__c> vehicleOldList2 = Trigger.old;
        List<Vehicle_Relationship__c> vehicleOldList = new List<Vehicle_Relationship__c>();
        if(vehicleNewList2!=null && vehicleNewList2.size()>0)
        {
            for(Vehicle_Relationship__c vrNew: vehicleNewList2){
                if(vrNew.MD__c == 'TH' || vrNew.Market__c == 'TH'){
                    vehicleNewList.add(vrNew);
                }
            }
        }
        if(vehicleOldList2!=null && vehicleOldList2.size()>0)
        {
            for(Vehicle_Relationship__c vrOld : vehicleOldList2){
                if(vrOld.MD__c == 'TH' || vrOld.Market__c == 'TH'){
                    vehicleOldList.add(vrOld);
                }
            }
        }
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0) 
        {
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperTH.OnAfterInsert(vehicleNewList);
                VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vehicleNewList, true);
            }
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperTH.OnAfterUpdate(vehicleNewList, oldmapVehicleRelship);
                VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vehicleNewList, false);
            }
        }
        if(!vehicleOldList.isEmpty() && vehicleOldList.size() > 0 && trigger.isAfter && Trigger.isDelete){
            VehicleRelationshipHelperTH.OnAfterDelete(vehicleOldList);
        }           
    }
}