/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Retail Task record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/

global class UpdateAllowDataSharingRetailTask implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Account__r.Allow_Data_Sharing2__c, Account__r.MB_Customer_Info_Remove__c, Related_Contact__r.Allow_Data_Sharing2__c, Related_Contact__r.MB_Customer_Info_Remove__c 
                                         FROM Retail_Task__c where MD__c = 'JP' 
                                         and (((Account__r.Allow_Data_Sharing2__c = 'No' or Account__r.MB_Customer_Info_Remove__c = true or 
                                               Related_Contact__r.Allow_Data_Sharing2__c = 'No' or Related_Contact__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Account__r.Allow_Data_Sharing2__c != 'No' and Account__r.MB_Customer_Info_Remove__c != true and 
                                             Related_Contact__r.Allow_Data_Sharing2__c != 'No' and Related_Contact__r.MB_Customer_Info_Remove__c != true) and Allow_Data_Sharing__c = false))]);
    }
    
    
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Retail_Task__c> scope){
        system.debug('Retail Task Scope :'+Scope);
        
        Map<Id, Retail_Task__c> updateRetailTaskMap = new  Map<Id, Retail_Task__c>();
                
        for(Retail_Task__c rt : Scope){
            if(rt.Account__r.Allow_Data_Sharing2__c == 'No' || rt.Account__r.MB_Customer_Info_Remove__c == true || rt.Related_Contact__r.Allow_Data_Sharing2__c == 'No' || rt.Related_Contact__r.MB_Customer_Info_Remove__c == true){
                rt.Allow_Data_Sharing__c = false;
            } else {
                rt.Allow_Data_Sharing__c = true;
            }
            
            updateRetailTaskMap.put(rt.id,rt);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateRetailTaskMap.size() > 0){
            SRList = Database.update(updateRetailTaskMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingRetailTask());
    }
    
    
}