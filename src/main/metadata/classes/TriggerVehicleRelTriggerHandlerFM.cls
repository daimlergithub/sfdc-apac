/*
    Type:       Trigger on Vehicle_Relationship__c 
    Purpose:    1. Update Vehicle amount based on vehicle Relationship associated with an "Account". 
*/

public class TriggerVehicleRelTriggerHandlerFM implements TriggerHandlerIf {
    
    public String Market=Utility_FM.getLoggedInUserInfo().Market__c;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
	     if(trigger.isBefore && Trigger.isUpdate){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
            if(trigger.isBefore && Trigger.isinsert){
               UtilVehicleRelationship.updatemarket(Trigger.New);
            }
       //Harshit added to check for User permission-Access Management- on 09-10-2017
        // updated new label as FMGeneric
        if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperFM.OnAfterInsert(Trigger.new);
                  // updated new label as FMRetail
				 if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){
                   VehicleRelationshipHelperFM.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);    /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */                
                }
			}
            if(trigger.isAfter && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperFM.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
                 // updated new label as FMRetail
				 if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){
                VehicleRelationshipHelperFM.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);   /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */
            } 
			}
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperFM.OnAfterDelete(Trigger.old);
				VehicleRelationshipHelperFM.OnAfterDelete_Company_Account(Trigger.old);
            } 
        }
         FMMarketTriggerFactory.run('Vehicle_Relationship__c',Market,isInsert,isUpdate,isBefore,isDelete,isAfter);
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
		Logic_Switch__c ls = Logic_Switch__c.getValues('VRRealTimeSharingInf');
        List<Vehicle_Relationship__c> vehicleNewList = Trigger.new;
         //Added for FM Markets
        String MarketCodes = Label.HandleIntegrationTriggerFMCountries;
        if(!isDelete && !vehicleNewList.isEmpty() && vehicleNewList.size() > 0 && MarketCodes.contains(vehicleNewList[0].Market__c)){
            if(trigger.isAfter && (trigger.isInsert)){
                VehicleRelationshipHelperFM.OnAfterInsert(Trigger.new);
				VehicleRelationshipHelperFM.OnAfterInsert_company_account(Trigger.new);
				if(ls != NULL && ls.execute__c){
					VehicleRelationshipHelperFM.afterInsertUpdateSharerecordsWithDealers(Trigger.New,true);       /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */   
				}				
            }
            if(trigger.isAfter && Trigger.isUpdate) {
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperFM.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
				VehicleRelationshipHelperFM.OnAfterUpdate_Company_Account(Trigger.new,oldmapVehicleRelship);
				if(ls != NULL && ls.execute__c){
                    VehicleRelationshipHelperFM.afterInsertUpdateSharerecordsWithDealers(Trigger.New,false);     /*Added by Laqshay Arora as a part of Vehicle/Vehicle relationship management Phase 2 */   
				}
            }    
            if(trigger.isAfter && Trigger.isDelete) {
                VehicleRelationshipHelperFM.OnAfterDelete(Trigger.old);
				VehicleRelationshipHelperFM.OnAfterDelete_Company_Account(Trigger.old);
            }
			 if(trigger.isBefore && Trigger.isUpdate){
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperFM.OnBeforeUpdate(Trigger.new,oldmapVehicleRelship);
      		}
        }
    }   
}