/* File Name   : retrieveFieldsFromFieldSetsController -->
<!-- Description : retrieveFieldsFromFieldSetsController apex class supported for AfterSalesLeadEditPageLC -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 18-June-2018  */
public class RetrieveFieldsFromFieldSetsController {
    
    @AuraEnabled
    public static Map<String, list<String>> getFieldSetValues(List<String> fieldSetNames, String objectName){
        Map<String, list<String>> fieldSetMap = new Map<String, list<String>>();        
        if(!fieldSetNames.isEmpty() && String.isNotBlank(ObjectName)){
            for(String s:fieldSetNames){               
                fieldSetMap.put(s, RetrieveFieldsFromFieldSetsController.getOneFieldSetValue(s,objectName));
            }
        }
        return fieldSetMap;
    } 
    
    public static List<String> getOneFieldSetValue(String s, String objectName) {
        List<String> fieldMembers = new List<String>();       
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(s);
        List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();                
        for(Schema.FieldSetMember sc:fieldSetMemberList ){
            string name=sc.getFieldPath();
            fieldMembers.add(name);    
        }
        return fieldMembers;
    }
}