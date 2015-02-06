/*
    Type:       Trigger
    Purpose:    1. US-Lead-016: Assign Dealer Lead Status to CAC Lead Status 
                   when assigned dealer has been verified
                2. US-Lead-014: Share related Campaign Lead to Lead Owner after dealer is assigned
    User Story: US-Lead-016, US-Lead-014
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-26
    2. Mouse add logic on sharing related campaign lead to lead owner on 2013-04-27
    3. Mouse add logic for US-Lead-021 on 2013-05-17
*/
trigger TriggerLead on Lead__c(before insert, before update, after update) {
    if (!UtilCustomSettings.isEnabled('TriggerLead')) {
        return;
    }

    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerLead')) {
        return;
    }

    Id aftersalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 
        'Aftersales Leads');

    Id salesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 
        'Sales Leads');

    if (trigger.isBefore && trigger.isInsert) {
        List<Lead__c> leads = new List<Lead__c>();
        for (Lead__c lead : trigger.new) {
            // US-Lead-021
            if (lead.VehicleRel_No__c != null &&
                    lead.RecordTypeId == aftersalesRecordTypeId) {
                leads.add(lead);
            }
        }

        // US-Lead-021
        if (leads.size() > 0) {
            UtilLead.updateRelatedVehicleRelFields(leads);
        }

        // US-Lead-009
        UtilLead.updateLeadForDataSharing(trigger.new);
    }

    if (trigger.isBefore && trigger.isUpdate) {
        List<Lead__c> vehicleRelationshipLead = new List<Lead__c>();
        for (Lead__c newLead: trigger.new) {
            // Get oldLead
            Lead__c oldLead = trigger.oldMap.get(newLead.Id);

            // US-Lead-016: If Assigned Date Time is not null and Dealer Audit is true, 
            // just assign Dealer Lead Status to CAC Lead Status
            if (newLead.Assigned_Date_Time__c != null 
                    && !newLead.Dealer_Audit__c
                    && newLead.RecordTypeId == salesRecordTypeId) {
                newLead.CAC_Lead_Status__c = newLead.Dealer_Lead_Status__c;
            }

            // US-Lead-13: When lead CAC Lead Staus has change, 
            // if this status is changed from New or Qualified to Lost(CAC), 
            // update Lead Is Qualify to Unqualified, 
            // otherwise, update it to Qualified
            if (newLead.CAC_Lead_Status__c != oldLead.CAC_Lead_Status__c) {
                if (newLead.CAC_Lead_Status__c == 'Lost(CAC)'
                        && (oldLead.CAC_Lead_Status__c == 'New' 
                            || oldLead.CAC_Lead_Status__c == 'Qualified')) {
                    newLead.Is_Qualify__c = 'Unqualified';
                }
                else {
                    newLead.Is_Qualify__c = 'Qualified';
                }
            }

            // US-Lead-021: 
            if (newLead.VehicleRel_No__c != oldLead.VehicleRel_No__c && 
                    newLead.RecordTypeId == aftersalesRecordTypeId) {
                vehicleRelationshipLead.add(newLead);
            }
        }

        // US-Lead-021: 
        if (vehicleRelationshipLead.size() > 0) {
            UtilLead.updateRelatedVehicleRelFields(vehicleRelationshipLead);
        }
    }
}