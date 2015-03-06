Global with sharing class UtilConstant {
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;
    public final static String Ingretion_Profile = 'IntegrationAPI';  
   // Initiate roleMap
    private static Map<String, Id> getUserRoleMapInstance() {
        if (roleMap == null) {
            roleMap = new Map<String, Id>();
            for (UserRole role : [SELECT Id, Name FROM UserRole LIMIT 1000]) {
                roleMap.put(role.Name, role.Id);
            }
        }
        
        return roleMap;
    }
     // Initiate profileMap
    private static Map<String, Id> getProfileMapInstance() {
        if (profileMap == null) {
            profileMap = new Map<String, Id>();
            for (Profile prof : [SELECT Id, Name FROM Profile LIMIT 1000]) {
                profileMap.put(prof.Name, prof.Id);
            }
        }
        
        return profileMap;
    }
    
    // Get UserRoleId by Role Name
    Public static Id getUserRoleId(String roleName) {
        return getUserRoleMapInstance().get(roleName);
    }
    
    // Get ProfileId by Profile Name
    Public static Id getProfileId(String profileName) {
        return getProfileMapInstance().get(profileName);
    } 
}