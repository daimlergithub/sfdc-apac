public class UtilProfile 
{
    public static Id getProfileId(String aProfileName)
    {
        return getProfile(aProfileName).Id;
    }
    
    public static Profile getProfile(String aProfileName)
    {
        List<Profile> matchingProfiles = [select Id from Profile where Name = :aProfileName];
        
        if (matchingProfiles == null || matchingProfiles.size() == 0) {
            throw new IllegalArgumentException('Unknown profile ' + aProfileName);
        }
        if (matchingProfiles.size() > 1) {
            throw new IllegalArgumentException('Multiple profiles found for name ' + aProfileName);
        }
        
        return matchingProfiles[0];
    }
}