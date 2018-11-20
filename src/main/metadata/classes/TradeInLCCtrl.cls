/**************************************************************************************************************************************************************************** 
* File Name     : TradeInLCCtrl
* Description   : This Class is server side controller for TradeInVehicle cmp. to retrieve existing records and save newly created.  
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************************/
public class TradeInLCCtrl {
    //
    @AuraEnabled
    public static ID getRecordTypeID(){
    try{
          return  UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type);     
          }catch(Exception e){
          CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());    
          return null;  
         }
      }

    @AuraEnabled
    public static list<Lead_Details__c> getTradeInVehicleList(id recordId){ 
        list<Lead_Details__c> tradeVehc=new list<Lead_Details__c>();
        if(String.valueof(recordId).startswith('006')){
            //for Opportunity            
            tradeVehc =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c,brand_picklist__c,class_picklist__c from Lead_Details__c where Related_Lead__c=:recordId];
          }
        else if(String.valueof(recordId).startswith('500')){
            //for case Obj
            tradeVehc =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c from Lead_Details__c where Related_Case__c=:recordId and RecordType.DeveloperName='Trade_In'];
     }
        return tradeVehc;        
    }
    
    @AuraEnabled
    public static void saveTradeInList(String leadList,String RelatedOpptyId){
    try{
            system.debug('!!!!!!!'+leadList+RelatedOpptyId);
            Id RTID= UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type);
            List<Lead_Details__c> compVehicleList = (List<Lead_Details__c>)JSON.deserialize(leadList, List<Lead_Details__c>.class);
            for(Lead_Details__c l :compVehicleList)
            {
                if(String.valueof(RelatedOpptyId).startswith('006')){ l.Related_Lead__c=RelatedOpptyId; l.Related_Case__c=null;}
                else if(String.valueof(RelatedOpptyId).startswith('500')) { l.Related_Case__c=RelatedOpptyId; l.Related_Lead__c=null; }
                l.RecordTypeId=RTID;   
            }
           database.upsert(compVehicleList);
        }catch(Exception e){
            system.debug('Error in tradeIn'+e.getMessage()+e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured' + e +'-- '+e.getMessage());
        }
    }
}