/*
    Type:       Batch Class
    Purpose:    Batch Calculate smart SSI Data Cleansing Result
    User Story: smart SSI
    Used By:    smartSSIBatchRestRuleCheck
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai Created on 2014-03-18

*/
global class smartSSIBatchCalculateResult implements Database.Batchable<sObject>{
    global final String query;
    
    global smartSSIBatchCalculateResult(String q){
        //System.debug('----------calcStr---------->' + query);
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<smart_SSI__c> scope){
        List<Id> batchIds = new List<Id>();        
        for(smart_SSI__c s : scope){
            batchIds.add(s.Id);          
        }      
        smartSSIDataCleansingSnapshot.generateSnapshot(batchIds);
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}