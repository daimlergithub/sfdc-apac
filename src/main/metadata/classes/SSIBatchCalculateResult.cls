/*
    Type:       Batch Class
    Purpose:    Batch Calculate SSI Data Cleansing Result
    User Story: US-SSI-004.
    Used By:    SSIBatchRestRuleCheck
    ---------------------------------------------------------------
    History:
    
    1. Chris.Huang (Breakingpoint) Created on 2013-12-30

*/
global class SSIBatchCalculateResult implements Database.Batchable<sObject>{
    global final String query;
    
    global SSIBatchCalculateResult(String q){
        //System.debug('----------calcStr---------->' + query);
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SSI__c> scope){
        List<Id> batchIds = new List<Id>();        
        for(SSI__c s : scope){
            batchIds.add(s.Id);          
        }      
        SSIDataCleansingSnapshot.generateSnapshot(batchIds);
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}