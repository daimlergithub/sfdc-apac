/**
** Wrap service for retail vehicle relationships to share.
** 1. Wraps "Vehicle Relationship Retail", share retail vehicle relationship to active users of owner dealer and 
**    active dealers with the same CRM Code as the owner dealer. 
**    (Dealer_DMS_CRM_Code__c of Owner_Dealer__c on retail vehicle relationship)
**
** Created By: CC
** Date: 2014-06-12
**/
public with sharing 
class VehicleRelationshipSharingWrapService {
    public VehicleRelationshipSharingWrapService() {
    }

    /**
    ** Checks the record type, only "Vehicle Relationship Retail" records should be wrapped and shared.
    **/
    public List<SharingWrapper> wrapRetailVehicleRelationships(List<Vehicle_Relationship__c> vehicleRelationships) {
        Id retailTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
        List<Vehicle_Relationship__c> retailRelationships = new List<Vehicle_Relationship__c>();
        for(Vehicle_Relationship__c vehicleRelationship : vehicleRelationships) {
            if(vehicleRelationship.RecordTypeId == retailTypeId) {
                retailRelationships.add(vehicleRelationship);
            }
        }
        return wrapVehicleRelationships(retailRelationships);
    }

    /**
    ** Wraps vehicle relationship records.
    **/
    private List<SharingWrapper> wrapVehicleRelationships(List<Vehicle_Relationship__c> vehicleRelationships) {
        List<Vehicle_Relationship__c> vehicleRelationshipRecords;
        vehicleRelationshipRecords = [select Id, Owner_Dealer__c, Owner_Dealer__r.Dealer_DMS_CRM_Code__c from Vehicle_Relationship__c where Id in :vehicleRelationships and Owner_Dealer__c != null and Vehicle_ID__c != null];
        // Maps crm codes to users who use the code.
        UserService userService = new UserService();
        Map<String, Set<Id>> crmCode2Users = userService.mapCrmCode2Users(vehicleRelationshipRecords);

        Map<Id, Set<Id>> relationship2Users = new Map<Id, Set<Id>>();
        for(Vehicle_Relationship__c vehicleRelationship : vehicleRelationshipRecords) {
            if(crmCode2Users.get(vehicleRelationship.Owner_Dealer__r.Dealer_DMS_CRM_Code__c) != null){
                relationship2Users.put(vehicleRelationship.Id, crmCode2Users.get(vehicleRelationship.Owner_Dealer__r.Dealer_DMS_CRM_Code__c));
            }
        }
        
        return SharingWrapperService.wrapSharings(relationship2Users, Schema.Vehicle_Relationship__Share.RowCause.Retail_Vehicle_Relationship_Share__c, 'Read');
    }
}