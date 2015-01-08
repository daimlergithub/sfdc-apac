global class BatchShareAccountLinks implements Database.Batchable<sObject> {
	
	global BatchShareAccountLinks() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('select Id, RecordTypeId, Vehicle__c, Name , toRole__c ,fromRole__c from account_link__c');
	}

   	global void execute(Database.BatchableContext BC, List<sObject> accountLinks) {
		VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(accountLinks));
        
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        SharingService.shareAccountLinks(wrapService.wrapAccountLinksByRecordTypes(accountLinks));
        
        /** add by bing */
        AccountSharingDataBatchHandler accountShare = new AccountSharingDataBatchHandler('');
        accountShare.accountLinkShareProcess(accountLinks);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}