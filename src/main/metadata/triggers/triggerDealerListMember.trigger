trigger triggerDealerListMember on Dealer_List_Member__c (before insert, before update, after update,after insert) {
TriggerUtil.handleTrigger('triggerDealerListMember');
}