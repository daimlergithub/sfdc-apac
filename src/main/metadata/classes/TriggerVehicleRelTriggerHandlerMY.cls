/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
             
    Used By:  Mohammed Touseef Ahmed  
    ---------------------------------------------------------------
    Modified BY : Honey on 17th Oct   
*/

public class TriggerVehicleRelTriggerHandlerMY implements TriggerHandlerIf{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){ 
	     if(trigger.isBefore && Trigger.isUpdate){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
            if(trigger.isBefore && Trigger.isinsert){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
       //Harshit added to check for User permission-Access Management- on 09-10-2017
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperMY.OnAfterInsert(Trigger.new);
				 if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
                VehicleRelationshipHelperMY.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);    /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */                
            }
			}
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperMY.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
				 if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
                VehicleRelationshipHelperMY.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);   /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */
            } 
			}
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperMY.OnAfterDelete(Trigger.old);
            } 
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && vehicleNewList[0].MD__c == Label.MY){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperMY.OnAfterInsert(Trigger.new);
                VehicleRelationshipHelperMY.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);       /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */             
            }
            if(trigger.isAfter && Trigger.isUpdate) {
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperMY.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                VehicleRelationshipHelperMY.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);     /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */               
            }    
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperMY.OnAfterDelete(Trigger.old);
            }
        }
    }
}