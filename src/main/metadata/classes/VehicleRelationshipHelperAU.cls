/*
    Type:       Helper class on Vehicle_Relationship__c
    Purpose:   
    1. Insert Update Delete Vehicle related details
    2. Update Account Status
    3. Update Vehicle Amount
    4. Create Account Link
                
       
*/
public with sharing class VehicleRelationshipHelperAU{  
    
	Static User usr = [Select Id,ProfileId,Profile.Name , Market__c from User WHERE ID = : UserInfo.getUserId()];
	public static final String Market = usr.Market__c; 
	public static Id vehicleRelationship_VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    
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
          VehicleRelationshipHelperBase.afterInsertUpdateSharerecordsWithDealersANZ(vehicleRellist, isinsertcontext, Market);
    }
    
    
    public static void OnAfterDelete_Company_Account(List<Vehicle_Relationship__c> oldVehicleRelRecords){
        VehicleRelationshipHelperBase.OnAfterDelete_Company_Account(oldVehicleRelRecords);
    }
    public static void OnAfterInsert_company_account(List<Vehicle_Relationship__c> vehicleRelNewRecords){
        VehicleRelationshipHelperBase.OnAfterInsert_company_account(vehicleRelNewRecords);
    }
     Public static void OnAfterUpdate_Company_Account(List<Vehicle_Relationship__c> newVehicleRelRecords,Map<Id,Vehicle_Relationship__c> oldMapVR){
        VehicleRelationshipHelperBase.OnAfterUpdate_Company_Account(newVehicleRelRecords,oldMapVR);
        
    } 
	
   /*
        Description: This method is used to call the informatica service whenever the vehicle relationship record is created or updated.
    */
    
    public static void sendVehicleRelationshipInfo(List<Vehicle_Relationship__c> vehicleRelationList, Map<Id, Vehicle_Relationship__c> oldMap, String market, Boolean isInsert, Boolean isUpdate){
        Set<Id> vehicleRelationshipIdSet = new Set<Id>(); //holds the vehicle record ids.
        for(Vehicle_Relationship__c vehRel : vehicleRelationList){
            if(vehRel.recordTypeId == vehicleRelationship_VRRecordTypeId){
                if(isUpdate){
                    if(oldMap.get(vehRel.Id).End_Date__c == null){
                        vehicleRelationshipIdSet.add(vehRel.Id); //adding the record ids to call the service.
                    }
                }else if(isInsert){
                    vehicleRelationshipIdSet.add(vehRel.Id); //adding the record ids to call the service.
                }
            }//end of record type check
        }//end of trigger list iteration
        System.debug('VR id set size is ----------------------------------->'+vehicleRelationshipIdSet.size());
        if(vehicleRelationshipIdSet.size()>0){
            if(isInsert){
                CDMInformatica_Services.sendVehicleRelationshipInfo(vehicleRelationshipIdSet, market, 'Insert');
            }else if(isUpdate){
                CDMInformatica_Services.sendVehicleRelationshipInfo(vehicleRelationshipIdSet, market, 'Update');
            }
        }//end of size check before call.
    }//end of send vehicle relationship info method.
	
    
        
}