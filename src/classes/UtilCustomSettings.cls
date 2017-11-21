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
    
    
    public static boolean getIsEnableCommunity(String communityLicenseSwitchName)
    {	
	    if (communityLicenseSwitchName != null && Community_License_Switch__c.getAll().get(communityLicenseSwitchName) != null) {
            return boolean.valueof(Community_License_Switch__c.getAll().get(communityLicenseSwitchName).Enable__c);         
		}
		else {
		    return false;
        }
    }
	
	public static string getWebserviceUrl(string webServiceName)
    {
        if (webServiceName != null && EP_Integration_URLS__c.getAll().get(webServiceName) != null) {
            return String.valueof(EP_Integration_URLS__c.getAll().get(webServiceName).EP_WebService_1DR__c);         
		}
		else {
		    return null;
        }
        
    }
    
}