/*
    Type:       Utility for TriggerAccount
    Purpose:    Link Dealer to Dealer City by City and Province 
    User Story: US-DS-001, US-Lead-009
    Used By:    TriggerAccount.trigger
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28
    2. Mouse Updated on 2013-07-04 for US-Lead-009
*/
public class UtilAccount {
    // US-DS-001
    public static void linkDealerCity(List<Account> triggerNew, Id dealerRecordTypeId) {
        if (trigger.isUpdate && trigger.isBefore && trigger.isExecuting) {
            // Get cities, provinces and the dealer which city or province has change
            Set<Id> dealerIdSet = new Set<Id>();
            Set<String> cities = new Set<String>();
            Set<String> provinces = new Set<String>();

            for (Account acc : triggerNew) {
                // Get the dealer which City or Province has change
                Account oldAcc = (Account) trigger.oldMap.get(acc.Id);
                if (acc.RecordTypeId == dealerRecordTypeId && 
                        (acc.City__c != oldAcc.City__c ||
                         acc.Province__c != oldAcc.Province__c)) {
                    dealerIdSet.add(acc.Id);

                    // Populate cities and provinces
                    if (acc.City__c != null) {
                        cities.add(acc.City__c);
                    }

                    if (acc.Province__c != null) {
                        provinces.add(acc.Province__c);
                    }
                }
            }
        }
    }

    // US-Lead-009
    // When Account Allow Data Sharing is False, 
    public static void updateLeadForDataSharing(Set<Id> accIds) {
        List<Lead__c> leadList = 
            [SELECT Allow_Data_Sharing__c, Contact__r.Allow_Data_Sharing__c 
             FROM Lead__c WHERE Contact__c IN :accIds];

        for (Lead__c lead : leadList) {
            if (lead.contact__r.Allow_Data_Sharing__c == 'Yes') {
                lead.Allow_Data_Sharing__c = true;
            }
            else {
                lead.Allow_Data_Sharing__c = false;
            }
        }

        try {
            update leadList;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('UtilAccount.updateLeadForDataSharing eXception: ' + e);
        }
    }
}