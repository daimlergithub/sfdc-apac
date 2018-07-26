/*
Type:       Helper class on Vehicle_Relationship__c
Purpose:   
1. Insert Update Delete Vehicle related details
2. Update Account Status
3. Update Vehicle Amount
4. Create Account Link

CreatedBY : Prem on 23/04/2018

*/
public class VehicleRelationshipHelperIN {
    
    public static final String Market = System.Label.MarketIN;
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        VehicleRelationshipHelperBase.OnAfterInsert(vehicleRelNewRecords);
    } 
    
    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){
        VehicleRelationshipHelperBase.OnAfterUpdate(newVehicleRelRecords,oldMapVR);
    } 
    
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){          
        VehicleRelationshipHelperBase.OnAfterDelete(oldVehicleRelRecords);
    } 
    
    /*Start - Added as a part of Vehicle/Vehicle relationship management */
    public static void afterInsertUpdateSharerecordsWithDealers(List<Vehicle_Relationship__c> vehicleRellist,boolean isinsertcontext){
        VehicleRelationshipHelperBase.afterInsertUpdateSharerecordsWithDealers(vehicleRellist, isinsertcontext, Market);
    }
    
    /*End - Added as a part of Vehicle/Vehicle relationship management */
    public static void OnAfterDelete_Company_Account(List<Vehicle_Relationship__c> oldVehicleRelRecords){
        VehicleRelationshipHelperBase.OnAfterDelete_Company_Account(oldVehicleRelRecords);
    }
    public static void OnAfterInsert_company_account(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        VehicleRelationshipHelperBase.OnAfterInsert_company_account(vehicleRelNewRecords);
    }
    Public static void OnAfterUpdate_Company_Account(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){
        VehicleRelationshipHelperBase.OnAfterUpdate_Company_Account(newVehicleRelRecords,oldMapVR);        
    } 
    
}