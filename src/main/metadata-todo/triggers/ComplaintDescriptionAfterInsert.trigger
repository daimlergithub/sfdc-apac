/*
    Type:       Trigger
    Purpose:    1. As the case team member, when a  team member  create  a complaint description/ resolution
	               on MB Complaint , and the “Urgent” field of the case is ticked, an notify email will be
	               sent to other case team members.
    User Story:
    Used By:
    ---------------------------------------------------------------
    History:

    5-Dec-2013 Bing (NTTData)  Created
*/
trigger ComplaintDescriptionAfterInsert on Complaint_Description__c (after insert) {

    if (!UtilCustomSettings.isEnabled('ComplaintDescriptionAfterInsert')) {
        return;
    }

	List<id> caseIds = new List<id>();

	for(Complaint_Description__c cdc : trigger.new){
		if(trigger.isInsert){
			caseIds.add(cdc.Case__c);
		}
	}

	if(caseIds.size()>0){
		ComplaintDesHelper.sendMailToCaseMember(caseIds);
	}
}