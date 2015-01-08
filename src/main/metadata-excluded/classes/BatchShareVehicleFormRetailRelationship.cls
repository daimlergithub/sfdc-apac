global class BatchShareVehicleFormRetailRelationship implements Database.Batchable<sObject> {
	
	global BatchShareVehicleFormRetailRelationship() {
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('select Id, RecordTypeId, Vehicle_ID__c from Vehicle_Relationship__c');
	}

   	global void execute(Database.BatchableContext BC, List<sObject> retailRelationships) {
		VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromRetailRelationships(retailRelationships));
        
        VehicleRelationshipSharingWrapService retailWrapService = new VehicleRelationshipSharingWrapService();
        SharingService.shareVehicleRelationships(retailWrapService.wrapRetailVehicleRelationships(retailRelationships));
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}