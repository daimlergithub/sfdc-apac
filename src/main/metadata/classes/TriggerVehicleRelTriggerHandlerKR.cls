/**
* Handler for Trigger on Vehicle Relationship for Korea
* Author : Chethan A
* Created date: 2016-08-11
* Purpose:
*        1.Update Vehicle amount based on vehicle Relationship associated with an "Account".
*        
*/

public class TriggerVehicleRelTriggerHandlerKR implements TriggerHandlerIf{

    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
            Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
            Map<Id,Vehicle_Relationship__c> oldmapVehicleRelation = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
       
           // Update Status , Update Vehicle Relationship and Create Account Link 
            
           if(trigger.isAfter && (trigger.isInsert))
            {
                VehicleRelationshipHelperJP.OnAfterInsert(Trigger.new);                
            }
            if(trigger.isAfter && Trigger.isUpdate) 
            {
                Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
                VehicleRelationshipHelperJP.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
            } 
           if(trigger.isAfter && Trigger.isDelete) {
              VehicleRelationshipHelperJP.OnAfterDelete(Trigger.old);
            }
            if(trigger.isBefore && trigger.isInsert)
            {
                vrHelperJP.validateOverlappingVehicleRelationshiponInsert(Trigger.new);
            }
            if(trigger.isBefore && trigger.isUpdate)
            {
                vrHelperJP.validateOverlappingVehicleRelationshiponUpdate(trigger.new,oldmapVehicleRelation);
            }
            if(trigger.isAfter && trigger.isUpdate || trigger.isAfter && trigger.isInsert)
            {
                VehicleRelationshipHelper.updateRecall(trigger.new);
            }
            if(trigger.isAfter && trigger.isInsert)
            {
                system.debug('VR ');
                VehicleRelationshipHelperKR.afterInsertEvent(trigger.new);
            }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
        Map<Id,Vehicle_Relationship__c> newmap = (Map<Id,Vehicle_Relationship__c>)trigger.newmap;
        Map<Id,Vehicle_Relationship__c> oldmapVehicleRelation = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
  
       // Update Status , Update Vehicle Relationship and Create Account Link     
       List<Vehicle_Relationship__c> velRelNewList = Trigger.new;
        List<Vehicle_Relationship__c> velRelOldList = Trigger.old;
        if(!isDelete && !velRelNewList.isEmpty() && velRelNewList.size() > 0 && velRelNewList[0].MD__c == 'KR')
        {
		   if(trigger.isAfter && (trigger.isInsert))
			{
			  VehicleRelationshipHelperJP.OnAfterInsert(Trigger.new);
			}
			if(trigger.isAfter && Trigger.isUpdate) {
			  Map<Id,Vehicle_Relationship__c> oldmapVehicleRelship = (Map<Id,Vehicle_Relationship__c>)Trigger.oldmap;
			  VehicleRelationshipHelperJP.OnAfterUpdate(Trigger.new,oldmapVehicleRelship);
			} 
		   if(trigger.isAfter && Trigger.isDelete) 
		    {
			  VehicleRelationshipHelperJP.OnAfterDelete(Trigger.old);
			}
		}
    }
    
       
}