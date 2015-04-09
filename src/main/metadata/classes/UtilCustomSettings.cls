/*
    Type:       Utility for CustomerSettings 
    Purpose:    Access to CustomSettings
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-05-06
*/
public class UtilCustomSettings {
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