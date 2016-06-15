/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:    1. If Vehicle_Relationship__c Validity has change, just assign the changed value to 
                corresponding Vehicle
                2.  share the VR record to "Portal Role and Subordinates" with read only. 
                    Partner Name should be Account Name + " " + "Partner Executive", e.g. ??????4S? Partner Executive
    User Story: US-CP-008, US-CP-007,  ISSUE-0757
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-05
    2. Sinow Modified on 2013-06-20
    3. CC Modified on 2014-06-12
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerVehicleRelationshipTriggerHandler
*/
public class TriggerVehicleRelationshipTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        Map<Id,Vehicle_Relationship__c> oldmap = (Map<Id,Vehicle_Relationship__c>)trigger.oldmap;
        Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
            // US-CP-007
            /*UtilVehicleRelationship.checkVehcileValidity(trigger.new);
            
            VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
            SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromRetailRelationships(Trigger.new));
            
            VehicleRelationshipSharingWrapService retailWrapService = new VehicleRelationshipSharingWrapService();
            SharingService.shareVehicleRelationships(retailWrapService.wrapRetailVehicleRelationships(Trigger.new));
            
            AccountSharingDataHandler handler = new AccountSharingDataHandler('Retail Vehicle RelationShip');
            handler.shareAccountByRetailVR(newMap, oldMap, Trigger.isInsert); */
            
            //ISSUE-0757
         
            //Existing au functionality
            VehicleRelationshipHelper.auAfter_Insert_Update_Events(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);
        }
       // if(trigger.isbefore  && trigger.isInsert)
       // {
      //      VehicleRelationshipHelper.auBefore_Insert_Update_Events(Trigger.new);
       // }
       
        if(trigger.isafter  && trigger.isUpdate)
        {
            /*AccountSharingDataHandler handler = new AccountSharingDataHandler('Retail Vehicle RelationShip');
            handler.shareAccountByRetailVR(newMap, oldMap, Trigger.isInsert);
            UtilVehicleRelationship.updateVehicle(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate);*/
            //Existing au functionality
            VehicleRelationshipHelper.auAfter_Insert_Update_Events(Trigger.new,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);
        }
        if(trigger.isAfter && trigger.isdelete)
        {
            VehicleRelationshipHelper.auAfter_Insert_Update_Events(Trigger.old,oldmap,trigger.isinsert,trigger.isupdate,trigger.isdelete);
        }
    }
}