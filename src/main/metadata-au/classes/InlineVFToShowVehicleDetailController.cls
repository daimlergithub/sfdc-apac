public with sharing class InlineVFToShowVehicleDetailController 
{
    public Id leadId = ApexPages.currentPage().getParameters().get('id');
    list<Lead__c> leadList = new list<Lead__c>();
    public string GenericVehicleDetails {get;set;}
    public InlineVFToShowVehicleDetailController(ApexPages.StandardController controller) 
    {
        if(leadId != null)
        {
            leadList = [Select Id, Current_Vehicle__r.ModelYear__c, Current_Vehicle__r.Car_Model__c, Current_Vehicle__r.Car_Model__r.Name,
                        Current_Vehicle__r.Brand__c, Current_Vehicle__r.RecordTypeId, Current_Vehicle__c 
                        From Lead__c where Current_Vehicle__r.RecordType.DeveloperName = 'Competitor' and ID =: leadId and Current_Vehicle__c != null];
            if(!leadList.isEmpty() && leadList != null)
            {
                if(leadList[0].Current_Vehicle__c != null)
                {
                    if(leadList[0].Current_Vehicle__r.Brand__c != null && leadList[0].Current_Vehicle__r.Brand__c != '')
                    {
                        GenericVehicleDetails = leadList[0].Current_Vehicle__r.Brand__c;
                    }
                    if(leadList[0].Current_Vehicle__r.Car_Model__r.Name != null && leadList[0].Current_Vehicle__r.Car_Model__r.Name != '')
                    {
                        GenericVehicleDetails = GenericVehicleDetails  + ', ' + leadList[0].Current_Vehicle__r.Car_Model__r.Name;
                    }
                    if(leadList[0].Current_Vehicle__r.ModelYear__c != null && leadList[0].Current_Vehicle__r.ModelYear__c != '')
                    {
                        GenericVehicleDetails = GenericVehicleDetails  + ', ' + leadList[0].Current_Vehicle__r.ModelYear__c;
                    }
                }
            }
        }
    }
}