/*
    Type:       Batch Class
    Purpose:    Batch Update Task Status To 'Sent' To Prevent 50001 Query Rows Limit. 
    User Story: 
    Used By:    TriggerCampaign
    ---------------------------------------------------------------
    History:
    
    1. Chris.Huang (Breakingpoint) Created on 2013-11-26

*/
global class BatchUpdateCampaignLeadTask implements Database.Batchable<sObject>{
    global final String query;
    
    global BatchUpdateCampaignLeadTask (String q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Lead__c> scope){
        Id tkRecTpId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
        List<Task> taskSMS = [SELECT Id, Status, Activity_Status__c FROM Task WHERE WhatId in :scope AND RecordTypeId= :tkRecTpId AND Activity_Status__c='Need Verification'];
        for(Task tk : taskSMS){
            tk.Status = 'Closed';
            tk.Activity_Status__c = 'Sent';
        }
        update taskSMS;
    }
    
    global void finish(Database.BatchableContext BC){
    
    }

}