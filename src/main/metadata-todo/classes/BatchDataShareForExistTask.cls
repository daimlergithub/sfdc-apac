/*
    Type:       Batch Class
    Purpose:    Set IsVisibleInSelfService = True of closed task for defined record types. 
    User Story: Data Sharing V1.0
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-06-12
*/
global class BatchDataShareForExistTask implements Database.Batchable<sObject>{
    global final String query;
    
    global BatchDataShareForExistTask (){
        String recordTypes = '\'DM\',\'IB Call\',\'MMS\',\'OB Call\',\'SMS\',\'eDM\',\'Social Media\'';
        query = 'select Id, IsVisibleInSelfService from Task where IsVisibleInSelfService = false and Status = \'Closed\' and RecordType.Name In (' + recordTypes + ')';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject s : scope){
            s.put('IsVisibleInSelfService', true);
        }      
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){}
}