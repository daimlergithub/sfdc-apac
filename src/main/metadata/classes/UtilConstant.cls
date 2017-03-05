Global with sharing class UtilConstant {
    private static Map<String, Id> roleMap;
    private static Map<String, Id> profileMap;
    public final static String Ingretion_Profile = 'IntegrationAPI';
    public final static String DEALER_DELEGATE_ADMIN = 'Dealer Delegate Admin';
    public final static String DEALER_COMMUNITY_USER = 'Dealer Community User';
    public final static String SALES_LEADS = 'Sales Leads';
    public final static String DEALER_SALES_LEADS_READONLY = 'Dealer Sales leads ReadOnly';
    public final static String DEALER_AFTERSALES_LEADS_READONLY = 'Dealer Aftersales Leads ReadOnly';
    public final static String AFTER_SALES_LEADS = 'Aftersales Leads';
    public final static String RETAIL_SALES_LEADS = 'Retail Sales Leads';
    public final static String AS_RETAIL_CAMPAIGN = 'AS Retail Campaign';
    public final static String DEALER_LEAD_GATE_KEEPER_QUEUE = 'Dealer Lead Gate Keeper Queue';
    public final static String LEAD = 'Lead__c';
    public final static String sObjCase='Case';
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
    //Case Rec Type
    public final static String INQUIRY = 'Inquiry';
    public final static String OTHERS = 'Others';
    public final static String COMPLAINT = 'Complaint';
    public final static String CLAIM = 'Claim';
    public final static String REQUEST = 'Request';
    public final static String TOURING_SUPPORT = 'Touring Support';
    public final static String FINANCE = 'Finance';
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
    public final static string read_Access='Read';   
    public final static String Account_Object = 'Account'; 
    public final static String person_Account = 'Person Account';       
    public final static String Vehicle_Relationship ='Vehicle_Relationship__c';
    public final static String Vehicle_Relationship_Retail ='Vehicle Relationship Retail';
    public final static String Contact2Contact ='Contact2Contact';
    public final static String Account_Link='Account_Link__c';
    //Varibale is being used in contactHelper class
    public final static String Empty='';
    public final static String leadOwnerStartWith='00G';
    public final static String leadDealerLMS='LMS';
    public final static String leadDealerLMS_Salesforce='Salesforce';
    //Varibale is being used in contactHelper class
    public final static String whiteSpace=' ';    
    public final static String nullValue='Null';
    // Soft deleted Account Record Type Name
    public final static String RECORDTYPE_PERSON_ACCOUNT_SOFT_DELETED ='Person Account Soft Deleted'; 
     public final static String RECORDTYPE_SALES_LEAD_SOFT_DELETED='Sales Leads Soft Deleted';
    public final static String RECORDTYPE_AFTERSALES_LEAD_SOFT_DELETED='After-Sales Leads Soft Deleted';
    // Soft deleted Account Owner Profile Name
    Public final static String PROFILE_PERSON_ACCOUNT_SOFT_DELETED ='IntegrationAPI';
    Public final static String  PROFILE_SALES_LEAD_SOFT_DELETED='IntegrationAPI';
    Public final static String RECORDTYPE_CONTRACT='Contract'; 
    //used in VehicleExtension class
    public final static string Competitor='Competitor';
    public final static string Question='?';

    //Vehicle Picker constants.
    public final static String MB = 'MB';
    public final String INTERESTED_VEHICLE = 'Interested Vehicle';
    public final String COMPETITOR_VEHICLE = 'Competitor Vehicle';
    public final String CURRENT1_VEHICLE   = 'CurrentVehicle1';
    public final String CURRENT2_VEHICLE   = 'CurrentVehicle2';
    public final String TRADE_IN_VEHICLE   = 'TradeIn';
    public final String PURCHASED_VEHICLE  = 'Purchased';
    public final String VIN = 'VIN';
    public final String VEHICLE_TYPE = 'VehicleType';
    public final String VEHICLE_PRODUCT = 'Vehicle Product';
    public final String SELF_REGISTERED = 'Self Registered';
        
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