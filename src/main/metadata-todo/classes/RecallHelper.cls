/*
    Type:       Utility for Recall trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags “Recall” on related vehicle, vehicle relationship and customer record automatically.
                2.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes “Recall” flag on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sichao Lai Created on 2013-06-07
    2. Lio Huang Created on 2013-11-05
*/
public with sharing class RecallHelper {

    private static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
        }
    }
    
    /**
       Update Recall for Vehicle Relationship, Vehicle, Customer
     */
     
    public static void updateRecall(Set<Id> vehicleIds) {
    
        List<SObject> objectsToUpdate = new List<SObject>();
        Set<Id> customerIds = new Set<Id>();
              
        for(Vehicle_Relationship__c vr : [select Id, Contact__c, Recall__c from Vehicle_Relationship__c where Vehicle_ID__c in :vehicleIds])
        {
            vr.Recall__c = true;
            customerIds.add(vr.Contact__c);
            objectsToUpdate.add(vr);
        }
        
        for(Vehicle__c v : [select Id, Recall__c from Vehicle__c where Id in :vehicleIds]) {
            v.Recall__c = true;
            objectsToUpdate.add(v);
        }
        
        for(Account acc : [select Id, Recall__c from Account where Id in :customerIds ]) {
            acc.Recall__c = true;
            objectsToUpdate.add(acc);
        }
        
        if(objectsToUpdate.Size() > 0) {
            updateSobjects(objectsToUpdate);
        }
    }
    
    public static void removeRecall(Set<Id> vehicleIds) {
    
        List<SObject> objsToUpdate = new List<SObject>();
        Set<Id> accIds = new Set<Id>();
              
        for(Vehicle_Relationship__c vr : [select Id, Contact__c, Recall__c from Vehicle_Relationship__c where Vehicle_ID__c in :vehicleIds])
        {
            vr.Recall__c = false;
            accIds.add(vr.Contact__c);
            objsToUpdate.add(vr);
        }
        
        for(Vehicle__c v : [select Id, Recall__c from Vehicle__c where Id in :vehicleIds]) {
            v.Recall__c = false;
            objsToUpdate.add(v);
        }
        
        for(Account acc : [select Id, Recall__c from Account where Id in :accIds ]) {
            acc.Recall__c = false;
            objsToUpdate.add(acc);
        }
        
        if(objsToUpdate.Size() > 0) {
            updateSobjects(objsToUpdate);
        }
    }
}