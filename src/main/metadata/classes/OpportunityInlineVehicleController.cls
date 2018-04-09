/* Class: Controller for OpportunityInlineVehicle
** Created By: Shashi Goswami
** Date: 06/04/2018
*/

public with sharing class OpportunityInlineVehicleController {

    //Added for Inline VF Page
    public Opportunity opp {get;set;}
    public List<Lead_Details__c> allIntVehicles{get;set;}
    public List<Lead_Details__c> allCompVehicles{get;set;}
    public List<Lead_Details__c> allTradeVehicles{get;set;}
    public List<Vehicle_Relationship__c> currentVehicleList {get;set;}
        
    public OpportunityInlineVehicleController(ApexPages.StandardController controller) {
        
        opp=[SELECT id,AccountID FROM opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
                
        currentVehicleList = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c from Vehicle_Relationship__c where Contact__c= :opp.AccountID];
        allIntVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Lead__c=:opp.Id and RecordType.DeveloperName='Interested_Vehicle'];
        allCompVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Lead__c=:opp.Id and RecordType.DeveloperName='Competitor'];
        allTradeVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Lead__c=:opp.Id and RecordType.DeveloperName='Trade_In'];
    }

}