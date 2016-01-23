/*
    Type:       Apex Class
    Purpose:    Define methods used in SSITrigger
    User Story: US-SSI-007
    Used By:    SSITrigger.trigger
    ---------------------------------------------------------------
    History:
    
    22-Apr-2013 Chris Huang (Breakingpoint)    Created
    2015-04-21 Gerhard Henning (NTTData)  Moved code to SSITriggerHandler
*/

public class SSITriggerHandlerJP 
    implements TriggerHandlerIf
{ 
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       // Implementation to addedd as required in market

    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }

}