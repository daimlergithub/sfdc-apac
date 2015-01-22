/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:    1. If Vehicle_Relationship__c Validity has change, just assign the changed value to 
                corresponding Vehicle
                2.  share the VR record to "Portal Role and Subordinates" with read only. 
                    Partner Name should be Account Name + " " + "Partner Executive", e.g. 北京梅赛德斯4S店 Partner Executive
    User Story: US-CP-008, US-CP-007,  ISSUE-0757
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-05
    2. Sinow Modified on 2013-06-20
    3. CC Modified on 2014-06-12
*/
trigger TriggerVehicleRelationship on Vehicle_Relationship__c(after insert, after update, before insert) {
    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerVehicleRelationship')) {
        return;
    }

    if (trigger.isAfter && trigger.isInsert) {
        // US-CP-007
        UtilVehicleRelationship.checkVehcileValidity(trigger.new);
    }

    if (trigger.isUpdate && trigger.isAfter) {
        // US-CP-008
        Set<Id> vehicleIds = new Set<Id>();
        for (Vehicle_Relationship__c relationship : trigger.new) {
            Vehicle_Relationship__c oldRelationship = trigger.oldMap.get(relationship.Id);
            if (oldRelationship.Validity__c != relationship.Validity__c) {
                vehicleIds.add(relationship.Vehicle_Id__c);
            }
            
            if (vehicleIds.size() > 0) {
                UtilVehicleRelationship.updateVehicle(vehicleIds);
            }
        }
    }
    
    if(Trigger.isInsert && trigger.isAfter) {
        //ISSUE-0757
        Map<ID, ID> VRIdOwnerDealerId = new Map<ID, ID>();
         Map<ID, ID> VRIdContactId = new Map<ID, ID>();
          Map<ID, ID> VRIdVehicleId = new Map<ID, ID>();
    
        for (Vehicle_Relationship__c vr : trigger.new) {
            if(vr.Owner_Dealer__c != null && vr.RecordTypeId == Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId()){
                VRIdOwnerDealerId.put(vr.id, vr.Owner_Dealer__c);
                VRIdContactId.put(vr.id, vr.Contact__c);
                VRIdVehicleId.put(vr.id, vr.Vehicle_ID__c);
            }
        }
        
        if (VRIdOwnerDealerId.size() > 0 ) {
            VehicleRelationshipHelper.shareVR(VRIdOwnerDealerId,VRIdContactId,VRIdVehicleId);
        }
    }

    // 1. Shares vehicle to active users of owner dealer and the active dealers with the same CRM Code if
    //    a new retail vehicle relationship is created
    // 2. Shares vehicle relationships to active users of owner dealer and active dealers with the same CRM 
    //    Code as the owner dealer.
    if(Trigger.isInsert && Trigger.isAfter){
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromRetailRelationships(Trigger.new));
        
        VehicleRelationshipSharingWrapService retailWrapService = new VehicleRelationshipSharingWrapService();
        SharingService.shareVehicleRelationships(retailWrapService.wrapRetailVehicleRelationships(Trigger.new));
    }
    
    // CR-000119
    
    //------------------Added by bing---------------------
    AccountSharingDataHandler handler = new AccountSharingDataHandler('Retail Vehicle RelationShip');
    if(Trigger.isAfter){
    	handler.shareAccountByRetailVR(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    }
    //------------------Added by bing---------------------
    /*
    if (Trigger.isInsert && trigger.isBefore ) {
        for (Vehicle_Relationship__c vr : trigger.new) {
            if (vr.Car_Relation__c == 'Owner') {
                vr.Validity__c = 'Yes';
            }
        }
    }
    */
}