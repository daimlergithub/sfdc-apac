/**
    * <h1>Add Two Numbers!</h1>
    * The AddNum program implements an application that
    * simply adds two given integer numbers and Prints
    * the output on the screen.
    * <p>
    * <b>Note:</b>This class contains utility methods which 
    * can be reused to Generate the Queries for SObject .
    *
    * @author  : Mukul Goel
    * @Company : Infosys Pvt. Ltd.
    * @version : 1.0
    * @Created : 2018-07-20
*/
public class sObjectMappingUtility {

    private String market;
    private String sourceObject;
    private String destinationObject;
    private String operation;
    private String varSRName;
    private String recordType;
    private Map < String, String > mapSourceDestination;
    private String query;
    private final String qSELECT = 'select ';
    private final String qFROM   = ' from ';
    private final String qWHERE  = ' where ';
    private final String EMPTY   = '';
    public sObjectMappingUtility() {
        this.query = '';
    }
    public sObjectMappingUtility(String market, String operation) {
        List < String > varOperationListParam = new List < String > ();
        List < String > varObjList = new List < String > ();
        mapSourceDestination = new Map < String, String > ();
        varOperationListParam = operation.split('_');        
        for(Integer i=0; i< varOperationListParam.size();i++)
        {
            if(i == 0)
               this.operation = varOperationListParam[0];
             else if (i == 1 )
             { 
                varObjList = String.valueOf(Operation_Mapping__c.getAll().get(varOperationListParam[1]).Operation_Parameters__c).split(';');          
             }
            else if(i == 2)
                this.recordType = varOperationListParam[2];
        }       
        this.market = market; 
        this.sourceObject = varObjList[0];
        this.destinationObject = varObjList[1];
        this.varSRName = market + varObjList[2];  
        this.query = '';
    }

    public Map < String, String > getFieldMappingList() {
        StaticResource varSR = [SELECT Id, Body FROM StaticResource WHERE Name =: varSRName LIMIT 1];
        Blob varCSVBlob = varSR.Body;
        String varCSVContent = varCSVBlob.toString();
        Integer lineProcessed = 0;
        Boolean Bydirectional = false;
        List < string > lstLineContent;
        Integer sourceColumnNum=-1;
        Integer destinationColumnNum=-1;
        Integer sourceOpColumnNum=-1;
        Integer recordTypeColumnNum=-1;
        system.debug('RecordType' + recordType);
        for (String tempRow: varCSVContent.split('\n')) {
            lstLineContent = tempRow.split(',');
            if (lineProcessed == 0) {
                for (Integer i = 0; i < lstLineContent.size(); i++) {
                    if (lstLineContent[i] == sourceObject)
                        sourceColumnNum = i;
                    else if (lstLineContent[i] == destinationObject)
                        destinationColumnNum = i;
                    else if (lstLineContent[i] == sourceObject + ' - ' + operation)
                        sourceOpColumnNum = i;
                    else if (lstLineContent[i] == recordType)
                        recordTypeColumnNum = i;                    
                }
                lineProcessed++;
            } else {
                if (Boolean.valueOf(lstLineContent[sourceOpColumnNum]) &&
                            ((recordTypeColumnNum != -1 && Boolean.valueOf(lstLineContent[recordTypeColumnNum]))
                             || recordTypeColumnNum == -1 ))
                    mapSourceDestination.put(lstLineContent[sourceColumnNum], lstLineContent[destinationColumnNum]);
            }
        }
    system.debug('Value of' + mapSourceDestination);
         return mapSourceDestination;
    }
    
    public sObject mapFieldValues(sObject sourceValues, sObject destinationValue) {
        getFieldMappingList();
        for (String sourceField: mapSourceDestination.keyset()) {
            if(sourceValues.get(sourceField) != null && !(destinationValue.get(mapSourceDestination.get(sourceField)) != null))
                destinationValue.put(mapSourceDestination.get(sourceField), sourceValues.get(sourceField));
        }
        return destinationValue;
    }
    
 
    
    public String generateQueryFromFieldSet(String fieldSetName,String sObjectName){
        
        List<String> lstFieldName = new List<String>();
        Map<String,String> mapLookupReferenceField = new Map<String,String>();        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        mapLookupReferenceField.put('objectToQuery',sObjectName);
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        for(Schema.FieldSetMember tempFieldSetMember :  fieldSetObj.getFields())
        {
            lstFieldName.add(tempFieldSetMember.getFieldPath());
        }
        generateSelectedQuery(FALSE, lstFieldName,mapLookupReferenceField,null);
        return query;
    }
    
    public String generateQueryFromSObject(String sObjectName){
        
        Map<String, Schema.SObjectField> objectFields;    
        objectFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        Map<String,String> mapLookupReferenceField = new Map<String,String>();
        mapLookupReferenceField.put('objectToQuery',sObjectName);
        generateSelectedQuery(FALSE, new List<String>(objectFields.keyset()),mapLookupReferenceField,null);
        return query;
    }
    
    public String generateSelectedQuery(Boolean copySourceDestination, List<String> additionalFields, 
                                    Map<String,String> mapLookupReferenceField,
                                    Map<String,String> mapQueryParamOperator){ 
       
        String sourceLookupField;
        String destinationLookupField;
        String objectToQuery;
        String queryParamString;
        if(mapLookupReferenceField != null)
        {
            objectToQuery =  mapLookupReferenceField.get('objectToQuery');
            sourceLookupField = mapLookupReferenceField.get('sourceLookupReference');
            destinationLookupField = mapLookupReferenceField.get('destLookupReference');
        }
        
        if(market != null)
        {
            getFieldMappingList();
                copyValuesToList(new List<String>(mapSourceDestination.keySet()),sourceLookupField);
            if(copySourceDestination)
                copyValuesToList(mapSourceDestination.values(),destinationLookupField);
        }
        if(additionalFields != null && additionalFields.size() > 0)
            copyValuesToList(additionalFields,EMPTY);
        if(mapQueryParamOperator != null)
            queryParamString = processParam(mapQueryParamOperator);   
        query = query.substring(0,query.length()-1);
        query = qSELECT + query + qFROM + objectToQuery;
        if(queryParamString != null && queryParamString.length() > 0)
            query = qSELECT + query + qFROM + objectToQuery + qWHERE + queryParamString;        
        return query;
    } 
    
    private String processParam(map<String,String> mapQueryParamOperator)
    {
        Integer i = 0;
        String paramString = '';
        for(String queryparam : mapQueryParamOperator.keyset())
        {
            paramString += queryParam + mapQueryParamOperator.get(queryParam) + '{' + i + '}';
            i++;
        }
        return paramString;
    }
    
    private void copyValuesToList(List<String> fieldValues, String param)
    {    
        for(String fieldVal :fieldValues){
            if(param != null && param != '')
                query += param +'.' +  fieldVal + ',';
            else
                query += fieldVal + ',';
        }           
    }        
}