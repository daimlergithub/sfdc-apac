/**************************************************************************************************************************************************************************** 
* File Name     : UtilLTG
* Description   : Lightning Utility class to support Lightning implementation. Contails generic Utility Methods
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class UtilLTG {
     public static Map<String, String> retrieveFieldLables(string objectName){
        String type='Address__c';
        Map<String, String> fieldNameLabelMap = new Map<String, String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        //Creating sObject for dynamic selected object  
        Schema.SObjectType systemObjectType = gd.get(objectName);  
        //Fetching field results  
        Schema.DescribeSObjectResult r= systemObjectType.getDescribe();  
        Map<String, Schema.SObjectField> M = r.fields.getMap();  
        //Creating Map of fieldname and field labels 
        for(Schema.SObjectField fieldAPI : M.values()){  
            fieldNameLabelMap.put(fieldAPI.getDescribe().getName(), fieldAPI.getDescribe().getLabel());
        }  
        return fieldNameLabelMap;
        
    }
    /**
     * Returns object labels from arbitrary query String, flattening out relationships:
     * e.g. 'SELECT Name, Id, SomeCustom__c, OtherCustom__r.Name, OtherCustom__r.DeepInside__r.color from SomeObj__c WHERE ....'
     **/
    /*public static Map<String, String> retrieveFieldLablesFromQuery(String queryString){
        return null;
    }
    
    public static Map<String, String> retrieveFieldLablesFromFieldList(List<String> fieldList, String objName){
        return null;
    }*/
    public static user getUserRec(String userId)
    {
        User user;
        try
        {
            user=[select id,Market__c,ContactId,IsPortalEnabled from User where id=:userId];
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage()); 
        }
        return user;
    }  

}