Global with sharing class UtilConstant {
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;
    public final static String Ingretion_Profile = 'IntegrationAPI';
    public final static String DEALER_DELEGATE_ADMIN = 'Dealer Delegate Admin';
    public final static String DEALER_COMMUNITY_USER = 'Dealer Community User';
    public final static String SALES_LEADS = 'Vehicle Lead';
    public final static String AFTER_SALES_LEADS = 'Service/Parts Lead';
    public final static String RETAIL_SALES_LEADS = 'Retail Sales Leads';
    public final static String AS_RETAIL_CAMPAIGN = 'AS Retail Campaign';
    public final static String DEALER_LEAD_GATE_KEEPER_QUEUE = 'Dealer Lead Gate Keeper Queue';
    public final static String LEAD = 'Lead__c';
    public final static String MBDA_LEAD = 'MBDA Leads';
    public final static String SMS = 'SMS';
    public final static String MMS = 'MMS';
    public final static String DEALER = 'Dealer';
    public final static String MONTHLY_TA = 'Monthly TA';
    public final static String SALES_MARKETING = 'Sales & Marketing Yearly TA';
    public final static String AFTER_SALES_YEARLY = 'Aftersales Yearly TA';
    public final static String OB_TASK = 'OB Task';
    public final static String REGIONAL_CRM_MANAGER_E = 'Regional CRM Mgr (E)';
    public final static String REGIONAL_CRM_MANAGER_S = 'Regional CRM Mgr (S)';
    public final static String REGIONAL_CRM_MANAGER_W = 'Regional CRM Mgr (W)';
    public final static String REGIONAL_CRM_MANAGER_N = 'Regional CRM Mgr (N)';
    public final static String MB_COMPLAINT = 'MB Complaint';
    public final static String CHRYSLER_COMPLAINT = 'Chrysler Complaint';
    public final static String MBDA_COMPLAINT = 'MBDA Complaint';
    public final static String RETAIL_CAMPAIGN = 'Retail Campaign';
    public final static String Enquiry = 'Enquiry';
    public final static String CAC_IB_TL = 'CAC IB TL';
    public final static String SSI_TASK = 'SSI Task';
    public final static String WELCOME_CALL = 'Welcome Call';
    public final static String IB_CALL = 'IB Call';
    public final static String OB_CALL = 'OB Call';
    public final static String SUCCESSFUL = 'successful';
    public final static String VALID = 'Valid';
    public final static string SSI='ssi__c';
    public final static string CLOSED='Closed';
    public final static string COMMUNITY_LICENSE_SWITCH='Community Enabled';  
    public final static string ORGWIDE_EMAIL_ADDRESS='DailyAssignedLeadsReport eMail Address';
    public final static string ORGWIDE_EMAIL_ADDRESS_DEFAULT='customer_care@daimler.com';
    public final static string ORGWIDE_EMAIL_ADDRESS_EMC='EMC Email Address';
    public static boolean Recursivefire=false;
    public final static string ENTITY_UPDATE_NOTIFICATION='Entity Update Notification';
    public final static string DRM_Task ='DRM Task';
    public final static string CURRENT  ='Current';
    public final static string IRREGULAR  ='Irregular';
    public final static string REGULARCOMPILED  ='Irregular Complied';
    public final static String DRM_MBFS = 'DRM MBFS';
    public final static String Finance_Fleet_lead = 'Finance Fleet Lead';
    public final static String Fleet_Vans = 'Fleet Vans';
    
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