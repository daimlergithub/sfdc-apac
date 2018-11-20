/* File Name   : LightningDataTableWrapper -->
<!-- Description : A Generic class used for extending functionalities like hyperlink in <Lightning:datatable> -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Abhishek Mohanty-->
<!-- Author Modification & Ver.Date : Abhishek Mohanty & 6-Sep-2018  */
global class LightningDataTableWrapper {
    
    public  String strObjectName ; //sObject name for showing data on table
    public  List<String> fieldsToDisplay; // full fields to be displayed in any modal if required
    public  List<Sobject> dataToDisplay; // data to be displayed in table
    public  List<String> buttonsToDispaly; // actions on each row of the table
    public  List<String> columnsToDisplay; // columns for the table
    
    
    public  Map<String, Schema.SObjectField> fieldMapToDisplay = new Map<String, Schema.SObjectField>();
    @AuraEnabled
    public  DataTableResponse getSobjectList(){
        DataTableResponse response = new DataTableResponse(); //The final wrapper response to return to component 
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();//To hold the table headers        
        list<ActionColumns> lstActionColumns = new List<ActionColumns>();    //To hold the actions         
        List<String> lstFieldsToQuery = new List<String>();                  //Field to be queried - fetched from fieldset      
        
        fetchFieldSchema(strObjectName,columnsToDisplay,'');
        for(String fieldName : fieldMapToDisplay.keySet()) {
            Schema.SObjectField field = fieldMapToDisplay.get( fieldName );
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            String dataType = String.valueOf(fieldDescribe.getType()).toLowerCase();
            String LinkLabel = String.valueOf(fieldDescribe.getName());
            String ColumnName = String.valueOf(fieldDescribe.getName());
            String curLabel = String.valueOf(fieldDescribe.getLabel());
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            if(dataType == 'reference'){
                ColumnName = String.valueOf(fieldDescribe.getName().replace('__c','__r'));
                dataType = 'url';
                LinkLabel = String.valueOf(fieldDescribe.getName().replace('__c','__r'))+'.Name';
            }
            if(!fieldName.contains('__r.') && String.valueOf(fieldDescribe.getLabel() )== 'Name'){
                system.debug(':P');
                dataType = 'url';
                ColumnName='Id';
            }
            if(fieldName.contains('__r.')){
                //dataType='url';
                //system.debug(':D '+fieldMapToDisplay.get( fieldName ).getDescribe());
               // system.debug('__r. '+ fieldName);
                //system.debug('curLabel:'+ curLabel);
                //system.debug('dataType:'+ dataType);
                ColumnName =fieldName;
                if( fieldDescribe.getName() == 'Name'){
                    dataType = 'url';
                	LinkLabel=fieldName;
                	ColumnName = fieldName.replace('__r.Name', '__r.Id');
                    system.debug('ColumnName :'+ColumnName);
                }
            }
            //Create a wrapper instance and store label, fieldname and type.
            TypeAttributes ta = new TypeAttributes(null,new DataTableColumns(null,LinkLabel,null,null));
            DataTableColumns datacolumns = new DataTableColumns( curLabel , 
                                                                ColumnName, 
                                                                dataType,
                                                                ta );
            lstDataColumns.add(datacolumns);            
        }
        //Populate the Actions
        if(buttonsToDispaly!=null && buttonsToDispaly.size()>0){
            for(String s:buttonsToDispaly){
                ActionColumns actionColum=new ActionColumns(s,s.replaceAll(' ','_').toLowerCase());
                lstActionColumns.add(actionColum);  
            }
            TypeAttributes rowAction=new TypeAttributes(lstActionColumns,null);
            DataTableColumns datacolumns1 = new DataTableColumns( null,null,'action',rowAction);
            lstDataColumns.add(datacolumns1);
        }     
        //Set the wrapper instance and return as response
        
        response.lstDataTableColumns = lstDataColumns;
        response.lstDataTableData = dataToDisplay;
        response.lstAllColumns=fieldsToDisplay;
        return response;
    }
    
    
    public  void fetchFieldSchema(String ObjectName,List<string> fields,String Key){
        //fetch the schema of all the fields of the object specified in 'ObjectName'
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();   
        Map<String, Schema.SObjectField> fieldMap = DescribeSObjectResultObj.fields.getMap();
        if(fields != null || fields.size()>0){             
            for(String fieldDisplay:fields){
                String fieldToDisplayLower=fieldDisplay.toLowerCase();
                 if(fieldDisplay.contains('__r')){
                    List<String> relatedObjectFields = fieldDisplay.split('__r.');
                    String RelatedObjName=relatedObjectFields[0]+'__c';
                    // Fetch the the related object's API Name
                    Schema.DescribeFieldResult f = fieldMap.get(RelatedObjName).getDescribe();
                    Schema.SObjectType reference = f.getReferenceTo().get(0); 
                    String ObjApiName= reference.getDescribe().getName();
                    relatedObjectFields.remove(0);
                    List<String> NestedFields=new List<String>{String.join(relatedObjectFields,'__r.')};
                        if(key == null || key == ''){
                            fetchFieldSchema(ObjApiName,NestedFields,fieldDisplay);
                        }
                     else{
                         fetchFieldSchema(ObjApiName,NestedFields,key);
                     } 
                }
                else if(fieldMap.containsKey(fieldToDisplayLower)){
                    if(key == null || key == ''){
                        fieldMapToDisplay.put(fieldDisplay,fieldMap.get(fieldDisplay));
                    }
                    else{
                        fieldMapToDisplay.put(Key,fieldMap.get(fieldDisplay));
                    }
                }
                
            }
        }
    }    
    //Wrapper class to hold Columns with headers
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public TypeAttributes typeAttributes {get;set;}
        
        //Create and set four variables label, fieldname, type and typeAttributes as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type, TypeAttributes typeAttributes){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;            
            this.typeAttributes=typeAttributes;
        }
    }
    
    //Wrapper class to hold Columns with headers
    public class ActionColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String name {get;set;}
        
        //Create and set two variables label, name
        public ActionColumns(String label, String name){
            this.label = label;
            this.name = name;
        }
    }
    
    //Wrapper class for row action
    public class TypeAttributes {
        @AuraEnabled       
        public List<ActionColumns> rowActions {get;set;}
        @AuraEnabled 
        public DataTableColumns label {get;set;}
        
        //Create and set variable rowActions
        public TypeAttributes(List<ActionColumns> rowActions,DataTableColumns label){
            this.rowActions = rowActions;
            this.label = label;
        }
    }
    
    //Wrapper class to hold response - This response is used in the lightning:datatable component
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}
        @AuraEnabled
        public List<String> lstAllColumns {get;set;}
        
        public DataTableResponse(){
            lstDataTableColumns = new List<DataTableColumns>();
            lstDataTableData = new List<sObject>();
            lstAllColumns = new List<String>();
        }
    }
}