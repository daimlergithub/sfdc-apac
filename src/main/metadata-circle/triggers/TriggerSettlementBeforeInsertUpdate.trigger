/*
    Type:       Trigger
    Purpose:    1. if Settlement Type = "No Settlement". Disable these fields in that case and default to 0 when saving.
    User Story: Defect#1487
    Used By:    Fanny
    ---------------------------------------------------------------
    History:
    
    15-Oct-2013 Fanny Tang (NTTData) Created
    28-Apr-2014 Cyril Huang (NTTData) Updated
*/
trigger TriggerSettlementBeforeInsertUpdate on Settlement_Management__c  (before insert, before update){
    if (!UtilCustomSettings.isEnabled('TriggerSettlementBeforeInsertUpdate')) {
        return;
    }

  Set<Id> caseIds = new Set<Id>();

   if(Trigger.isInsert || Trigger.isUpdate) {
        for(Settlement_Management__c sm : Trigger.new) {
            if(sm.Settlement_Type__c == 'No Settlement Require') {
                sm.Customer_Settlement_Amount__c = 0;
                sm.Dealer_Settlement_Amount__c = 0;
                sm.MB_Settlement_Amount__c = 0;
                caseIds.add(sm.Case__c);
            }
            // [Start]Add by Cyril: Release 1.1b
            if (sm.Settlement_Type__c != 'Others') {
                sm.Other_Settlement_Type__c = '';
            }
            // [End] Add by Cyril: Release 1.1b
        }
    }
    
      if(caseIds.size() > 0) {
        SettlementHelper.updateSettlementTotalAmount(caseIds);
    }

}