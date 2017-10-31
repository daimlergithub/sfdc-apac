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
    21-Apr-2015 Gerhard Henning (NTTData)  Moved to AttachmentAfterTriggerHandler
*/
public class AttachmentAfterTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<id> caseIds = new List<id>();
    
        for(Attachment a : (List<Attachment>)trigger.new){
            // for purpose No.1
            String parentIdString = String.valueof(a.parentId);
            if(trigger.isInsert && parentIdString.startsWith('500')){
                caseIds.add(a.parentId);
            }
        }
    
        // for purpose No.1
       /* if (caseIds.size()>0) {
        //TODO Commented as part of unused class removal task
            //ComplaintDesHelper.sendMailToCaseMember(caseIds);
        }*/
    }
       public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<id> caseIds = new List<id>();
    
        for(Attachment a : (List<Attachment>)trigger.new){
            // for purpose No.1
            String parentIdString = String.valueof(a.parentId);
            if(trigger.isInsert && parentIdString.startsWith('500')){
                caseIds.add(a.parentId);
            }
        }
    }
}