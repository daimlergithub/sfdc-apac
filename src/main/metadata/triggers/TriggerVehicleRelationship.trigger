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
*/
trigger TriggerVehicleRelationship on Vehicle_Relationship__c(after insert, after update, before insert) {
    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerVehicleRelationship')) {
        return;
    }
	
	if(trigger.isAfter && trigger.isInsert)
    {
    	// US-CP-007
        UtilVehicleRelationship.checkVehcileValidity(trigger.new);
        
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromRetailRelationships(Trigger.new));
        
        VehicleRelationshipSharingWrapService retailWrapService = new VehicleRelationshipSharingWrapService();
        SharingService.shareVehicleRelationships(retailWrapService.wrapRetailVehicleRelationships(Trigger.new));
        
        AccountSharingDataHandler handler = new AccountSharingDataHandler('Retail Vehicle RelationShip');
    	handler.shareAccountByRetailVR(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    	
    	//ISSUE-0757
        VehicleRelationshipHelper.shareVR(Trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
    	AccountSharingDataHandler handler = new AccountSharingDataHandler('Retail Vehicle RelationShip');
    	handler.shareAccountByRetailVR(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    	//
    	UtilVehicleRelationship.updateVehicle(Trigger.new,trigger.oldmap,trigger.isinsert,trigger.isupdate);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
    	//
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
    	//
    }
}