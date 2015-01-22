/*
    Type:       Trigger
    Purpose:    1. Calculate Total amount when settlement is changed
    User Story: US-DPCR-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    15-July-2013 Sinow Zhang (NTTData) Created
    6-May-2014   Cyril Huang (NTTData) Updated
*/
trigger TriggerSettlementAfterInsertUpdateDelete on Settlement_Management__c (after insert, after update, after delete) {
    if (!UtilCustomSettings.isEnabled('TriggerSettlementAfterInsertUpdateDelete')) {
        return;
    }
    
    Set<Id> caseIds = new Set<Id>();

    if(Trigger.isInsert || Trigger.isUpdate) {
        for(Settlement_Management__c sm : Trigger.new) {
            if(sm.Settlement_Type__c != 'Total Complaint Settlement') {
                caseIds.add(sm.Case__c);
            }
        }
    }
        
    if(Trigger.isDelete) {
        for(Settlement_Management__c sm : Trigger.old) {
            if(sm.Settlement_Type__c != 'Total Complaint Settlement') {
                caseIds.add(sm.Case__c);
            }
        }
    }
    
    if(caseIds.size() > 0) {
        SettlementHelper.updateSettlementTotalAmount(caseIds);
    }
    
    // [Start] 2014-05-06 Added by CyrilHuang (Release1.1b)
    Set<Id> updatedCaseIds = new Set<Id>();
    if (Trigger.isInsert) {
        for(Settlement_Management__c smNew : Trigger.new) {
            if (smNew.Settlement_Type__c != 'Total Complaint Settlement') {
                updatedCaseIds.add(smNew.Case__c);
            }
        }
    }
    if(Trigger.isDelete) {
        for(Settlement_Management__c smOld : Trigger.old) {
            if (smOld.Settlement_Type__c != 'Total Complaint Settlement') {
                updatedCaseIds.add(smOld.Case__c);
            }
        }
    }
    if(Trigger.isUpdate) {
        for(Settlement_Management__c smNew : Trigger.new) {
            Settlement_Management__c smOld = trigger.oldMap.get(smNew.id);
            if(smNew.Settlement_Type__c != smOld.Settlement_Type__c 
                || (smNew.Settlement_Type__c == smOld.Settlement_Type__c
                    && smNew.Settlement_Type__c != 'Total Complaint Settlement'
                    && (smNew.Customer_Settlement_Amount__c != smOld.Customer_Settlement_Amount__c
                        || smNew.Dealer_Settlement_Amount__c != smOld.Dealer_Settlement_Amount__c
                        || smNew.MB_Settlement_Amount__c != smOld.MB_Settlement_Amount__c))) {
                updatedCaseIds.add(smNew.Case__c);
            }
        }
    }
    if (updatedCaseIds.size() > 0) {
        List<Case> casesForUpdate = new List<Case>();
        for(Case cas : [select Id, Settlement_Changed__c from Case where Id in :updatedCaseIds]) {
            cas.Settlement_Changed__c = true;
            casesForUpdate.add(cas);
        }
        if (casesForUpdate.size() > 0) {
           try {
               update casesForUpdate;
           }
           catch (DMLException e) {
               System.debug('Exception occured when update the settlement changed flag on Case: ' + e.getDMLMessage(0));
           } 
        } 
    }
    // [End] 2014-05-06 Added by CyrilHuang (Release1.1b)
}