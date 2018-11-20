/*
Created By: Dheeraj
Created Date: 31/10/2018
Description: This method is used to reparent Notes and Attachments. This code copied from the class batchReparentRecords.
*/
global class batchReparentRecordsForJP implements Database.Batchable<sObject> {
  
    //fetching the records for merging operation.
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query='SELECT Id,Duplicate_Customer__c,Master_Customer__c,status__c FROM Duplicate_Merge_Info__c WHERE MD__c=\'JP\' AND Duplicate_Customer__c!=null AND Master_Customer__c!=null AND Status__c!=\'Processed\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Duplicate_Merge_Info__c> dupMergeInfoList){
        Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap=new Map<Id,Id>();
        List<Duplicate_Merge_Info__c> dupMergeInfoTobeUpdated=new List<Duplicate_Merge_Info__c>();
        
        //iterating the dup merge info records and setting the status to processed.
        for(Duplicate_Merge_Info__c dupMergeObj:dupMergeInfoList){
            duplicateCustmrId2MasterCustmerIdMap.put(dupMergeObj.Duplicate_Customer__c, dupMergeObj.Master_Customer__c);
            dupMergeObj.Status__c='Processed';
            dupMergeInfoTobeUpdated.add(dupMergeObj);
        }
        
        //calling the method for merging operating.
        sObjectMerge.mergeNotesAndAttachment(duplicateCustmrId2MasterCustmerIdMap);
        
        //update the status of duplicate merge info to processed
        if(dupMergeInfoTobeUpdated != null && dupMergeInfoTobeUpdated.Size()>0){
            update dupMergeInfoTobeUpdated;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}
