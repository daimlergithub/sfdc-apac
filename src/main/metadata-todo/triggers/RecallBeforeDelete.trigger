/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
                    system removes “Recall” flag on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Lio Huang Created on 2013-11-05
*/

trigger RecallBeforeDelete on Recall__c (before Delete) {
    if (!UtilCustomSettings.isEnabled('RecallBeforeDelete')) {
        return;
    }

    Set<Id> VehicleIds = new Set<Id>();

    // get VIN and Vehicle ID from Recall
    for (Recall__c r : Trigger.old){
        VehicleIds .add(r.Vehicle_ID__c);
    }

    // update Recall checkbox status
    if (VehicleIds .size() > 0){
       RecallHelper.removeRecall(VehicleIds);
    } 
}