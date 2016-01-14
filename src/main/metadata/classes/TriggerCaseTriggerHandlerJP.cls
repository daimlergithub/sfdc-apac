/*
  Name                 : TriggerCase
  Object               : Case
  Requirement          : US-Cpn-010
  Refer classes        : UtilCase.cls
  Author               : Mouse Liu
  Create Date          : 2013/7/9
  Modify History       : 
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerCaseTriggerHandler
 
 */
public class TriggerCaseTriggerHandlerJP 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}