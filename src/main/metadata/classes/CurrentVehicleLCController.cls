/**************************************************************************************************************************************************************************** 
* File Name     : CurrentVehicleLCController
* Description   : This Class is server side controller for CurrentVehicle cmp. to retrieve existing records as per the account selected for Opportunity.  
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************************/
public class CurrentVehicleLCController {
    
    // in case of new Opportunity creation-- recId passed is AcctID
    @AuraEnabled
    public static createWrapper retrievevehicleListInfoFromAcctID(Id accId){
        try{
        system.debug('uhikhjlo'+accId);
        createWrapper wrap = new createWrapper();
        wrap.allVehiclesMap = new Map<String, List<Lead_Details__c>>();
        wrap.oppRec =  new Opportunity();
        wrap.currentVehicleList = new List<Vehicle_Relationship__c>();
        wrap.intVehicleList = new List<Lead_Details__c>();
        wrap.compVehicleList = new List<Lead_Details__c>();
        wrap.tradeVehcList = new List<Lead_Details__c>();
        wrap.allVehicleList = new List<Lead_Details__c>();
        if (accId != null){
        wrap.currentVehicleList = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c 
                                      FROM Vehicle_Relationship__c 
                                      WHERE Contact__c= :accId];   
        }
        
	   return wrap;
      }catch(Exception e)
      {  CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
         system.debug('@@@@'+e.getMessage()+e.getStackTraceString());
         return null;
      }
    }

// in case of Opportunity detail page-- recId passed is AcctID
    @AuraEnabled
    public static createWrapper retrievevehicleListInfoFromOpptyID(Id recId){
        try{
        system.debug('uhikhjlo'+recId);
        createWrapper wrap = new createWrapper();
        wrap.allVehiclesMap = new Map<String, List<Lead_Details__c>>();
        wrap.oppRec =  new Opportunity();
        wrap.currentVehicleList = new List<Vehicle_Relationship__c>();
        wrap.intVehicleList = new List<Lead_Details__c>();
        wrap.compVehicleList = new List<Lead_Details__c>();
        wrap.tradeVehcList = new List<Lead_Details__c>();
        wrap.allVehicleList = new List<Lead_Details__c>();
        if(recId!= null)
        {
         if(String.valueof(recId).startswith('006')){
            //for Opportunity               
         wrap.oppRec = [SELECT id,Name ,RecordType.Name,StageName,Case__c,CreatedDate,Market__c,AccountId,CreatedById,LastModifiedById FROM opportunity WHERE Id =: recId];
          if(wrap.oppRec.AccountId != null)
            {
              wrap.currentVehicleList = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c FROM Vehicle_Relationship__c WHERE Contact__c= :wrap.oppRec.AccountId];       
            }
          }
          else if(String.valueof(recId).startswith('500')){
            //for case Obj
            system.debug('inside case query'+recId);
            Case c= new Case();
            c= [SELECT id,CreatedDate,Market__c,AccountId FROM Case WHERE Id =: recId];
            if(c.AccountId != null)
            {
              wrap.currentVehicleList = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c FROM Vehicle_Relationship__c WHERE Contact__c= :c.AccountId];       
            }
          }   
        }
       return wrap;
      }catch(Exception e)
      {  CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
         system.debug('@@@@'+e.getMessage()+e.getStackTraceString());
         return null;
      }
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
    }   
    
    
}