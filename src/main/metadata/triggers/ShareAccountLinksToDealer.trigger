trigger ShareAccountLinksToDealer on Account_Link__c (after insert, after update) 
{
    TriggerUtil.handleTrigger('ShareAccountLinksToDealer');
}