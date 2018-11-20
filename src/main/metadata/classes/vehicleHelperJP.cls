/*
Created By: Dheeraj
Created Date: 11/10/2018
Description: This is a generic helper class for JP market.
*/
public class vehicleHelperJP{
    public static String mbRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordtypeID();
    public static String selfRegisteredRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Self Registered').getRecordtypeID();
    
    /*
        Created By: Dheeraj
        Created Date: 11/10/2018
        Description: This method is used to call the informatica service whenever the record is created or updated.
    */
    public static void sendVehicleInfo(List<Vehicle__c> vehicleList, String market, Boolean isInsert, Boolean isUpdate){
        System.debug('Vehicle list size is -------------------------------->'+vehicleList.size());
        Set<Id> vehicleIdSet = new Set<Id>(); //holds the vehicle record ids.
        for(Vehicle__c veh : vehicleList){
            if(veh.recordTypeId == mbRecordTypeId || veh.recordTypeId == selfRegisteredRecordTypeId){
                system.debug('veh id------'+veh.Id);
                vehicleIdSet.add(veh.Id); //adding the record ids to call the service.
                system.debug('veh id set------'+vehicleIdSet);
            }//end of record type check
        }//end of trigger list iteration
        System.debug('Vehicle Id set size is ----------------------------->'+vehicleIdSet);
        
        if(vehicleIdSet.size()>0){
            if(isInsert){
                CDMInformatica_Services.sendVehicleInfo(vehicleIdSet, market, 'Insert');
            }else if(isUpdate){
                CDMInformatica_Services.sendVehicleInfo(vehicleIdSet, market, 'Update');
            }
        }//end of size check before call.
    }//end of send vehicle info method.
}//end of vehicle helper jp class