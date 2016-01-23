/*
    Type:       Abstraction of trigger handler
    Purpose:    A trigger handler contgains all code to be executed when a trigger is called.
                The trigger itself must contain no code except the call to the trigger handler.
    ---------------------------------------------------------------
    History:
    
    1. HNG Created on 2015-04-21
*/
public interface TriggerHandlerIf
{
    void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter);
    void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter);
}