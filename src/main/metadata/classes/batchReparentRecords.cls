global class batchReparentRecords implements Database.Batchable<sObject> {
	
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='select Id,Duplicate_Customer__c,Master_Customer__c,status__c from Duplicate_Merge_Info__c where MD__c=\'TH\' and Duplicate_Customer__c!=null and Master_Customer__c!=null and Status__c!=\'Processed\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Duplicate_Merge_Info__c> scope)
    {
        Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap=new Map<Id,Id>();
        List<Duplicate_Merge_Info__c> dupMergeInfoTobeUpdated=new List<Duplicate_Merge_Info__c>();
        for(Duplicate_Merge_Info__c dupMergeObj:scope)
        {
            duplicateCustmrId2MasterCustmerIdMap.put(dupMergeObj.Duplicate_Customer__c, dupMergeObj.Master_Customer__c);
            dupMergeObj.Status__c='Processed';
            dupMergeInfoTobeUpdated.add(dupMergeObj);
        }
        //merge vehicle relationships record from duplicate account to golden account
        //sObjectMerge.mergeVR(duplicateCustmrId2MasterCustmerIdMap);
        sObjectMerge.mergeOpenActivities(duplicateCustmrId2MasterCustmerIdMap);
        sObjectMerge.mergeNotesAndAttachment(duplicateCustmrId2MasterCustmerIdMap);
        
        //update the status of duplicate merge info to processed
        if(dupMergeInfoTobeUpdated!=null && dupMergeInfoTobeUpdated.size()>0)
            update dupMergeInfoTobeUpdated;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}