trigger AccountAfterInsertOrUpdate on Account (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('AccountAfterInsertOrUpdate')) {
        return;
    }
    
    AccountSharingDataHandler handler = new AccountSharingDataHandler('AccountDealer');
    handler.shareDealerByCrmCode(trigger.newMap,trigger.oldMap,trigger.isInsert);
    if(trigger.isInsert){
        handler.share3rdAccount(trigger.newMap);
    }
}