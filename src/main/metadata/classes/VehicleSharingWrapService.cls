/**
* Wrap service for vehicles to share.
* 1. Wraps vehicle record linked by account link, find the CRM Code included in the account link "Name" and 
*    share the vehicle record to all active users of the active dealers with the CRM Code. 
* 2. Wraps vehicle record linked by retail vehicle relationship, share vehicle to active users of owner dealer 
*    and the active dealers with the same CRM Code.
*
* Created By: CC
* Date: 2014-06-12
*/
public with sharing class VehicleSharingWrapService {
	public VehicleSharingWrapService() {
	}
    
    /**
	*@Description :This mehtod gets account links link to vehicle then wraps those vehicles.
	*@Author :Shrinivas Desai.
	*@Date : 27/10/2015
	*@param: List of Account Link object records.
	*@return:This mehtod does not return any value.
	*@see:wrapVehicleFromAccountLinks (Constructor method)
	*/
	public List<SharingWrapper> wrapVehicleFromAccountLinks(List<Account_Link__c> accountLinks) {
        List<Account_Link__c> accountLinksWithVehicle = new List<Account_Link__c>();
        for(Account_Link__c accountLink : accountLinks) {
            if(accountLink.Vehicle__c != null){
                accountLinksWithVehicle.add(accountLink);
            }
        }
        UserService userService = new UserService();
        Map<String, Set<Id>> crmCode2Users = userService.mapCrmCode2Users(accountLinksWithVehicle);
        Map<Id, Set<Id>> vehicle2Users = new Map<Id, Set<Id>>();
        if(accountLinksWithVehicle!=Null){
	        for(Account_Link__c accountLink : accountLinksWithVehicle) {
	            if(vehicle2Users.get(accountLink.Vehicle__c) == null) {
	                vehicle2Users.put(accountLink.Vehicle__c, new Set<Id>{});
	            }
	            String crmCode = AccountLinkHelper.nameParsing(accountLink.Name);
	            if(crmCode2Users.containsKey(crmCode)) {
	                    vehicle2Users.get(accountLink.Vehicle__c).addAll(crmCode2Users.get(crmCode));
	            }
	        }
        }
        return SharingWrapperService.wrapSharings(vehicle2Users, Schema.Vehicle__Share.RowCause.Account_Link_Share__c,UtilConstant.read_Access);
    }
    
    /**
	*@Description :This mehtod gets "Vehicle Relationship Retail" records and wraps related vehicles.
	*@Author :Shrinivas Desai.
	*@Date : 27/10/2015
	*@param: List of Vehicle Relationship object records.
	*@return:This mehtod returns the wrapper of records to be shared.
	*@see:wrapVehicleFromRetailRelationships
	*/
    public List<SharingWrapper> wrapVehicleFromRetailRelationships(List<Vehicle_Relationship__c> vehicleRelationships) {
        List<Vehicle_Relationship__c> retailRelationships = new List<Vehicle_Relationship__c>();
        if(vehicleRelationships!=Null){
	        for(Vehicle_Relationship__c vehicleRelationship : vehicleRelationships) {
	            if(vehicleRelationship.RecordTypeId == UtilRecordType.getRecordTypeIdByName(UtilConstant.Vehicle_Relationship,UtilConstant.Vehicle_Relationship_Retail)) {
	                retailRelationships.add(vehicleRelationship);
	            }
	        }
        }
        return wrapVehicleFromRelationships(retailRelationships, Schema.Vehicle__Share.RowCause.Retail_Vehicle_Relationship_Share__c,UtilConstant.read_Access);
    }

     /**
	*@Description :This method returns Wraps of vehicles to share according to the vehicle relationship details.
	*@Author :Shrinivas Desai.
	*@Date : 27/10/2015
	*@param: List of Vehicle Relationship object records, Sharing access Level, Row Cause
	*@return:This mehtod returns the wrap of records to be shared with the associated sharing details.
	*@see:wrapVehicleFromRelationships
	*/
    public List<SharingWrapper> wrapVehicleFromRelationships(List<Vehicle_Relationship__c> vehicleRelationships, String rowCause, String accessLevel) {
        // Gets crm codes and maps them to active users.
        List<Vehicle_Relationship__c> vehicleRelationshipRecords;
        vehicleRelationshipRecords = [select Id, Vehicle_ID__c, Owner_Dealer__c, Owner_Dealer__r.Dealer_DMS_CRM_Code__c from Vehicle_Relationship__c where Id in :vehicleRelationships and Owner_Dealer__c != null and Owner_Dealer__r.Dealer_DMS_CRM_Code__c != null and Vehicle_ID__c != null];
        UserService userService = new UserService();
        Map<String, Set<Id>> crmCode2Users = userService.mapCrmCode2Users(vehicleRelationshipRecords);
        Map<Id, Set<Id>> vehicle2Users = new Map<Id, Set<Id>>();
        if(vehicleRelationshipRecords!=Null){
        for(Vehicle_Relationship__c vehicleRelationship : vehicleRelationshipRecords) {
            if(vehicle2Users.get(vehicleRelationship.Vehicle_ID__c) == null) {
                vehicle2Users.put(vehicleRelationship.Vehicle_ID__c, new Set<Id>{});
            }
            if(crmCode2Users.containsKey(vehicleRelationship.Owner_Dealer__r.Dealer_DMS_CRM_Code__c)){
                vehicle2Users.get(vehicleRelationship.Vehicle_ID__c).addAll(crmCode2Users.get(vehicleRelationship.Owner_Dealer__r.Dealer_DMS_CRM_Code__c));
            }
          }
        }

        System.debug('Wrap sharing Vehiclefrom Relationships...' +vehicle2Users);
        return SharingWrapperService.wrapSharings(vehicle2Users, rowCause, accessLevel);
    }
}