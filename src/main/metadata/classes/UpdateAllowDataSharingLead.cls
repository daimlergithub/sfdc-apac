/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Lead record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingLead implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.MB_Customer_Info_Remove__c 
                                         FROM Lead__c where MD__c = 'JP' 
                                         and (((Contact__r.Allow_Data_Sharing2__c = 'No' or Contact__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Contact__r.Allow_Data_Sharing2__c != 'No' and Contact__r.MB_Customer_Info_Remove__c = false) and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        
        Map<Id, Lead__c> updateLeadMap = new  Map<Id, Lead__c>();
                
        for(Lead__c ld : Scope){
            if(ld.Contact__r.Allow_Data_Sharing2__c == 'No' || ld.Contact__r.MB_Customer_Info_Remove__c == true){
                ld.Allow_Data_Sharing__c = false;
            } else {
                ld.Allow_Data_Sharing__c = true;
            }
            
            updateLeadMap.put(ld.id,ld);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateLeadMap.size() > 0){
            SRList = Database.update(updateLeadMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingLead());
    }
}