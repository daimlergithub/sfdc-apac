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
	    if (aTriggerName != null) {
            for (Trigger_Enabled__c triggerEnabledInfo : Trigger_Enabled__c.getAll().values()) {
                if (aTriggerName.equals(triggerEnabledInfo.Trigger_Name__c)) {
                    if (trigger.isAfter && !triggerEnabledInfo.after__c) {
                        continue;
                    }
                    if (trigger.isBefore && !triggerEnabledInfo.before__c) {
                        continue;
                    }
                    if (trigger.isInsert && !triggerEnabledInfo.insert__c) {
                        continue;
                    }
                    if (trigger.isUpdate && !triggerEnabledInfo.update__c) {
                        continue;
                    }
                    if (trigger.isDelete && !triggerEnabledInfo.delete__c) {
                        continue;
                    }
                    return triggerEnabledInfo.enabled__c;
                }
            }
		}
        
        // If no corresonding data, just assign default true
		return true;
    }
}