/*
Type:       Helper class on Vehicle_Relationship__c
Purpose:   
1. Insert Update Delete Vehicle related details
2. Update Account Status
3. Update Vehicle Amount
4. Create Account Link

CreatedBY : Hildaa

*/
public with sharing class VehicleRelationshipHelperTR{  
    public static final String Market = 'TR';
    Public static void OnAfterInsert(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        VehicleRelationshipHelperBase.OnAfterInsert(vehicleRelNewRecords);
    } 
    
    Public static void OnAfterUpdate(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){
        VehicleRelationshipHelperBase.OnAfterUpdate(newVehicleRelRecords,oldMapVR);
    } 
    
    Public static void OnAfterDelete(List<Vehicle_Relationship__c> oldVehicleRelRecords){          
        VehicleRelationshipHelperBase.OnAfterDelete(oldVehicleRelRecords);
    } 
	
	public static void afterInsertUpdateSharerecordsWithDealers(List<Vehicle_Relationship__c> vehicleRellist,boolean isinsertcontext){
        VehicleRelationshipHelperBase.afterInsertUpdateSharerecordsWithDealers(vehicleRellist, isinsertcontext, Market);
    }
    
    Public static void updateAccountstatus(List<Vehicle_Relationship__c> newVehicleRelRecords){ 
        Set<Id> accIds= new Set<Id>();
        for(Vehicle_Relationship__c vr: newVehicleRelRecords)
        {
            if(vr.Contact__c != null )
            {
                accIds.add(vr.contact__c);
            }
        }
        if(accIds.size() > 0)
            VehicleRelationshipHelperBase.updateAccountstatus(accIds);
    }
    
    Public static void updateVehicleAmount(Set<Id> ContactIds){
        VehicleRelationshipHelperBase.updateVehicleAmount(ContactIds);
    }  
    
    Public static void createAccountLink(Set<Id> VehicleIds,Set<Id> VehicleRelationshipIds,Set<Id> contactIdofVehicleRelationship){
        VehicleRelationshipHelperBase.createAccountLink(VehicleIds,VehicleRelationshipIds,contactIdofVehicleRelationship);
    }    
}