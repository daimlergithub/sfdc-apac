/*------------------------------------------------------------
    Author:        Pavan Kumar D
    Company:       Infosys
    Description:   Generic service to Access Recordtypes from one place
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    
    Pattern followed:  Separation of Concerns 
    ------------------------------------------------------------*/
public class RecordTypeAccessService{
    
    private static Map<String, Schema.SObjectType> gd;
    private static Map<String,Map<Id,Schema.RecordTypeInfo>> recordTypesById = new Map<String,Map<Id,Schema.RecordTypeInfo>>();
    private static Map<String,Map<String,Schema.RecordTypeInfo>> recordTypesByName = new Map<String,Map<String,Schema.RecordTypeInfo>>();
        
    private static void fillMapsForRecordTypeObject(string objectName) {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Function to fill record type map for objects not in cache
    Inputs:        objectName - The name of the sObject
    Returns:       Nothing
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    ------------------------------------------------------------*/
        // get the object map the first time
        if (gd==null) gd = Schema.getGlobalDescribe();
 
        // get the object description
        if (gd.containsKey(objectName)) {
            Schema.DescribeSObjectResult d = gd.get(objectName).getDescribe();
            recordTypesByName.put(objectName, d.getRecordTypeInfosByName());
            recordTypesById.put(objectName, d.getRecordTypeInfosById());
        }
    }
 
    public static Id getRecordTypeId(String objectName, String recordTypeName) {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Gives record type id from a given sObject and record type label
    Inputs:        objectName - The sObject
                   recordTypeName - The name of the record type (NOT the API Name)
    Returns:       The specified record types id value
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    ------------------------------------------------------------*/
        // make sure we have this object's record types mapped
        if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForRecordTypeObject(objectName);
 
        // now grab and return the requested id 
        Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
        if (rtMap != null && rtMap.containsKey(recordTypeName)) {
            return rtMap.get(recordTypeName).getRecordTypeId();
        } else {
            return null;
        }
    }
 
    public static String getRecordTypeName(String objectName, Id recordTypeId) {
    /*------------------------------------------------------------
    Author:        Chyan Yee Goh
    Company:       Salesforce.com
    Description:   Gives record type name from a given sObject and record type id
    Inputs:        objectName - The sObject
                   recordTypeId - The id of the record type
    Returns:       The specified record types name value (the label NOT the API name)
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    ------------------------------------------------------------*/
        // make sure we have this object's record types mapped
        if (!recordTypesById.containsKey(objectName)) 
            fillMapsForRecordTypeObject(objectName);
 
        // now grab and return the requested id
        Map<Id,Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
        if (rtMap != null && rtMap.containsKey(recordTypeId)) {
            return rtMap.get(recordTypeId).getName();
        } else {
            return null;
        }
    }
}