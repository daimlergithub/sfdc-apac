public with sharing class VehicleRelLookingController {

    public List<Vehicle_Relationship__c> VehilceRels { get; set; }
    public String elementNum  { get; set; }
    private final String contactId = ApexPages.currentPage().getParameters().get('id');
    private final String num = ApexPages.currentPage().getParameters().get('num');
    
    public VehicleRelLookingController() {
        if(contactId instanceof Id) {
            elementNum = num; 
            VehilceRels = [select Id, Name, Vehicle_ID__c, Vehicle_ID__r.Name, Car_Relation__c, Registration_Number__c, 
                           Vehicle_Brand__c, Vehicle_Class__c, Vehicle_Model__c from Vehicle_Relationship__c where Contact__c = :contactId];
        }
    }
}  