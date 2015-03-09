/*
    Type:       Utility for RecordType for replacing SOQL
    Purpose:    Get Record Type Name By Id or Id by Name
    User Story: US-DD-002
    Used By:    AccountMergeController.cls
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-3-11.

*/
global with sharing class UtilRecordType {
	
	public final static String Account_Object = 'Account';  
	public final static String person_Account = 'Person Account';  
	public final static String Dealer = 'Dealer';  
	
	public final static String Vehicle_Relationship ='Vehicle_Relationship__c';
    public final static String Vehicle_Relationship_Retail ='Vehicle Relationship Retail';
  
    private static Map<Id, Schema.RecordTypeInfo> recordTypeInfoByIdMap = 
        new Map<Id, Schema.RecordTypeInfo>();

    private static Map<String, Schema.RecordTypeInfo> recordTypeInfoByNameMap = 
        new Map<String, Schema.RecordTypeInfo>();

    private static Set<String> sobjectsSet = new Set<String>();
    
    private static void populateRecordTypeMap(String sobjectName) {
        // If sobjectSet doesn't contain sobjectName, we need to populate the 
        // recordTypeByNameMap and recordTypeByIdMap of this sobject
        if (sobjectsSet.contains(sobjectName)) {
            return;
        }
        else {
            sobjectsSet.add(sobjectName);
        }

        // Get SobjectType by sobjectName
        Schema.SobjectType sobjectType = 
            Schema.getGlobalDescribe().get(sobjectName);

        // Populate the recordtypeInfoById and recordtypeInfoByName Map
        recordTypeInfoByIdMap.putAll(
            sobjectType.getDescribe().getRecordTypeInfosById());

        recordTypeInfoByNameMap.putAll(
            sobjectType.getDescribe().getRecordTypeInfosByName());
    }

    // Gets the object record type name according to the recordTypeId.
    public static String getRecordTypeNameById(String sobjectName, 
        Id recordTypeId) {

        populateRecordTypeMap(sobjectName);
        return recordTypeInfoByIdMap.get(recordTypeId).getName();
    }
    
    // Gets the object record type id according to the recordType name.
    public static String getRecordTypeIdByName(String sobjectName, 
        String recordTypeName) {
        
        populateRecordTypeMap(sobjectName);   
        return recordTypeInfoByNameMap.get(recordTypeName).getRecordTypeId();
    }
}