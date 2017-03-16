/*
    Type:       TriggerHandler Class for MBK
    Purpose:    1. Used to call the User helper for public group creation and member creation for dymnamic apex share functionality.
    Used By:    MBK
    ---------------------------------------------------------------
    History:
    
    23-Feb-2017 Sukumar (NTTData)  Created
*/
public with sharing class UserTriggerHandlerKR 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if ((trigger.isAfter  && isInsert)){  
                UserHelper.grpCreationandUsergrpAlign((List<User>)trigger.new);
            }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}