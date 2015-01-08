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
public class UtilLead {
    // US-Lead-009
    public static void updateLeadForDataSharing(List<Lead__c> leads) {
        Set<Id> accIds = new Set<Id>();
        for (Lead__c lead : leads) {
            accIds.add(lead.Contact__c);
        }

        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, Allow_Data_Sharing__c 
             FROM Account WHERE Id IN :accIds]
        );

        for (Lead__c lead : leads) {
            String allowDataSharing = accMap.get(lead.Contact__c).Allow_Data_Sharing__c;
            lead.Allow_Data_Sharing__c = allowDataSharing == 'Yes' ? true : false;
        }
    }

    // US-Lead-021
    public static void updateRelatedVehicleRelFields(List<Lead__c> leads) {
        Set<Id> leadIdSet = new Set<Id>();
        for (Lead__c lead : leads) {
            if (lead.VehicleRel_No__c != null) {
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

        for (Lead__c lead : leads) {
            if (lead.VehicleRel_No__c != null) {
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
}