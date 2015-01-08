/*
    Type:       Apex Class
    Purpose:    Get all field name grouped by object
    User Story: 
    Used By:
    Usage:      UtilFieldApiByObjMap m = new UtilFieldApiByObjMap()
    			Map<String, Schema.SObjectField> fieldMap = m.getFieldNameMap('Account');      
    ---------------------------------------------------------------
    History:
    
    7-May-2013 Jorry Chen (Breakingpoint)    Created
*/

public class UtilFieldApiByObjMap {
	public Map<String, Schema.SObjectField> getFieldNameMap(String objName) {
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType tmpSchema = schemaMap.get(objName);
		Map<String, Schema.SObjectField> fieldMap = tmpSchema.getDescribe().fields.getMap();
		
		return fieldMap;
	}
}