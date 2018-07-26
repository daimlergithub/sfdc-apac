/*
Type:       Trigger on Vehicle_Relationship__c
Purpose:   
1. Update Vehicle amount based on vehicle Relationship associated with an "Account".

Created By:  Prem Kumar on 23/04/2018
*/
public class TriggerVehicleRelTriggerHandlerIN implements TriggerHandlerIf{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){ 
        if(trigger.isBefore && Trigger.isUpdate){
            UtilVehicleRelationship.updatemarket(Trigger.New);
        }
        if(trigger.isBefore && Trigger.isinsert){
            UtilVehicleRelationship.updatemarket(Trigger.New);
        }
        //Added to check for User permission-Access Management
        if(Util_GetPermissionList.checkAccessOnUser(Label.INGeneric)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperIN.OnAfterInsert(Trigger.new);
                if(Util_GetPermissionList.checkAccessOnUser(Label.INRetail)){
                    VehicleRelationshipHelperIN.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);    //Added as a part of Vehicle/Vehicle relationship management              
                }
            }
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperIN.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                if(Util_GetPermissionList.checkAccessOnUser(Label.INRetail)){
                    VehicleRelationshipHelperIN.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);   //Added by as a part of Vehicle/Vehicle relationship management
                } 
            }
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperIN.OnAfterDelete(Trigger.old);
                VehicleRelationshipHelperIN.OnAfterDelete_Company_Account(Trigger.old);
            } 
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && vehicleNewList[0].MD__c == Label.IN){
            if(trigger.isAfter && (trigger.isInsert) && INTriggerRecursionCheck.inVRAftIns == false){
                INTriggerRecursionCheck.inVRAftIns = true;
                VehicleRelationshipHelperIN.OnAfterInsert(Trigger.new);
                VehicleRelationshipHelperIN.OnAfterInsert_company_account(Trigger.new);
                VehicleRelationshipHelperIN.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);       /*Added as a part of Vehicle/Vehicle relationship management*/             
            }
            if(trigger.isAfter && Trigger.isUpdate && INTriggerRecursionCheck.inVRAftUpd == false) {
                INTriggerRecursionCheck.inVRAftUpd = true;
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperIN.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                VehicleRelationshipHelperIN.OnAfterUpdate_Company_Account(Trigger.new,oldmapVehicleRelship);
                VehicleRelationshipHelperIN.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);     /*Added as a part of Vehicle/Vehicle relationship management */               
            }
        }
        if(trigger.isAfter && Trigger.isDelete && INTriggerRecursionCheck.inVRAftUpd == false) {
            List<Vehicle_Relationship__c> vehicleOldList = Trigger.old;
            if (!vehicleOldList.isEmpty() && vehicleOldList.size() > 0 && vehicleOldList[0].md__c == Label.IN) {
                INTriggerRecursionCheck.inVRAftDel = true;
                VehicleRelationshipHelperIN.OnAfterDelete(Trigger.old);
                VehicleRelationshipHelperIN.OnAfterDelete_Company_Account(Trigger.old);
            }
        }
    }
}