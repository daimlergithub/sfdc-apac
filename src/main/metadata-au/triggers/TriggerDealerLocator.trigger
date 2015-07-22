trigger TriggerDealerLocator on Dealer_Locator__c (after insert,after update, after delete) {
	
    TriggerUtil.handleTrigger('TriggerDealerLocator');      
}