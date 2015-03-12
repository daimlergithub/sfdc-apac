/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes �Recall� flag on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Lio Huang Created on 2013-11-05
*/
/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags �Recall� on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sichao Lai Created on 2013-06-07
*/
trigger TriggerRecall on Recall__c (after insert,before Delete) {
    
    if(trigger.isAfter && trigger.isInsert)
    { 
        if(UtilCustomSettings.isEnabled('RecallAfterInsertUpdate'))
            RecallHelper.AfterInsertEvent(Trigger.new);
                 
        Set<Id> VehicleIds = new Set<Id>();  
        List<Vehicle_Relationship__c> lstVehicleIds = new List<Vehicle_Relationship__c>(); 
        // get VIN and Vehicle ID from Recall
        for (Recall__c r : Trigger.new){
            VehicleIds .add(r.Vehicle_ID__c);
        }
    
        // update Recall checkbox status
        if (!VehicleIds.isEmpty()){           
           RecallHelper.updateRecall(VehicleIds);
         }  
    }
    if(trigger.isbefore && trigger.isDelete)
    {
        if(UtilCustomSettings.isEnabled('RecallBeforeDelete'))
            RecallHelper.beforeDeleteEvent(Trigger.old);
            
         Set<Id> VehicleIds = new Set<Id>();          
        // get VIN and Vehicle ID from Recall
        for (Recall__c r : Trigger.old){
            VehicleIds .add(r.Vehicle_ID__c);
        }
    
        // update Recall checkbox status
        if (!VehicleIds.isEmpty()){      
           RecallHelper.removeRecall(VehicleIds);
       }    
   }
}