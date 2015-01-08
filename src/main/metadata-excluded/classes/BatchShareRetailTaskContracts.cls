global class BatchShareRetailTaskContracts implements Database.Batchable<sObject> {
	
	global BatchShareRetailTaskContracts() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Id contractTypeId = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1].Id;
        
		String query = 'select Id, RecordTypeId, Related_Contact__c, Related_Dealer__c, Related_Dealer__r.Dealer_DMS_CRM_Code__c, Related_Vehicle__c from Retail_Task__c where RecordTypeId = :contractTypeId';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
        SharingService.shareRetailTasks(wrapService.wrapContracts((List<Retail_Task__c>)scope));
	}
	
	global void finish(Database.BatchableContext BC) {}
	
}