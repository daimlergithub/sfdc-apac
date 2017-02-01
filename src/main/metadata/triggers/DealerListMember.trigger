trigger DealerListMember on Dealer_List_Member__c(after insert,after update,before insert,before update,after delete) 
{
    TriggerUtil.handleTrigger('DealerListMember');
}