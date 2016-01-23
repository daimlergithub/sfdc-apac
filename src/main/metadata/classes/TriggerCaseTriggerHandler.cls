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
public class TriggerCaseTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        Map<Id,Case> oldmap = (Map<Id,Case>)trigger.oldmap;
        Map<Id,Case> newmap = (Map<Id,Case>)trigger.newmap;
        
        if (trigger.isAfter && (trigger.isInsert || trigger.isUnDelete)) {
            UtilCase.rollupAccountComplaintAmount(trigger.new);
        }
    
        if (trigger.isAfter && trigger.isDelete) {
            UtilCase.rollupAccountComplaintAmount(trigger.old);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}