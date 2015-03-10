/*
    Type:       Trigger
    Purpose:    Populate Vehicle Rel Related Fields
    User Story: US-Lead-021, // US-Lead-009
    Used By:    TriggerLead.trigger
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-27
    2. Mouse Updated on 2013-07-04 for US-Lead-009
*/
public class UtilLead
{
    public static final String aftersalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    public static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    // US-Lead-009
    public static void updateLeadForDataSharing(List<Lead__c> leads)
    {
        Set<Id> accIds = new Set<Id>();
        for (Lead__c lead : leads)
        {
            accIds.add(lead.Contact__c);
        }

        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Allow_Data_Sharing__c FROM Account WHERE Id IN :accIds]);

        for (Lead__c lead : leads)
        {
            String allowDataSharing = accMap.get(lead.Contact__c).Allow_Data_Sharing__c;
            lead.Allow_Data_Sharing__c = allowDataSharing == 'Yes' ? true : false;
        }
    }

    // US-Lead-021
    public static void updateRelatedVehicleRelFields(List<Lead__c> leads)
    {
        Set<Id> leadIdSet = new Set<Id>();
        for (Lead__c lead : leads)
        {
            if (lead.VehicleRel_No__c != null)
            {
                leadIdSet.add(lead.VehicleRel_No__c);
            }
        }

        Map<Id, Vehicle_Relationship__c> relationshipMap = 
            new Map<Id, Vehicle_Relationship__c>([SELECT Id, Registration_Number__c, 
                    Vehicle_ID__r.UsVIN__c, 
                    Vehicle_ID__r.EuroVIN__c,
                    Vehicle_ID__r.CurrentMileage__c,
                    Vehicle_ID__r.NextMileage__c,
                    Selling_Dealer__r.Name, 
                    Vehicle_Model__c,
                    Purchase_Date__c
             FROM Vehicle_Relationship__c
             WHERE Id IN :leadIdSet]);

        for (Lead__c lead : leads)
        {
            if (lead.VehicleRel_No__c != null)
            {
                Vehicle_Relationship__c relationship = relationshipMap.get(lead.VehicleRel_No__c);
                lead.Car_License__c = relationship.Registration_Number__c;
                lead.UsVIN__c = relationship.Vehicle_ID__r.UsVIN__c;
                lead.EuroVIN__c = relationship.Vehicle_ID__r.EuroVIN__c;
                lead.Selling_Dealer__c = relationship.Selling_Dealer__r.Name;
                lead.Car_Model__c = relationship.Vehicle_Model__c;
                lead.Vehicle_Purchase_Date__c = relationship.Purchase_Date__c;
                lead.CurrentMileage__c = relationship.Vehicle_ID__r.CurrentMileage__c;
                lead.NextMileage__c = relationship.Vehicle_ID__r.NextMileage__c;
            }
        }
    }
    
    public static void beforeInsert_updateEvents(List<Lead__c> leadsNew,map<Id,Lead__c> leadOldmap,boolean isInsert,boolean isUpdate)
    {
        
        if(isInsert)
        {
        	List<Lead__c> leads = new List<Lead__c>();
	        for (Lead__c lead : leadsNew)
	        {
	            // US-Lead-021
	            if (lead.VehicleRel_No__c != null && lead.RecordTypeId == aftersalesRecordTypeId)
	            {
	                leads.add(lead);
	            }
	        }
	        if(leads!=null && !leads.IsEmpty())
	        	updateRelatedVehicleRelFields(leads);
        }
        if(isUpdate)
        {
        	List<Lead__c> vehicleRelationshipLead = new List<Lead__c>();
	        for (Lead__c newLead: leadsNew) 
	        {
	            // Get oldLead
	            Lead__c oldLead = leadOldmap.get(newLead.Id);
	            // US-Lead-016: If Assigned Date Time is not null and Dealer Audit is true, 
	            // just assign Dealer Lead Status to CAC Lead Status
	            if(newLead.Assigned_Date_Time__c != null && !newLead.Dealer_Audit__c && newLead.RecordTypeId == salesRecordTypeId)
	            {
	                newLead.CAC_Lead_Status__c = newLead.Dealer_Lead_Status__c;
	            }
	            // US-Lead-13: When lead CAC Lead Staus has change, 
	            // if this status is changed from New or Qualified to Lost(CAC), 
	            // update Lead Is Qualify to Unqualified, 
	            // otherwise, update it to Qualified
	            if (newLead.CAC_Lead_Status__c != oldLead.CAC_Lead_Status__c)
	            {
	                if (newLead.CAC_Lead_Status__c == 'Lost(CAC)' && (oldLead.CAC_Lead_Status__c == 'New' || oldLead.CAC_Lead_Status__c == 'Qualified'))
	                {
	                    newLead.Is_Qualify__c = 'Unqualified';
	                }
	                else
	                {
	                    newLead.Is_Qualify__c = 'Qualified';
	                }
	            }
	            // US-Lead-021: 
	            if (newLead.VehicleRel_No__c != oldLead.VehicleRel_No__c && newLead.RecordTypeId == aftersalesRecordTypeId)
	            {
	                vehicleRelationshipLead.add(newLead);
	            }
	        }
	        // US-Lead-021: 
	        if (vehicleRelationshipLead!=null && !vehicleRelationshipLead.Isempty())
	        {
	            updateRelatedVehicleRelFields(vehicleRelationshipLead);
	        }
        }
    }
}