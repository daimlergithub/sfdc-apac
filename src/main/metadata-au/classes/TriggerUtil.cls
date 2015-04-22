/*
    Type:       Utility methods for triggers
    ---------------------------------------------------------------
    History:
    
    1. HNG Created on 2015-04-09
*/
public class TriggerUtil 
{
    public static Boolean isTriggerEnabled(String aTriggerName) 
    {
        return isTriggerEnabled(getTriggerInfo(aTriggerName));
    }
    
    public static Boolean isTriggerEnabled(Trigger__c aTriggerInfo) 
    {
	    if (aTriggerInfo != null) {
            return aTriggerInfo.enabled__c;
		}
        else {
		    return true;
        }
    }
    
    public static void handleTrigger(String aTriggerName)
    {
        Trigger__c triggerInfo = getTriggerInfo(aTriggerName);
        
        if (isTriggerEnabled(triggerInfo)) {
            TriggerHandlerIf triggerHandler = getTriggerHandler(triggerInfo);
            
            if (triggerHandler != null) {
                triggerHandler.handleTrigger();
            }
        }
    }
    
    public static Trigger__c getTriggerInfo(String aTriggerName) 
    {
	    if (aTriggerName != null) {
            for (Trigger__c triggerInfo : Trigger__c.getAll().values()) {
                if (aTriggerName.equals(triggerInfo.Trigger_Name__c)) {
                    if (trigger.isAfter && !triggerInfo.after__c) {
                        continue;
                    }
                    if (trigger.isBefore && !triggerInfo.before__c) {
                        continue;
                    }
                    if (trigger.isInsert && !triggerInfo.insert__c) {
                        continue;
                    }
                    if (trigger.isUpdate && !triggerInfo.update__c) {
                        continue;
                    }
                    if (trigger.isDelete && !triggerInfo.delete__c) {
                        continue;
                    }
                    return triggerInfo;
                }
            }
		}
        
        // If no corresonding data, just return null
		return null;
    }
    
    public static TriggerHandlerIf getTriggerHandler(Trigger__c aTriggerInfo)
    {
        if (aTriggerInfo != null && aTriggerInfo.Trigger_Handler__c != null) {
            Type triggerHandlerType = Type.forName(aTriggerInfo.Trigger_Handler__c);
            
            if (triggerHandlerType == null) {
                throw new IllegalArgumentException('Configured trigger handler class ' + aTriggerInfo.Trigger_Handler__c + ' not found. Please check custom setting Trigger for trigger name ' + aTriggerInfo.Trigger_Name__c);
            }
            
            return (TriggerHandlerIf)triggerHandlerType.newInstance();
        }
        else {
            return null;
        }
    }
}