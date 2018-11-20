/**************************************************************************************************************************************************************************** 
* File Name     : CompetitorVehicleLCController
* Description   : This Class is server side controller for CompetitorVehicle cmp. to retrieve existing records and save newly created.  
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************************/ 
public class CompetitorVehicleLCController {
    

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
        for(Lead_Details__c ld : [Select Id, recordTypeId, Car_Model_Competitor__c, Car_Model_Competitor__r.Name, Brand__c,Brand_Picklist__c,Car_Model__c, Car_Model__r.name, Class__c,Class_Picklist__c, Color__c, Market__c, Mileage__c, Preferred__c, Related_Lead__c, Trade_In_Vehicle__c, Trim__c, Type__c, Vehicle_Model_Type__c, Year_of_Manufacture__c From Lead_Details__c Where Related_Lead__c =: recId or Related_Case__c  = :recId]){
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
            //wrap.intVehicleList.addAll(new list<Lead_Details__c>(wrap.allVehiclesMap.get(System.Label.Lead_Detail_Interested_Record_Type)));
            wrap.compVehicleList.addAll(new list<Lead_Details__c>(wrap.allVehiclesMap.get(System.Label.Lead_Detail_Competitor_Record_Type)));
        }
        //system.debug('<<wrap'+wrap);
        return wrap;
      }catch(Exception e)
      {  CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
         return null;
      }
    }
    
	// Add interested vehicle records
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
                ld[0].Car_Model_Competitor__c=carModelId;
                //ld[0].Car_Model__r.name=cmodelList[0].name;
                //sending Car Model name appending with Trim__c 
                ld[0].Brand__c =cmodelList[0].brand__C;
                ld[0].Class__c = cmodelList[0].series__c;
                ld[0].Color__c = cmodelList[0].Colour__c; 
                ld[0].Trim__c = cmodelList[0].Trim__c+'||'+cmodelList[0].name;
                ld[0].Brand_Picklist__c = cmodelList[0].Brand__c;
                ld[0].Class_Picklist__c = cmodelList[0].Series__c; 
            }
            //System.debug('----dg0----'+ld[0]);
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
    public static List<Lead_Details__c> addCompRecord(List<Lead_Details__c> compVehicleList, Id recId) {
        Lead_Details__c led = new Lead_Details__c();
        led.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
        led.Related_Lead__c = recId;
        compVehicleList.add(led);
        return compVehicleList;
    }
  */
    @AuraEnabled
    public static responseWrap savecompVehicles(String compVehicle , Id recid, Integer preferredindex) {
         //remove string after '||' from trim__c before saving Lead_Detail__c
        System.debug('<<came to COmp vehicles '+compVehicle+'<<Recid'+recid+'<<preferredindex'+preferredindex);
        String response;
        User uu = [Select Market__c, id from User where id=:userinfo.getuserid()];
        responseWrap wrap = new responseWrap();
        wrap.vehicleList = new List<Lead_Details__c>();
        List<Lead_Details__c> compVehicleList = (List<Lead_Details__c>)JSON.deserialize(compVehicle, List<Lead_Details__c>.class);
        List<Lead_Details__c> finalAllVehicleList = new List<Lead_Details__c>();
        try{
			system.debug('inside CV save'+compVehicleList);            
           	if(!(compVehicleList.isEmpty()) && preferredindex!=null){
                for(Integer i=0; i<compVehicleList.size(); i++){
                     //remove string after '||' from trim__c before saving Lead_Detail__c
                    String s=compVehicleList[i].trim__c;
                    if(s!= null && s.contains('||'))
                    {
                    compVehicleList[i].trim__c= s.substringBefore('||');
                    }
                   if(compVehicleList[i].Preferred__c == true){
                        compVehicleList[i].Preferred__c = false;
                    }
                }
                
                compVehicleList[Integer.valueof(preferredindex)].Preferred__c = true;
            }
            for(Lead_Details__c ledDet : compVehicleList){
                system.debug('Test'+ledDet.Car_Model_Competitor__c);
                if(!(ledDet.Car_Model_Competitor__c == null)){
                    ledDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                     if(String.valueof(recid).startswith('500'))
                    {
                    ledDet.Related_Case__c = recid;
                    ledDet.Related_Lead__c = null;    
                    }else if(String.valueof(recid).startswith('006')){
                    ledDet.Related_Lead__c = recid;
                    ledDet.Related_Case__c = null;
                    }
                    //ledDet.Related_Lead__c = recid;
                    ledDet.Market__c = uu.Market__c;
                    finalAllVehicleList.add(ledDet);
                }
            }
            if(!finalAllVehicleList.isEmpty()){
                system.debug('Before saving CV!!!'+finalAllVehicleList);
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
     

}