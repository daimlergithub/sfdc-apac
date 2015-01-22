/*
    Type:       Trigger
    Purpose:    1. When a complaint description created, update date time with current time, update created by with current user.
    User Story: US-DPCR-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    24-July-2013 Sinow Zhang (NTTData)  Created
*/
trigger TriggerComplaintDescriptionBeforeInsert on Complaint_Description__c (before insert) {
    if (!UtilCustomSettings.isEnabled('TriggerComplaintDescriptionBeforeInsert')) {
        return;
    }

    for(Complaint_Description__c cd : Trigger.new) {
        cd.Created_By__c = UserInfo.getUserId();
        cd.Date_Time__c = System.now();
    }
}