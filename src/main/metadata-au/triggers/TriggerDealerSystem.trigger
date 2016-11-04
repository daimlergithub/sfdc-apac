trigger TriggerDealerSystem on Dealer_System__c (after insert,after update, after delete,before insert,before update) 
{
	TriggerUtil.handleTrigger('TriggerDealerSystem');
}