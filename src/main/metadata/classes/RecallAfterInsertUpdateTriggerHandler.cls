/*
    Type:       Trigger
    Purpose:    1.  If VIN of recall record matches UsVin of one vehicle record, 
                    system will link the recall record to this vehicle record automatically. 
                    System flags “Recall” on related vehicle, vehicle relationship and customer record automatically. 
                
    User Story: US-CP-022 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sichao Lai Created on 2013-06-07
    2. Gerhard Henning (NTTData)  Moved code to CampaignMemberAfterTriggerHandler on 2015-04-21
*/
public class RecallAfterInsertUpdateTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        /*
        Set<Id> VehicleIds = new Set<Id>();
    
        // get VIN and Vehicle ID from Recall
        for (Recall__c r : Trigger.new){
            VehicleIds .add(r.Vehicle_ID__c);
        }
    
        // update Recall checkbox status
        if (VehicleIds .size() > 0){
            RecallHelper.updateRecall(VehicleIds);
        } 
        */
    }
}