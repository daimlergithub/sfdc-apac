/*
    Type:       Trigger
    Purpose:    1. Update the Description flag on Case when the Description is changed.
    Used By:    
    ---------------------------------------------------------------
    History:
    
    6-May-2014   Cyril Huang (NTTData) Created
*/
trigger TriggerComplaintDescAfterInsertUpdateDelete on Complaint_Description__c (after insert, after update, after delete) {
    if (!UtilCustomSettings.isEnabled('TriggerComplaintDescAfterInsertUpdateDelete')) {
        return;
    }
    
    Set<Id> updatedCaseIds = new Set<Id>();
    if (Trigger.isInsert) {
        for(Complaint_Description__c descNew : Trigger.new) {
            updatedCaseIds.add(descNew.Case__c);
        }
    }
    if(Trigger.isDelete) {
        for(Complaint_Description__c descOld : Trigger.old) {
            updatedCaseIds.add(descOld.Case__c);
        }
    }
    if(Trigger.isUpdate) {
        for(Complaint_Description__c descNew : Trigger.new) {
            Complaint_Description__c descOld = trigger.oldMap.get(descNew.id);
            if(descNew.Description__c != descOld.Description__c) {
                updatedCaseIds.add(descNew.Case__c);
            }
        }
    }
    if (updatedCaseIds.size() > 0) {
        List<Case> casesForUpdate = new List<Case>();
        for(Case cas : [select Id, Description_Changed__c from Case where Id in :updatedCaseIds]) {
            cas.Description_Changed__c = true;
            casesForUpdate.add(cas);
        }
        if (casesForUpdate.size() > 0) {
           try {
               update casesForUpdate;
           }
           catch (DMLException e) {
               System.debug('Exception occured when update the description changed flag on Case: ' + e.getDMLMessage(0));
           } 
        } 
    }
}