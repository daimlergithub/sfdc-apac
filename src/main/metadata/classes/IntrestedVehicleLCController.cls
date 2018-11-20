/**************************************************************************************************************************************************************************** 
* File Name     : IntrestedVehicleLCController
* Description   : This Class is server side controller for InterestedVehicle cmp. to retrieve existing records and save newly created.  
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************************/ 
public class IntrestedVehicleLCController{
    @AuraEnabled
    public static createWrapper retrievevehicleListInfo(Id recId){
        try{
        createWrapper wrap = new createWrapper();
        wrap.allVehiclesMap = new Map<String, List<Lead_Details__c>>();
        wrap.oppRec =  new Opportunity();
        wrap.currentVehicleList = new List<Vehicle_Relationship__c>();
        wrap.intVehicleList = new List<Lead_Details__c>();
        wrap.compVehicleList = new List<Lead_Details__c>();
        wrap.tradeVehcList = new List<Lead_Details__c>();
        wrap.allVehicleList = new List<Lead_Details__c>();
        //wrap.oppRec = [SELECT id,Name ,RecordType.Name,StageName,Case__c,CreatedDate,Market__c,AccountId,CreatedById,LastModifiedById FROM opportunity WHERE Id =: recId];
        for(Lead_Details__c ld : [Select Id, recordTypeId, Car_Model_Competitor__c, Car_Model_Competitor__r.name, Brand__c,Brand_Picklist__c,Car_Model__c, Car_Model__r.name, Class__c,Class_Picklist__c, Color__c, Market__c, Mileage__c, Preferred__c, Related_Lead__c, Trade_In_Vehicle__c, Trim__c, Type__c, Vehicle_Model_Type__c, Year_of_Manufacture__c From Lead_Details__c Where Related_Lead__c = :recId or Related_Case__c  = :recId]){
            // Add vehicles separately
            String leadDetailRecordTypeName = UtilRecordType.getRecordTypeNameById('Lead_Details__c', ld.RecordTypeId);
            if(!wrap.allVehiclesMap.isEmpty() && wrap.allVehiclesMap.containsKey(leadDetailRecordTypeName)){
                List<Lead_Details__c> tempLdList = wrap.allVehiclesMap.get(leadDetailRecordTypeName);
                tempLdList.add(ld);
                wrap.allVehicleList.add(ld);
                wrap.allVehiclesMap.put(leadDetailRecordTypeName, tempLdList);
            }
            else{
                wrap.allVehicleList.add(ld);
                wrap.allVehiclesMap.put(leadDetailRecordTypeName, new List<Lead_Details__c>{ld});
            }
        }
		// Populate vehicles on edit page
        if(!wrap.allVehiclesMap.isEmpty()){
            wrap.intVehicleList.addAll(new list<Lead_Details__c>(wrap.allVehiclesMap.get(System.Label.Lead_Detail_Interested_Record_Type)));
            //wrap.compVehicleList.addAll(new list<Lead_Details__c>(wrap.allVehiclesMap.get(System.Label.Lead_Detail_Competitor_Record_Type)));
        }
        system.debug('<<wrapHK'+wrap);
        return wrap;
      }catch(Exception e)
      {  system.debug('@@@'+e.getMessage()+e.getStackTraceString());
         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
         return null;
      }
    }
  /*
	// Add interested vehicle records
	@AuraEnabled
    public static List<Lead_Details__c> addIntRecord(List<Lead_Details__c> intVehicleList, Id recId) {
        Lead_Details__c led = new Lead_Details__c();
        led.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
        led.Related_Lead__c = recId;
        insert led;
        intVehicleList.add(led);
        return intVehicleList;
    }
    
    @AuraEnabled 
    public static list<Lead_Details__c> addIntRecordSec(String intVehicleList, Id recId){
        system.debug('<<intVehicleList'+intVehicleList);
        List<Lead_Details__c> cmlist = (List<Lead_Details__c>)JSON.deserialize(intVehicleList, List<Lead_Details__c>.class);
        Lead_Details__c led = new Lead_Details__c();
        led.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
        led.Related_Lead__c = recId;
        insert led;
        cmlist.add(led);
        return cmlist;
    }
   */
    @AuraEnabled 
    public static Lead_Details__c cardmodelParametersSC(Id carModelId,String intVehicle){
        try{
        System.debug('----carModelId----'+carModelId+'----intVehicle---'+intVehicle);
        List<Lead_Details__c> ld = (List<Lead_Details__c>)JSON.deserialize(intVehicle, List<Lead_Details__c>.class);
        List<Car_Model__c> cmodelList = new  List<Car_Model__c>();
        if(carModelId!=null){
            cmodelList = [SELECT id,name, brand__C,series__c,Colour__c,Trim__c
                          FROM Car_Model__c 
                          WHERE id=:carModelId];
            if(!cmodelList.isEmpty()){
                ld[0].Car_Model__c=carModelId;
                //ld[0].Car_Model__r.Name=cmodelList[0].name;
                //sending Car Model name appending with Trim__c 
                ld[0].Brand__c =cmodelList[0].brand__C;
                ld[0].Class__c = cmodelList[0].series__c;
                ld[0].Color__c = cmodelList[0].Colour__c; 
                ld[0].Trim__c = cmodelList[0].Trim__c+'||'+cmodelList[0].name;
                ld[0].Brand_Picklist__c = cmodelList[0].Brand__c;
                ld[0].Class_Picklist__c = cmodelList[0].Series__c; 
            }
            return ld[0];
          }
          return null;   
        }catch(Exception e){
          system.debug('$$$'+e.getMessage()+e.getStackTraceString());  
          CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());  
          return null;    
        }     
    }
       
   /* @AuraEnabled
    public static Boolean checkIntVehiclePreferred(List<Lead_Details__c> intVehicleList) {
        try{
        Integer intPreferredCount = 0;
        for(Lead_Details__c ld : intVehicleList){
            if(ld.Preferred__c)
                intPreferredCount++;
        }
        if(intPreferredCount > 1){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.label.IN_Interested_Preferred_vehicle));
            return true;
        }
        return false;
       }catch(Exception e)
       { 
         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());  
         return null;
       }
    }
  */    
    @AuraEnabled
    public static responseWrap saveIntVehicles(String intVehicle , Id recid, Integer preferredindex) {
       
        System.debug('<<came to int vehicles '+intVehicle+'<<Recid'+recid+'<<preferredindex'+preferredindex);
        String response;
        User uu = [Select Market__c, id from User where id=:userinfo.getuserid()];
        responseWrap wrap = new responseWrap();
        wrap.vehicleList = new List<Lead_Details__c>();
        List<Lead_Details__c> intVehicleList = (List<Lead_Details__c>)JSON.deserialize(intVehicle, List<Lead_Details__c>.class);
        List<Lead_Details__c> finalAllVehicleList = new List<Lead_Details__c>();
        try{
            
           	if(!(intVehicleList.isEmpty()) && preferredindex!=null){
                for(Integer i=0; i<intVehicleList.size(); i++){
                     //remove string after '||' from trim__c before saving Lead_Detail__c
                    String s=intVehicleList[i].trim__c;
                    if(s!= null && s.contains('||'))
                    {
                    intVehicleList[i].trim__c= s.substringBefore('||');
                    }
                    if(intVehicleList[i].Preferred__c == true){
                        intVehicleList[i].Preferred__c = false;
                    }
                }
                
                intVehicleList[Integer.valueof(preferredindex)].Preferred__c = true;
            }
            for(Lead_Details__c ledDet : intVehicleList){
                if(!(ledDet.Car_Model__c == null)){
                    ledDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                    if(String.valueof(recid).startswith('500'))
                    {
                    ledDet.Related_Case__c = recid;
                    ledDet.Related_Lead__c = null;    
                    }else if(String.valueof(recid).startswith('006')){
                    ledDet.Related_Lead__c = recid;
                    ledDet.Related_Case__c = null;
                    }
                    ledDet.Market__c = uu.Market__c;
                    finalAllVehicleList.add(ledDet);
                }
            }
            if(!finalAllVehicleList.isEmpty()){
                system.debug('befor upsert !!'+finalAllVehicleList);
                upsert finalAllVehicleList;
                wrap.response = 'Success';
                wrap.vehicleList = finalAllVehicleList;
                return wrap ;
            }
        }Catch(DMLException e){
            wrap.response = e.getdmlMessage(0);
            wrap.vehicleList = finalAllVehicleList;
        	return wrap;   
        }
        return wrap;
    }
    
    public class createWrapper{
    	@AuraEnabled public List<Lead_Details__c> allVehicleList{get;set;}
        @AuraEnabled public List<Lead_Details__c> intVehicleList{get;set;}
        @AuraEnabled public List<Lead_Details__c> compVehicleList{get;set;}
        @AuraEnabled public List<Lead_Details__c> tradeVehcList{get;set;}
        @AuraEnabled public Map<String, List<Lead_Details__c>> allVehiclesMap{get;set;}
        @AuraEnabled public Opportunity oppRec{get;set;}
        @AuraEnabled public List<Vehicle_Relationship__c> currentVehicleList {get;set;}
    }
    
    public class responseWrap{
    	@AuraEnabled public List<Lead_Details__c> vehicleList{get;set;}
        @AuraEnabled public String response{get;set;}
        //UtilFactoryDefaultNS
    }   
    
/*
 * Commented below code, which further can be used to fetch DataTable Columns using Custom Metadata & Factory Model
 * 
    @AuraEnabled
    public static List<DataTableColumns> createDataColumn(List<String> ApiList)
    {
         List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
         Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get('Lead_Details__c');
         Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();   
		 Map<String, Schema.SObjectField> fieldMap = DescribeSObjectResultObj.fields.getMap();
         Map<String, Schema.SObjectField> fieldMapToDisplay = new Map<String, Schema.SObjectField>();
         for(String fieldDisplay:ApiList){
            String fieldToDisplayLower=fieldDisplay.toLowerCase();
            if(fieldMap.containsKey(fieldToDisplayLower)){
                fieldMapToDisplay.put(fieldDisplay,fieldMap.get(fieldDisplay));
            }
        }
        for(String fieldName : fieldMapToDisplay.keySet()) {
            Schema.SObjectField field = fieldMapToDisplay.get( fieldName );
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            String dataType = String.valueOf(fieldDescribe.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            else if(dataType== 'string')
            {
                dataType = 'text';
            }
            else if(dataType== 'reference')
            {
                dataType = 'text';
            }
            //Create a wrapper instance and store label, fieldname and type.
            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(fieldDescribe.getLabel()) , 
                                                                String.valueOf(fieldDescribe.getName()), 
                                                                dataType);
			lstDataColumns.add(datacolumns);
        }
        return lstDataColumns; 
    } 
    //retrieve List<String> for DataTableColumn
    @AuraEnabled
    public static Object getDataTableColumns()
    {
        try{
        List<DataTableColumns> InterVehColumns = new List<DataTableColumns>();
        List<String> CompVehColumns = new List<String>();    
        Map<String, List<String>> FSMap= new Map<String, List<String>>();
        User u= [Select market__c from user where id = : userInfo.getUserId()];
        String market= u.market__c;
        //fetch field sets
        String recordTypeName = '';
        VehicleInfo VI = VehicleInfoFactory.fetchInstance('Opportunity',null,null,'InterestedVehicle');	
        FSMap=VI.getFields('InterestedVehicle');
        system.debug('!!!!!Map from factory & metadata'+FSMap);    
        InterVehColumns =  createDataColumn(FSMap.get('OutputFields'));
        system.debug('DataTable Columns!!!'+InterVehColumns);    
        return null;
     }catch(Exception e)
     {    system.debug('Error!!'+e.getMessage()+e.getStackTraceString());   
          CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
          return null;
     }
   }
   
    //Wrapper class to hold Columns with headers of DataTable
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;            
        }
    }
*/    

}