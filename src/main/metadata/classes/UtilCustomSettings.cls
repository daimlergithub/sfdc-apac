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
    // If no corresonding data, just assign default true
    public static Boolean isEnabled(String triggerName) {
        try {
            return Trigger_Status__c.getAll().get(triggerName).Enabled__c;         
        }
        catch (NullPointerException e) {
            System.debug('UtilCustomSettings.isEnable() Exception: ' + e);
            return true;
        }
    }
    
    public static Id getProfileId(String profileName)
    {
    	try {
            return Environment_Specific_Values__c.getAll().get(profileName).Value__c;         
        }
        catch (NullPointerException e) {
            return null;
        }
    }
}