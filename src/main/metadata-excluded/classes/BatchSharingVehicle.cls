/**
 *  For release 1.2 
 *  Part: Data sharing V1.0
 *  Function: Line 7
 *  Description in doc:
 *       Run batch class to extend apex sharing in release 1.0 to 
 *       share vehicle to active users of active dealers with the same CRM Code 
 *       as the owner dealer of retail vehicle relationship.
 */

global class BatchSharingVehicle implements Database.Batchable<sObject> {

    String query = 'select Id, Dealer_DMS_CRM_Code__c from Account ' +
                    'where RecordType.Name = \'Dealer\' '+ 
                    'and Dealer_DMS_CRM_Code__c != null '+  
                    'and Dealer_DMS_CRM_Code__c != \'\' '+  
                    'and Dealer_Active__c = true ' ;

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public BatchSharingVehicle(){

    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        VehicleDataSharingHandler process1 = new VehicleDataSharingHandler();
        process1.executeProcessByCRMCode(scope);
    }

    public void finish(Database.BatchableContext BC){
    }

}