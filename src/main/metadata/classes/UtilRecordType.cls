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

}