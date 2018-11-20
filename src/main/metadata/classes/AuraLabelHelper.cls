public without sharing class AuraLabelHelper {

    private static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    @AuraEnabled
    public static Map<String, String> retrieveFieldLablesFromFieldList(List<String> fieldList, String objName) {
        Map<String, String> result = new Map<String, String> ();
        Map<String, Schema.SObjectField> fieldDefinitions = internalFieldLablesFromFieldList(fieldList, objName, '');
        for (String key : fieldDefinitions.keySet()) {
            DescribeFieldResult dfr = fieldDefinitions.get(key).getDescribe();
            result.put(key, dfr.getLabel());
        }
        return result;
    }


    private static Map<String, Schema.SObjectField> internalFieldLablesFromFieldList(List<String> fieldList, String objName, String prefix) {
        Map<String, Schema.SObjectField> result = new Map<String, Schema.SObjectField> ();
        Schema.SObjectType objectType = AuraLabelHelper.globalDescribe.get(objName);
        Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
        // Labels for the top level object - needs to be lowercased  
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        Map<String, Schema.SObjectField> fieldMapLower = new Map<String, Schema.SObjectField> ();

        for (String key : fieldMap.keySet()) {
            fieldMapLower.put(key.toLowerCase(), fieldMap.get(key));
        }

        for (String fieldName : fieldList) {
            String fieldNameLower = fieldName.toLowerCase();
            if (fieldMapLower.containsKey(fieldNameLower)) {
                result.put(prefix + fieldNameLower, fieldMapLower.get(fieldNameLower));
            } else if (fieldNameLower.contains('__r.')) {
                // We have a potential relationship field at hand
                String relationFieldName = fieldNameLower.left(fieldNameLower.indexOf('__r.')) + '__c';
                Schema.DescribeFieldResult relationDescribe = fieldMapLower.get(relationFieldName).getDescribe();
                Schema.SObjectType reference = relationDescribe.getReferenceTo().get(0);
                String objApiName = reference.getDescribe().getName();
                List<String> subFieldList = new List<String> ();
                String newPrefix = prefix + fieldNameLower.left(fieldNameLower.indexOf('.')) + '_';
                subFieldList.add(fieldNameLower.substring(fieldNameLower.indexOf('__r.') + 4));
                result.putAll(internalFieldLablesFromFieldList(subFieldList, objApiName, newPrefix));
            }
        }

        return result;
    }
}