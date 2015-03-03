/*
    Type:       Batch Class
    Purpose:    Batch Update Records To Prevent 101 Query Limit. 
    User Story: All Batch Record Update Opertion.
    Used By:    TriggerCampaign
    ---------------------------------------------------------------
    History:
    
    1. Chris.Huang (Breakingpoint) Created on 2013-11-17

*/
global class BatchUpdateRecords implements Database.Batchable<sObject>{
    global final String query;
    global final Map<String, String> updateFieldsMap;
    
    global BatchUpdateRecords(String q, Map<String, String> updateMap){
        query = q;
        updateFieldsMap = updateMap;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject s : scope){
            for (String key : updateFieldsMap.keySet()) {
                s.put(key, updateFieldsMap.get(key)); 
            }            
        }      
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}