/**
** This is a controller class for the VehicleRelLookingPage.
** 1. Provides the data for the required data for the Lookup page.
**
** Created By: CC
** Date:  
**/

public with sharing class VehicleRelLookingController {

    public List<Vehicle_Relationship__c> VehilceRels { get; set; }
    public String elementNum  { get; set; }
    private final String contactId = ApexPages.currentPage().getParameters().get('id');
    private final String num = ApexPages.currentPage().getParameters().get('num');
    
    /**
	*@Description :This mehtod fetches the vehicle records based on the contact Id retrived from the page.
	*@Author :Shrinivas Desai.
	*@Date : 27/10/2015
	*@param: None
	*@return:This mehtod does not return any value.
	*@see:VehicleRelLookingController (Constructor method)
	*/
    public VehicleRelLookingController() {
        if(contactId instanceof Id) {
            elementNum = num; 
            VehilceRels = [select Id, Name, Vehicle_ID__c, Vehicle_ID__r.Name, Car_Relation__c, Registration_Number__c, 
                           Vehicle_Brand__c, Vehicle_Class__c, Vehicle_Model__c from Vehicle_Relationship__c where Contact__c = :contactId];
        }
    }
}