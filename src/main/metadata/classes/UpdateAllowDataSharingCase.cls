/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the Case record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingCase implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Account.Allow_Data_Sharing2__c, Account.MB_Customer_Info_Remove__c 
                                         FROM Case where MD__c = 'JP' 
                                         and (((Account.Allow_Data_Sharing2__c = 'No' or Account.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Account.Allow_Data_Sharing2__c != 'No' and Account.MB_Customer_Info_Remove__c = false) and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Case> scope){
        system.debug('Case Scope :'+Scope);
        
        Map<Id, Case> updateCaseMap = new  Map<Id, Case>();
                
        for(Case cs : Scope){
            if(cs.Account.Allow_Data_Sharing2__c == 'No' || cs.Account.MB_Customer_Info_Remove__c == true){
                cs.Allow_Data_Sharing__c = false;
            } else {
                cs.Allow_Data_Sharing__c = true;
            }
            
            updateCaseMap.put(cs.id,cs);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateCaseMap.size() > 0){
            SRList = Database.update(updateCaseMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingCase());
    }
}