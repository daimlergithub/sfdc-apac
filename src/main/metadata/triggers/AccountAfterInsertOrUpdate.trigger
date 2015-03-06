trigger AccountAfterInsertOrUpdate on Account (after insert, after update) {/*
	
	if(trigger.isAfter){
	    if (!UtilCustomSettings.isEnabled('AccountAfterInsertOrUpdate')) {
	        return;
	    }   
	    AccountSharingDataHandler accountDealerhandler = new AccountSharingDataHandler('AccountDealer');
	    accountDealerhandler.shareDealerByCrmCode(trigger.newMap,trigger.oldMap,trigger.isInsert);
	    if(trigger.isInsert){
	        accountDealerhandler.share3rdAccount(trigger.newMap);
	    }	  
	   
     } */
}