/*
    Type:       Trigger
    Purpose:    1. When a complaint description created, update date time with current time, update created by with current user.
                2. Update the Description flag on Case when the Description is changed.
                3. As the case team member, when a  team member  create  a complaint description/ resolution
                   on MB Complaint , and the Urgent field of the case is ticked, an notify email will be
                   sent to other case team members.
    User Story: US-DPCR-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    24-July-2013 Sinow Zhang (NTTData)  Created
    5-Dec-2013 Bing (NTTData)  Created
    6-May-2014   Cyril Huang (NTTData) Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerComplaintDescriptionHandler
*/
public class TriggerComplaintDescriptionHandlerJP 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market specific implementation.
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}