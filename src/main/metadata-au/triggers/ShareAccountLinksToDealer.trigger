trigger ShareAccountLinksToDealer on Account_Link__c (after insert, after update) 
{
    if (!TriggerUtil.isTriggerEnabled('ShareAccountLinksToDealer')) {
        return;
    }
    
     //------------------Added by bing---------------------    
    AccountSharingDataHandler handler = new AccountSharingDataHandler('Account_Link__c');
    handler.shareAccountByAccountLink(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    //------------------Added by bing---------------------   
    
    if (Trigger.isInsert) {
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
        
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        SharingService.shareAccountLinks(wrapService.wrapAccountLinksByRecordTypes(Trigger.new));
        
    } 
    else if(Trigger.isUpdate) {
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
    }
}