/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Vehicle Relationship record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingVR implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.MB_Customer_Info_Remove__c 
                                         FROM Vehicle_Relationship__c where MD__c = 'JP' 
                                         and (((Contact__r.Allow_Data_Sharing2__c = 'No' or Contact__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Contact__r.Allow_Data_Sharing2__c != 'No' and Contact__r.MB_Customer_Info_Remove__c = false) and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Vehicle_Relationship__c> scope){
        system.debug('Vehicle Relationship Scope :'+Scope);
        
        Map<Id, Vehicle_Relationship__c> updateVehicleRelationshipMap = new  Map<Id, Vehicle_Relationship__c>();
                
        for(Vehicle_Relationship__c vr : Scope){
            if(vr.Contact__r.Allow_Data_Sharing2__c == 'No' || vr.Contact__r.MB_Customer_Info_Remove__c == true){
                vr.Allow_Data_Sharing__c = false;
            } else {
                vr.Allow_Data_Sharing__c = true;
            }
            
            updateVehicleRelationshipMap.put(vr.id,vr);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateVehicleRelationshipMap.size() > 0){
            SRList = Database.update(updateVehicleRelationshipMap.values(), false);
        }
        
        for (Database.SaveResult sr : SRList) {
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred:' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
    } 
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
   
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new UpdateAllowDataSharingVR());
    }
}