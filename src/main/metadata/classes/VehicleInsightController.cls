public class VehicleInsightController {

    @AuraEnabled
    public static List < VehicleInsightWrapper > VRByCustId(String recordId) {
		List < VehicleInsightWrapper > lstVehicleWrapper = new List < VehicleInsightWrapper > ();
        List < Vehicle_Relationship__c > vehicleList = [Select id, name, Vehicle_Model__c, Vehicle_ID__c, Vehicle_ID__r.name from Vehicle_Relationship__c 
                                                        where contact__c =: recordId limit 5];
        for (Vehicle_Relationship__c tempVR: vehicleList)
            lstVehicleWrapper.add(new VehicleInsightWrapper(tempVR.Vehicle_Model__c, (String) tempVR.Vehicle_ID__c, tempVR.name, recordId, 
                                                            InsightsController.fetchPrepopulatedQuestions(tempVR.Id, 'Vehicle')));  
        return lstVehicleWrapper;
    }
    public class VehicleInsightWrapper {

        @AuraEnabled public string vehicleName;
        @AuraEnabled public string vehicleId;
        @AuraEnabled public string name;
        @AuraEnabled public string recordId;
        @AuraEnabled public List <PrepopulateInsighstWrapper> lstPIW;

        public VehicleInsightWrapper(String vehicleName, String vehicleId, String name, String recordId, List<PrepopulateInsighstWrapper> lstPIW) {
            this.vehicleName = vehicleName;
            this.vehicleId = vehicleId;
            this.name = name;
            this.recordId = recordId;
            this.lstPIW = lstPIW;
        }
    }
}