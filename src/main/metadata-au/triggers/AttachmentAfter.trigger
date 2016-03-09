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
trigger AttachmentAfter on Attachment (after insert, after delete) 
{
    TriggerUtil.handleTrigger('AttachmentAfter');
}