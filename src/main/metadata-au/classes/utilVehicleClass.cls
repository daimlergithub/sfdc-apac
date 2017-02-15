public class utilVehicleClass 
{
	public static map<string,Decimal> vehicleClassMap = new map<string,Decimal>();
    Public static List<Vehicle_Class_Priority_Score__mdt> vehicleclasslist = new List<Vehicle_Class_Priority_Score__mdt>();
	
    public static map<string,Decimal> getVehicleclass()
    {
        vehicleclasslist = [select Customer_Type__c,Vehicle_Class__c,Vehicle_Class_Score__c from Vehicle_Class_Priority_Score__mdt];
        
    	if(!vehicleclasslist.isEmpty() && vehicleclasslist != null)
        {              
            for(Vehicle_Class_Priority_Score__mdt vech : vehicleclasslist)
            {
                vehicleClassMap.put(vech.Vehicle_Class__c, vech.Vehicle_Class_Score__c);
            }            
        }
        return vehicleClassMap;
    }	        
}