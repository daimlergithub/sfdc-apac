public class ShareAccountLinksToDealerTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        //------------------Added by bing---------------------    
        AccountSharingDataHandler handler = new AccountSharingDataHandler('Account_Link__c');
        handler.shareAccountByAccountLink((Map<Id,Account_Link__c>)Trigger.newMap, (Map<Id,Account_Link__c>)Trigger.oldMap, Trigger.isInsert);
        //------------------Added by bing---------------------   
        
        if (isInsert) {
            VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
            SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
            
            AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
            SharingService.shareAccountLinks(wrapService.wrapAccountLinksByRecordTypes(Trigger.new));
            
        } 
        else if(isUpdate) {
            VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
            SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}