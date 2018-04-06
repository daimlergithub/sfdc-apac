/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    09.14.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to update Allow_Data_Sharing__c field of the SurveyTaker record 
                         when parent Account record's Allow_Data_Sharing__c field is updated.
                          * This will execute once every night as batch.
JIRA NO             :    JP-1612                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class UpdateAllowDataSharingSurveyTaker implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Allow_Data_Sharing__c, Account__r.Allow_Data_Sharing2__c, Account__r.MB_Customer_Info_Remove__c 
                                         FROM SurveyTaker__c where MD__c = 'JP' 
                                         and (((Account__r.Allow_Data_Sharing2__c = 'No' or Account__r.MB_Customer_Info_Remove__c = true) and Allow_Data_Sharing__c = true) 
                                         or ((Account__r.Allow_Data_Sharing2__c != 'No' and Account__r.MB_Customer_Info_Remove__c = false) and Allow_Data_Sharing__c = false))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<SurveyTaker__c> scope){
        system.debug('SurveyTaker Scope :'+Scope);
        
        Map<Id, SurveyTaker__c> updateSurveyTakerMap = new  Map<Id, SurveyTaker__c>();
                
        for(SurveyTaker__c st : Scope){
            if(st.Account__r.Allow_Data_Sharing2__c == 'No' || st.Account__r.MB_Customer_Info_Remove__c == true){
                st.Allow_Data_Sharing__c = false;
            } else {
                st.Allow_Data_Sharing__c = true;
            }
            
            updateSurveyTakerMap.put(st.id,st);
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();

        if(updateSurveyTakerMap.size() > 0){
            SRList = Database.update(updateSurveyTakerMap.values(), false);
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
        Database.executeBatch(new UpdateAllowDataSharingSurveyTaker());
    }
}