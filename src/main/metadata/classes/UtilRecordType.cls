/*
    Type:       Utility for RecordType for replacing SOQL
    Purpose:    Get Record Type Name By Id or Id by Name
    User Story: US-DD-002
    Modified By : Sneha Chail
    Modified date : 10-Oct-2015
    
*/
global with sharing class UtilRecordType {   
          
     //added a private constructor to prevent Singleton. 
     private UtilRecordType(){}
     
     // Gets the object record type name according to the recordTypeId.
     public static String getRecordTypeNameById(String sObjectType,Id recordTypeId) {        
        //Generate a map for all the Record Types for the desired object
        Map<Id,Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getRecordTypeInfosById();
       //Retrieve the record type Name by Id
        return recordTypeInfo.get(recordTypeId).getName();
     }
    // Gets the object record type id according to the recordType name. 
     public static String getRecordTypeIdByName(String sObjectType, String recordTypeName)
      {
         system.debug('&&&recordTypeName '+recordTypeName);
        //Generate a map for all the Record Types for the desired object
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getRecordTypeInfosByName();
        //Retrieve the record type by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
     }

    // Gets the object record type id according to the recordType name.   
    public static String getRecordTypeNameByName(String sObjectType, String recordTypeName)
      {
         system.debug('&&&recordTypeName '+recordTypeName);
        //Generate a map for all the Record Types for the desired object
         Map<String,Schema.RecordTypeInfo> recordTypeInfo = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getRecordTypeInfosByName();
        //Retrieve the record type by name
        return recordTypeInfo.get(recordTypeName).getName();
     }

     // Returns a List of the Names of all RecordTypes
    // available to the running user for a given SOBject type
    public static List<String> GetAvailableRecordTypeNamesForSObject(
        Schema.SObjectType objType
    ) {
        List<String> names = new List<String>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        // If there are 2 or more RecordTypes...
        if (infos.size() > 1) {
            for (RecordTypeInfo i : infos) {
               if (i.isAvailable() 
               // Ignore the Master Record Type, whose Id always ends with 'AAA'.
               // We check the Id because Name can change depending on the user's language.
                && !String.valueOf(i.getRecordTypeId()).endsWith('AAA'))
                    names.add(i.getName());
            }
        } 
        // Otherwise there's just the Master record type,
        // so add it in, since it MUST always be available
        else names.add(infos[0].getName());
        return names;
    }


}