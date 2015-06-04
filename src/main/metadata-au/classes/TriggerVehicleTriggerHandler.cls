public class TriggerVehicleTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        Map<Id,Vehicle__c> oldmap = (Map<Id,Vehicle__c>)trigger.oldmap;
        Map<Id,Vehicle__c> newmap = (Map<Id,Vehicle__c>)trigger.newmap;
        list<Vehicle__c> newVehicleList = (list<Vehicle__c>)trigger.new;
        
        Set<String> carClasses = new Set<String>();
    
        for(Vehicle__c newCar : newVehicleList){
            if(!carClasses.contains(newCar.Class__c)){
                carClasses.add(newCar.Class__c);
            }
        }
    
        Map<String,String> vehicleGroupMappings = new Map<String,String>();
        for(Car_Model__c vgm : [select Name, Vehicle_Group__c from Car_Model__c where Name in :carClasses]){
            String stringName = vgm.Name;
            stringName = stringName.toUpperCase();
            if(!vehicleGroupMappings.containsKey(stringName)){
                vehicleGroupMappings.put(stringName,vgm.Vehicle_Group__c);
            }
        }
        for(Vehicle__c newCar : newVehicleList){
            if(newCar.Class__c != null && newCar.Class__c != '')
            {
                String stringClass = newCar.Class__c;
                stringClass = stringClass.toUpperCase();
                newCar.Vehicle_Group__c = vehicleGroupMappings.get(stringClass);
            }
        }
    }
}