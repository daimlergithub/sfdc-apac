global class BatchShareRetailCampaigns implements Database.Batchable<sObject> {
	
	global BatchShareRetailCampaigns() {
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('select Id from Retail_Campaign__c');
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
		SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(scope));
	}
	
	global void finish(Database.BatchableContext BC) {
	}
	
}