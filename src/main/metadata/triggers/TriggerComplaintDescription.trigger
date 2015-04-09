trigger TriggerComplaintDescription on Complaint_Description__c (before insert,after insert,after update, after delete) {
  /*
    Type:       Trigger
    Purpose:    1. When a complaint description created, update date time with current time, update created by with current user.
    User Story: US-DPCR-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    24-July-2013 Sinow Zhang (NTTData)  Created
*/
 /*
    Type:       Trigger
    Purpose:    1. Update the Description flag on Case when the Description is changed.
    Used By:    
    ---------------------------------------------------------------
    History:
    
    6-May-2014   Cyril Huang (NTTData) Created
*/  
    /*Type:       Trigger  
    Purpose:    1. As the case team member, when a  team member  create  a complaint description/ resolution
                 on MB Complaint , and the �Urgent� field of the case is ticked, an notify email will be
                 sent to other case team members.
    User Story:
    Used By:
    ---------------------------------------------------------------
    History:

    5-Dec-2013 Bing (NTTData)  Created
*/
    
    if (!TriggerUtil.isTriggerEnabled('TriggerComplaintDescription')) {
        return;
    }
   
    if (trigger.isAfter && trigger.isInsert) {
        ComplaintDesHelper.before_AfterInsertEvents(Trigger.new);       
    }
    if (trigger.isAfter && trigger.isUpdate) {
        ComplaintDesHelper.afterupdateEvents(Trigger.new,trigger.oldmap);   
    }
    if (trigger.isAfter && trigger.isdelete) {
        ComplaintDesHelper.afterDeleteEvents(Trigger.old);  
    }
    if (trigger.isBefore && trigger.isInsert) {
         ComplaintDesHelper.updateComplaintDateandCreatedBy(Trigger.new);    
    }
}