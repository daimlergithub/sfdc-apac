/*
    Type:       Trigger
    Purpose:    1. As the case team member, when a  team member  add  a Attachment
                   on MB Complaint , and the “Urgent” field of the case is ticked, an notify email will be
                   sent to other case team members.
    User Story:
    Used By:
    ---------------------------------------------------------------
    History:

    5-Dec-2013 Bing (NTTData)  Created
*/
trigger AttachmentAfter on Attachment (after insert) {
    if (!TriggerUtil.isTriggerEnabled('AttachmentAfter')) {
        return;
    }

    List<id> caseIds = new List<id>();

    for(Attachment a : trigger.new){
        //for purpose No.1
        String parentIdString = String.valueof(a.parentId);
        if(trigger.isInsert && parentIdString.startsWith('500')){
            caseIds.add(a.parentId);
        }
    }

    //for purpose No.1
    if(caseIds.size()>0){
        ComplaintDesHelper.sendMailToCaseMember(caseIds);
    }
}