/*
    Type:       Helper class on Vehicle_Relationship__c
    Purpose:   
    1. Insert Update Delete Vehicle related details
    2. Update Account Status
    3. Update Vehicle Amount
    4. Create Account Link
                
    CreatedBY : Honey on 17th Oct 2017
   
*/
public with sharing class VehicleRelationshipHelperMY{  
    public static final String Market = System.Label.MarketMY;
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        VehicleRelationshipHelperBase.OnAfterInsert(vehicleRelNewRecords);
    } 

    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){
        VehicleRelationshipHelperBase.OnAfterUpdate(newVehicleRelRecords,oldMapVR);
    } 

    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){          
        VehicleRelationshipHelperBase.OnAfterDelete(oldVehicleRelRecords);
    } 

    Public static void updateAccountstatus(Set<Id> ContactIds){ 
        VehicleRelationshipHelperBase.updateAccountstatus(ContactIds);
    }

    Public static void updateVehicleAmount(Set<Id> ContactIds){
        VehicleRelationshipHelperBase.updateVehicleAmount(ContactIds);
    }  

    Public static void createAccountLink(Set<Id> VehicleIds,Set<Id> VehicleRelationshipIds,Set<Id> contactIdofVehicleRelationship){
        VehicleRelationshipHelperBase.createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);
    }
    /*Start - Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */
    public static void afterInsertUpdateSharerecordsWithDealers(List<Vehicle_Relationship__c> vehicleRellist,boolean isinsertcontext){
        VehicleRelationshipHelperBase.afterInsertUpdateSharerecordsWithDealers(vehicleRellist, isinsertcontext, Market);
    }
    /*End - Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */
}