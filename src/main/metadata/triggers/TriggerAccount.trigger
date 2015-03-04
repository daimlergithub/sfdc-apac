/*
    Type:       Utility for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City and Province 
    User Story: US-DS-001, US-Lead-009
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28 for US-DS-OO1
    2. Mouse Updated on 2013-07-04 for US-Lead-009
    3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
*/
trigger TriggerAccount on Account (before update, after update) {
    if (!UtilCustomSettings.isEnabled('TriggerAccount')) {
        return;
    }

    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerAccount')) {
        return;
    }

    // Get the Record Type Id of 'Dealer'
    Id dealerRecordTypeId = 
        UtilRecordType.getRecordTypeIdByName('Account', 'Dealer');

    // Get the RecordType Id of 'Person Account'
    Id personaRecordTypeId = 
        UtilRecordType.getRecordTypeIdByName('Account', 'Person Account');

    if (trigger.isUpdate && trigger.isBefore) {
        // US-DS-001, link dealer to Dealer City by City and Province
        UtilAccount.linkDealerCity(trigger.new, dealerRecordTypeId);
    }

    if (trigger.isAfter && trigger.isUpdate) {
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> accIdSetForUpdateLead = new Set<Id>();
        for (Account newAcc : trigger.new) {
            Account oldAcc = trigger.oldMap.get(newAcc.Id);
            // US-Lead-009
            if (newAcc.Allow_Data_Sharing__c != oldAcc.Allow_Data_Sharing__c) {
                accIdSet.add(newAcc.Id);
            }
            
            // US-DP-022, US-DP-023
            if((newAcc.Allow_Data_Sharing__c == 'Yes' && newAcc.Allow_Data_Sharing__c != oldAcc.Allow_Data_Sharing__c) ||  
               (newAcc.Gender__c != null && newAcc.Gender__c != '' && newAcc.Gender__c != oldAcc.Gender__c) ||
               (newAcc.Province__c != null && newAcc.Province__c != '' && newAcc.Province__c != oldAcc.Province__c) ||
               (newAcc.City__c != null && newAcc.City__c != '' && newAcc.City__c != oldAcc.City__c) ||
               (newAcc.Preferred_Language__c != null && newAcc.Preferred_Language__c != '' && newAcc.Preferred_Language__c != oldAcc.Preferred_Language__c) ) {
                accIdSetForUpdateLead.add(newAcc.Id);
            }
        }

        // US-Lead-009
        if (accIdSet.size() > 0) {
            UtilAccount.updateLeadForDataSharing(accIdSet);
        }
        
        // US-DP-022, US-DP-023
        if (accIdSetForUpdateLead.size() > 0) {
            AccountHelper.updateLeads(accIdSetForUpdateLead);
        }
    }
}