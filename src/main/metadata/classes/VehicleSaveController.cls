public without sharing class VehicleSaveController
{
    public VehicleSaveController(List<Lead_details__c> allVehicles) {
         DMLManagerService.insertAsSystem(allVehicles);
    }
}