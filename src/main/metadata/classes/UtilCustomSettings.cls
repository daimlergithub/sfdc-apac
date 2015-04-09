/*
    Type:       Utility for disable trigger 
    Purpose:    This way we can easily enabled/disable all/individual trigger
    User Story: Every Trigger
    Used By:    All Triggers
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-05-06
*/
public class UtilCustomSettings {
    public static Boolean isEnabled(String triggerName) {
	    if (triggerName != null && Trigger_Status__c.getAll().get(triggerName) != null) {
            return Trigger_Status__c.getAll().get(triggerName).Enabled__c;         
		}
		else {
            // If no corresonding data, just assign default true
		    return true;
		}
    }
    
    public static Id getProfileId(String profileName)
    {
	    if (profileName != null && Environment_Specific_Values__c.getAll().get(profileName) != null) {
            return Environment_Specific_Values__c.getAll().get(profileName).Value__c;         
		}
		else {
		    return null;
        }
    }
}