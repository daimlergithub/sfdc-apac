Global with sharing class UtilConstant {
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;
    public final static String Ingretion_Profile = 'IntegrationAPI';
    public final static String DEALER_DELEGATE_ADMIN = 'Dealer Delegate Admin';
    public final static String DEALER_COMMUNITY_USER = 'Dealer Community User';
    public final static String SALES_LEADS = 'Sales Leads';
    public final static String AFTER_SALES_LEADS = 'Aftersales Leads';
    public final static String DEALER_LEAD_GATE_KEEPER_QUEUE = 'Dealer Lead Gate Keeper Queue';
    public final static String LEAD = 'Lead__c';
    public final static String MBDA_LEAD = 'MBDA Leads';
    public final static String SMS = 'SMS';
    public final static String OB_TASK = 'OB Task';
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