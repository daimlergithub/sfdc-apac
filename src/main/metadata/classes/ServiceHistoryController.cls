public class ServiceHistoryController {
   @AuraEnabled
     public static List<Vehicle_Relationship__c> getVehicleData(string customerId) {
         List<Vehicle_Relationship__c> vrList = [SELECT  Id, Vehicle_ID__c, Car_Model__c from Vehicle_Relationship__c where Contact__c=: customerId];
        return vrList;
    }    

    @AuraEnabled
    public static List<Retail_Task__c> getServices(string vehicleId) {
       Id recordTypeId = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
       List<Retail_Task__c> services =
                [SELECT Id, Service_Number__c, Service_Details__c,  Service_Date__c,Service_Mileage__c, Pay_Order_Type__c  FROM Retail_Task__c where Service_Vehicle__c=: vehicleId and RecordtypeId =: recordTypeId];
        return services;
    }
}