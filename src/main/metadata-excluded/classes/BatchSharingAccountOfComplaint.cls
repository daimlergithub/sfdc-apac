/**
 *  For release 1.2 
 *  Part: Data sharing V1.0
 *  Function: Line 1
 *  Description in doc:
 *       Run batch class to extend apex sharing in release 1.0 to share person account to 
 *       active Complaint gate keeper of the active dealers with the same CRM Code as the assigned dealer 
 *       at lead assignment. (dealer lead/complaint gate keeper is based on the flag on dealer contact)
 */

global class BatchSharingAccountOfComplaint implements Database.Batchable<sObject> {

    String query = 'select Id, Dealer_DMS_CRM_Code__c from Account ' +
                    'where RecordType.Name = \'Dealer\' '+ 
                    'and Dealer_DMS_CRM_Code__c != null '+  
                    'and Dealer_DMS_CRM_Code__c != \'\' '+  
                    'and Dealer_Active__c = true ' ;

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public BatchSharingAccountOfComplaint(){

    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        AccountSharingDataBatchHandler  process1 = new AccountSharingDataBatchHandler ('Complaint');
        process1.executeProcessByCRMCode(scope);
    }

    public void finish(Database.BatchableContext BC){
    }

}