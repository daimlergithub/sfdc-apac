trigger VehicleRelationshipAfter on Vehicle_Relationship__c (after insert) 
{
    if (!UtilCustomSettings.isEnabled('VehicleRelationshipAfter')) {
        return;
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
}