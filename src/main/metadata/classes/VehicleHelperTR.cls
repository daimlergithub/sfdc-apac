/**************************************************************************************************************************************************
* Class:                            vehicleHelperTR
* Description:                      This class will Close all the Tasks under Sales VR when Warranty Type - Advantage Plus
on after insert context.
@methods Description            
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2018-6-6    	Hildaa                     Created  

=====================================================================================================================================================*/
public class VehicleHelperTR{
    Public static void autoCloseTasksInSalesVR(List<Vehicle__c> newVehicleRecords,Map<Id,Vehicle__c> oldMapVR){
        set<Id> VHIds = new set<Id>();
		set<Id> VRIds = new set<Id>();
		list<Task> tasktoClose = new list<task>();
		for(Vehicle__c vh : newVehicleRecords)
		{
			if(vh.warranty_type__c == 'Advantage Plus' && vh.warranty_type__c != oldMapVR.get(vh.id).warranty_type__c)
				VHIds.add(vh.Id);
		}
		for(Vehicle_Relationship__c vr : [select id,end_date__c,vehicle_id__c,car_relation__c from Vehicle_Relationship__c where vehicle_id__c in :VHIds and end_date__c = null and car_relation__c = 'Sales' ]) {
			VRIds.add(vr.id);	
		}
		for(Task tk : [select id,whoid,whatid,status from task where whatid in :VRIds and status != 'Closed' ])
		{
			tk.status = 'Closed';
			tasktoClose.add(tk);
		}
		if(tasktoClose.size()>0){
              DMLManagerService.updateAsSystem(tasktoClose);
        }
		
    } 
}