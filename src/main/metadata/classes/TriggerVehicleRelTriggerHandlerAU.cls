/*
    Type:       Trigger on Vehicle_Relationship__c
    Purpose:   
                1. Update Vehicle amount based on vehicle Relationship associated with an "Account".
             

*/

public class TriggerVehicleRelTriggerHandlerAU implements TriggerHandlerIf{
    static User usr = [Select Id,ProfileId,Profile.Name , Market__c from User WHERE ID = : UserInfo.getUserId()];
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){ 
         if(trigger.isBefore && Trigger.isUpdate){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
            if(trigger.isBefore && Trigger.isinsert){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }

        if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric) || Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperAU.OnAfterInsert(Trigger.new);
                                    VehicleRelationshipHelperAU.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);    

			if(TriggerRecursiveCheck.runVandVR){
                  TriggerRecursiveCheck.runOnceForVandVR();
                  VehicleRelationshipHelperAU.sendVehicleRelationshipInfo(trigger.New,(Map<Id,Vehicle_Relationship__c>)Trigger.oldmap , usr.Market__c, trigger.isInsert, trigger.isUpdate);
				}
			  
             }
			 
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperAU.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                VehicleRelationshipHelperAU.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);  
				 
				
			if(TriggerRecursiveCheck.runVandVR){
                  TriggerRecursiveCheck.runOnceForVandVR();
                  VehicleRelationshipHelperAU.sendVehicleRelationshipInfo(trigger.New,(Map<Id,Vehicle_Relationship__c>)Trigger.oldmap , usr.Market__c, trigger.isInsert, trigger.isUpdate);
              }	
			
            }
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperAU.OnAfterDelete(Trigger.old);
                VehicleRelationshipHelperAU.OnAfterDelete_Company_Account(Trigger.old);
            } 
        }
		
    }
	
	
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        Logic_Switch__c ls = Logic_Switch__c.getValues('VRRealTimeSharingInf');
        List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && (vehicleNewList[0].MD__c == Label.AU || vehicleNewList[0].MD__c == Label.NZ)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperAU.OnAfterInsert(Trigger.new);
                VehicleRelationshipHelperAU.OnAfterInsert_company_account(Trigger.new);
                if(ls != NULL && ls.execute__c){
                    VehicleRelationshipHelperAU.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);   
                }               
            }
			
            if(trigger.isAfter && Trigger.isUpdate) {
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperAU.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                VehicleRelationshipHelperAU.OnAfterUpdate_Company_Account(Trigger.new,oldmapVehicleRelship);
                if(ls != NULL && ls.execute__c){
                    VehicleRelationshipHelperAU.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);    
                }
            }    
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperAU.OnAfterDelete(Trigger.old);
                VehicleRelationshipHelperAU.OnAfterDelete_Company_Account(Trigger.old);
            }

        }
    }
}