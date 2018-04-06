/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the DM Request record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingDMRequest implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Customer_Name__r.Allow_Data_Sharing2__c, Customer_Name__r.MB_Customer_Info_Remove__c 
                                         FROM DM_Request__c where MD__c = 'JP' 
                                         and (((Customer_Name__r.Allow_Data_Sharing2__c = 'No' or Customer_Name__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Customer_Name__r.Allow_Data_Sharing2__c != 'No' and Customer_Name__r.MB_Customer_Info_Remove__c = false)and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<DM_Request__c> scope){
        system.debug('DM Request Scope :'+Scope);
        
        Map<Id, DM_Request__c> updateDMRequestMap = new  Map<Id, DM_Request__c>();
                
        for(DM_Request__c dmr : Scope){
            if(dmr.Customer_Name__r.Allow_Data_Sharing2__c == 'No' || dmr.Customer_Name__r.MB_Customer_Info_Remove__c == true){
                dmr.Allow_Data_Sharing__c = false;
            } else {
                dmr.Allow_Data_Sharing__c = true;
            }
            
            updateDMRequestMap.put(dmr.id,dmr);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateDMRequestMap.size() > 0){
            SRList = Database.update(updateDMRequestMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingDMRequest());
    }
}