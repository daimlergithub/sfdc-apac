/*
Created By: Dheeraj
Created Date: 11/10/2018
Description: This is a generic handler class for JP market.
*/
public class TriggerVehicleTriggerHandlerJP implements TriggerHandlerIf {
    Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();  

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        System.debug('Inside the vehicle trigger handler-------------------------->');
        Boolean enableCDMCall = false;
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Enable CDM Call for Vehicle')){
            enableCDMCall = jpSwitchMap.get('Enable CDM Call for Vehicle').Enable_Flag__c;
        }
 
        if(isInsert && isAfter){
            if(enableCDMCall){
                vehicleHelperJP.sendVehicleInfo(trigger.New, Label.JP, isInsert, isUpdate);
            }
        }
        
        if(isUpdate && isAfter){
            if(enableCDMCall){
                vehicleHelperJP.sendVehicleInfo(trigger.New, Label.JP, isInsert, isUpdate);
            }
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
       
    }
}