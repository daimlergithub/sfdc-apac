/*
    Type:       Retail Campaign Calendar Controller
    Purpose:    Query User and Retail Campaign Information shown on Calendar
    User Story: Release 1.2 Retail Campaign
    Used By:    Retail_Campaign_Timeline （VF)
    ---------------------------------------------------------------
    History:

    29-May-2013 Sinow Created
    2014-11-12  zhongyang.si update
*/
public with Sharing class RetailCampaignCalendarController {
    /* Public Properties */
    String userLan;        // Current User Language
    List<Campaign> theCamps;      // Campaign
    public Id partId;   //ParentId
    
    /* Construction */
    void RetailCampaignCalendarController(){
        PageReference pageRef = ApexPages.currentPage();
        // Get Campaign Partner Id From URL.
        partId = pageRef.getParameters().get('ParentId');   
        // Current Login User Language.
        userLan = getUserLan();
    }

    /* Get Current Login User Information */
    public String getUserLan() {
        // Current Login User Language.
        return UserInfo.getLanguage();
    }
    
    /* Get Central Campaign Information */
    @RemoteAction
    public static List<Retail_Campaign__c> queAfterSalesCamps(String currYear, String endYear, String cat, String tp) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        // Get Central Maketing Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Campaign_Type__c, Feedback_Status__c, Plan_End_Date__c, Plan_Start_Date__c, Relevant_Central_Campaign__c, Media_Type__c, Event_Type__c From Retail_Campaign__c ';
        String whrSTR = ' Where ';
        String whrAND = ' AND ';
        String whrCurD = '';
        String whrEndD = '';
        String whrTp = '';
        String whrStatus = 'Cancelled';
        String whrRecTpId = 'RecordTypeId = :cmcpId AND Feedback_Status__c != :whrStatus';
               
        // Campaign Collection
        List<Retail_Campaign__c> theCamps = new List<Retail_Campaign__c>();
        
        // where condition combination
        if (currYear != null && currYear != ''){
            cuDate = date.valueOf(currYear+'-1'+'-1');
            whrCurD = 'Plan_Start_Date__c != Null AND Plan_Start_Date__c >= :cuDate AND ';
        }
        if (endYear != null && endYear != ''){
            enDate = date.valueOf(endYear+'-12'+'-31');
            whrEndD = 'Plan_End_Date__c != Null AND Plan_End_Date__c <= :enDate AND ';
        }
        if(tp != '' && tp != 'All'){
            whrTp = 'Campaign_Type__c = :tp AND ';
        }        
        
        whrSTR = whrSTR + whrCurD + whrEndD +  whrTp + whrRecTpId;
        theCamps = Database.query(selSTR + whrSTR);
        return theCamps;
    }
    
    /* Get S&M Media Retail Campaign Information */
    @RemoteAction
    public static List<Retail_Campaign__c> queSMMediaCamps(String currYear, String endYear, String tp) {

        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        // Get S&M Media Retail Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Campaign_Type__c, Feedback_Status__c, Plan_End_Date__c, Plan_Start_Date__c, Relevant_Central_Campaign__c, Media_Type__c, Event_Type__c From Retail_Campaign__c ';
        String whrSTR = ' Where ';
        String whrAND = ' AND ';
        String whrCurD = '';
        String whrEndD = '';
        String whrTp = '';
        String whrStatus = 'Cancelled';
        String whrRecTpId = 'RecordTypeId = :cmcpId AND Feedback_Status__c != :whrStatus';
        
        // Campaign Collection
        List<Retail_Campaign__c> theCamps = new List<Retail_Campaign__c>();
        
        // where condition combination
        if (currYear != null && currYear != ''){
            cuDate = date.valueOf(currYear+'-1'+'-1');
            whrCurD = 'Plan_Start_Date__c >= :cuDate AND ';
        }
        if (endYear != null && endYear != ''){
            enDate = date.valueOf(endYear+'-12'+'-31');
            whrEndD = 'Plan_End_Date__c <= :enDate AND ';
        }
        if(tp != '' && tp != 'All'){
            whrTp = 'Media_Type__c = :tp AND ';
        } 

        whrSTR = whrSTR + whrCurD + whrEndD + whrTp + whrRecTpId;
        theCamps = Database.query(selSTR + whrSTR);
        return theCamps;
    }
    
    /* Get S&M Event Retail Campaign Information */
    @RemoteAction
    public static List<Retail_Campaign__c> queSMEventCamps(String currYear, String endYear, String cct) {

        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        // Get S&M Event Retail Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Campaign_Type__c, Feedback_Status__c, Plan_End_Date__c, Plan_Start_Date__c, Media_Type__c, Event_Type__c From Retail_Campaign__c ';
        String whrSTR = ' Where ';
        String whrAND = ' AND ';
        String whrCurD = '';
        String whrEndD = '';
        String whrCCT = '';
        String whrRecTpId = 'RecordTypeId = :cmcpId';
        
        // Campaign Collection
        List<Retail_Campaign__c> theCamps = new List<Retail_Campaign__c>();
        
        // where condition combination
        if (currYear != null && currYear != ''){
            cuDate = date.valueOf(currYear+'-1'+'-1');
            whrCurD = 'Plan_Start_Date__c != Null AND Plan_Start_Date__c >= :cuDate AND ';
        }
        if (endYear != null && endYear != ''){
            enDate = date.valueOf(endYear+'-12'+'-31');
            whrEndD = 'Plan_End_Date__c != Null AND Plan_End_Date__c <= :enDate AND ';
        }
        // Patrick begins here
        if (cct != null && cct != '' && cct != 'All'){
            whrCCT = 'Event_Type__c = :cct AND ';
        }
        // To here
        whrRecTpId = 'RecordTypeId = :cmcpId';
        whrSTR = whrSTR + whrCurD + whrEndD + whrCCT + whrRecTpId;
        theCamps = Database.query(selSTR + whrSTR);
        return theCamps;
    }
}