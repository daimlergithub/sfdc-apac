trigger AccountLinkAfter on Account_Link__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('AccountLinkAfter')) {
        return;
    }
    
    //------------------Added by bing---------------------    
    AccountSharingDataHandler handler = new AccountSharingDataHandler('Account_Link__c');
    handler.shareAccountByAccountLink(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    //------------------Added by bing---------------------    
    
}