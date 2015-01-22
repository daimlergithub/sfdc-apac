trigger ShareAccountLinksToDealer on Account_Link__c (after insert, after update) 
{
    if (!UtilCustomSettings.isEnabled('ShareAccountLinksToDealer')) {
        return;
    }
    
    if(Trigger.isInsert) {
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
        
        AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
        SharingService.shareAccountLinks(wrapService.wrapAccountLinksByRecordTypes(Trigger.new));
        
    } else if(Trigger.isUpdate) {
        VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
        SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
    }
}