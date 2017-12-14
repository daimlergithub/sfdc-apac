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
implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {

        // Update Status , Update Vehicle Relationship and Create Account Link 
        /*
         * Added By: Mohammed Touseef Ahmed
         * Desc: trigger hanler code for sharing record creation for after insert and after update event
         * Updated: march 4th, 2017
         */
        if (Trigger.isBefore && Trigger.isUpdate) {
            UtilVehicleRelationship.updatemarket(Trigger.New);
        }
        if (trigger.isAfter && (trigger.isInsert)) {
            VehicleRelationshipHelperTH.OnAfterInsert(Trigger.new);
            VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(Trigger.new, true);
        }
        if (trigger.isAfter && Trigger.isUpdate) {
            Map < Id, Vehicle_Relationship__c > oldmapVehicleRelship = (Map < Id, Vehicle_Relationship__c > ) Trigger.oldmap;
            VehicleRelationshipHelperTH.OnAfterUpdate(Trigger.new, oldmapVehicleRelship);
            VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(Trigger.new, false);
        }
        if (trigger.isAfter && Trigger.isDelete) {
            VehicleRelationshipHelperTH.OnAfterDelete(Trigger.old);
        }

    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        List < Vehicle_Relationship__c > vehicleNewList2 = Trigger.new;
        List < Vehicle_Relationship__c > vehicleNewList;
        for (Vehicle_Relationship__c vrTH: vehicleNewList2) {
            if (vrTH.MD__c == 'TH') {
                vehicleNewList.add(vrTH);
            }
        }

        if (!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0) {
            {
                if (trigger.isAfter && (trigger.isInsert)) {
                    VehicleRelationshipHelperTH.OnAfterInsert(vehicleNewList);
                    VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vehicleNewList, true);
                }
                if (trigger.isAfter && Trigger.isUpdate) {
                    Map < Id, Vehicle_Relationship__c > oldmapVehicleRelship = (Map < Id, Vehicle_Relationship__c > ) Trigger.oldmap;
                    VehicleRelationshipHelperTH.OnAfterUpdate(vehicleNewList, oldmapVehicleRelship);
                    VehicleRelationshipHelperTH.afterInsertSharerecordsWithDealers(vehicleNewList, false);
                }
                if (trigger.isAfter && Trigger.isDelete) {
                    VehicleRelationshipHelperTH.OnAfterDelete(Trigger.old);
                }
            }

        }
    }
}