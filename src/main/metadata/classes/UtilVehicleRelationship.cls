/*
    Type:       Utility for TriggerVehicleRelationship
    Purpose:    If Vehicle_Relationship__c record has change, just assign the changed value to 
                corresponding Vehicle
    User Story: US-CP-008, US-CP-007
    Used By:    TriggerVehicleRelationship
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-05
    2. Chris Modified on 2013-12-04 Add in row 23:  '&& relationship.Vehicle_ID__c != null'
*/
public class UtilVehicleRelationship
{
    // US-CP-007
    public static void checkVehcileValidity(List<Vehicle_Relationship__c> relationships)
    {
        relationships = [SELECT Id, Validity__c, Vehicle_ID__c,Vehicle_ID__r.Valid__c 
                         FROM Vehicle_Relationship__c 
                         WHERE Id IN :relationships];

        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        if(relationships!=null && !relationships.isEmpty())
        {
	        for (Vehicle_Relationship__c relationship : relationships)
	        {
	            if (relationship.Validity__c == 'Yes' && relationship.Vehicle_ID__c != null && relationship.Vehicle_ID__r.Valid__c != 'Yes')
	            {
	                relationship.Vehicle_ID__r.Valid__c = 'Yes';
	                vehicleList.add(relationship.Vehicle_ID__r);
	            }
	        }
	
	        try
	        {
	        	if(vehicleList!=null && !vehicleList.isEmpty())
	            	update vehicleList;
	        }
	        catch (DMLException e) {
	            trigger.new[0].addError(e.getDMLMessage(0));
	        }
        }	        
    }

    // US-CP-008
    public static void updateVehicle(List<Vehicle_Relationship__c> vRelationshipNew,Map<Id, Vehicle_Relationship__c> vRelationshipOldMap,boolean isInsert,boolean isUpdate)
    {
    	
    	Set<Id> vehicleIds = new Set<Id>();
        for(Vehicle_Relationship__c relationship : vRelationshipNew)
        {
            if(vRelationshipOldMap.get(relationship.Id).Validity__c != relationship.Validity__c)
            {
                vehicleIds.add(relationship.Vehicle_Id__c);
            }
        }
        
        if(vehicleIds!=null && !vehicleIds.IsEmpty())
        {
        	List<Vehicle__c> vehicles = [SELECT Id, Valid__c,(SELECT Id, Validity__c FROM Vehicle_Relationships__r) FROM Vehicle__c WHERE Id IN :vehicleIds];
	        if(vehicles!=null && !vehicles.isEmpty())
	        {                             
		        // For loop vehicles
		        for (Vehicle__c vehicle : vehicles)
		        {
		            for (Vehicle_Relationship__c relationship : vehicle.Vehicle_Relationships__r)
		            {
		                // Add vehicle which needs updation to list
			            if (relationship.Validity__c!=null && relationship.Validity__c.contains('Yes'))
			            {
			                vehicle.Valid__c = 'Yes';
			            }
			            // If all vehicle relationships is not Yes and one is unknown,
			            // update vehicle to unknown
			            else if (relationship.Validity__c!=null &&  !relationship.Validity__c.contains('Yes') && relationship.Validity__c.contains('Unknown'))
			            {
			                vehicle.Valid__c = 'Unknown';
			            }
			            // If all vehicle relationship ares not Yes and unknown,
			            // update vehicle to unknown
			            else if (relationship.Validity__c!=null &&  !relationship.Validity__c.contains('Yes') && relationship.Validity__c.contains('No'))
			            {
			                vehicle.Valid__c = 'No';
			            }
		            }
		        }
		        
		        try {
		            update vehicles;
		        }
		        catch (DMLException e) {
		            trigger.new[0].addError(e.getDMLMessage(0));
		        }
	        }
        }
    }
}