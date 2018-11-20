/**
* @purpose 		: Server side controller for Lighting component which clones sObject with provided recordId
* @author		: ishwar.mete
* @created Date : 16 Oct, 2018
*/
public class SObjectCloneCtrl {

    @AuraEnabled
    public static SObject getSObjRecordWithAllFields(Id recordId) {        
        String sObjectName = recordId.getSObjectType().getDescribe().getName();
        Map<String,Schema.SObjectField> sObjectFieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        String query = 'SELECT ';
        
        for(String fieldName : sObjectFieldMap.keySet()) {
            Schema.DescribeFieldResult field = sObjectFieldMap.get(fieldName).getDescribe();
            
            if(field.isCreateable() && field.isUpdateable()) {
                query += fieldName + ', ' ;
            }
            
        }
        
        query = query.removeEnd(', ');
        
        query += ' FROM ' + sObjectName + ' WHERE Id = :recordId';
        
        SObject sobjInst = Database.query(query).clone();
        return sobjInst;
    }
}