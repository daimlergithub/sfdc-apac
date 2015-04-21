public class ShareAccountLinksToDealerTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        //------------------Added by bing---------------------    
        AccountSharingDataHandler handler = new AccountSharingDataHandler('Account_Link__c');
        handler.shareAccountByAccountLink((Map<Id,Account_Link__c>)Trigger.newMap, (Map<Id,Account_Link__c>)Trigger.oldMap, Trigger.isInsert);
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
}