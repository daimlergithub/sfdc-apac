public with sharing class VehicleRelationshipHelperJP 
{
    List<Vehicle_Relationship__c> vehicle_relationship = new List<Vehicle_Relationship__c>();
    Map<Id, Set<Vehicle_Relationship__c>> accountVR_Map = new Map<Id, Set<Vehicle_Relationship__c>>();
    Set<Vehicle_Relationship__c> tempVR = new Set<Vehicle_Relationship__c>();
    Set<Id> accountIds = new Set<Id>();
    
    public void validateOverlappingVehicleRelationship(List<Vehicle_Relationship__c> vehicleRel, String event){       
        for (Vehicle_Relationship__c vr : vehicleRel){
            system.debug('VR Contact :' +vr.Contact__c);
            tempVR = accountVR_Map.get(vr.Contact__c);
            if (tempVR == null){
                accountVR_Map.put(vr.Contact__c, new Set<Vehicle_Relationship__c>{vr});
            }else{
                tempVR.add(vr); 
            }
        }        
        system.debug('Account VR Map :' +accountVR_Map);        
        accountIds = accountVR_Map.keySet();
        system.debug('Account Ids...' +accountIds);
        for (Id acId : accountIds){
            tempVR = accountVR_Map.get(acId);
            system.debug('Vehicle Relationships...' +tempVR);
            for (Vehicle_Relationship__c vr : tempVR){               
                system.debug('Vehicle Relationship...' +vr);
                vehicle_relationship = [Select Id From Vehicle_Relationship__c Where Contact__c =: acId AND Start_Date__c =:vr.Start_Date__c AND End_Date__c =:vr.End_Date__c];
                system.debug('Vehicle Relationship from Query...'+vehicle_relationship);
                system.debug('Vehicle Relationship size...'+vehicle_relationship);
                system.debug('Vehicle Relationship from Query...'+vehicle_relationship);
                if (!vehicle_relationship.isEmpty() && event.equalsIgnoreCase('insert')){
                    vr.addError(label.Vehicle_Relationship_overlap);
                }else if(vehicle_relationship.size() >= 1 && event.equalsIgnoreCase('update')){
                    vr.addError(label.Vehicle_Relationship_overlap);
                }         
            }
        }
        
    }
}