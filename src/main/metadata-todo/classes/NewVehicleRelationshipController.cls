/*
    Type:       Controller for  Visualforce page 
    Purpose:    
    User Story: CR_HLD_CAC_009
    Used By:    NewVehicleRelationship.page
    ---------------------------------------------------------------
    History:
    
    2014-03-10 Shuang Li (NTTData)  Created
*/
public class NewVehicleRelationshipController {

    public Vehicle__c vehicle { get; set; }

    public Vehicle_Relationship__c vehicleRelationship { get; set; }
    
    public NewVehicleRelationshipController() {
        vehicle= new vehicle__c();
        vehicle.RecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleRelationship = new Vehicle_Relationship__c();
        vehicleRelationship.Contact__c = ApexPages.currentPage().getParameters().get('accountId');
       
    }


    public PageReference save() {
        try {
            insert vehicle;
            vehicleRelationship.Vehicle_ID__c = vehicle.id;
            insert vehicleRelationship;
        }
        catch(Exception ex) {
            system.debug(ex.getMessage());
        }
        
        PageReference pr;
        if(ApexPages.currentPage().getParameters().get('retURL') != null) {
            pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        }
        else {
            pr = new PageReference('/' + vehicle.Id);
        }
        return pr;
    }

}