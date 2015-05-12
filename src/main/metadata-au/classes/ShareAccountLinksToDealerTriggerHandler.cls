public class ShareAccountLinksToDealerTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        //------------------Added by bing---------------------    
        AccountSharingDataHandler handler = new AccountSharingDataHandler('Account_Link__c');
        handler.shareAccountByAccountLink((Map<Id,Account_Link__c>)Trigger.newMap, (Map<Id,Account_Link__c>)Trigger.oldMap, Trigger.isInsert);
        //------------------Added by bing---------------------   
        
        if (Trigger.isAfter && Trigger.isInsert) {
            VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
            SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
            
            AccountLinkSharingWrapService wrapService = new AccountLinkSharingWrapService();
            SharingService.shareAccountLinks(wrapService.wrapAccountLinksByRecordTypes(Trigger.new));
            
        } 
        if(Trigger.isAfter && Trigger.isUpdate) {
            VehicleSharingWrapService vehicleWrapService = new VehicleSharingWrapService();
            SharingService.shareVehicles(vehicleWrapService.wrapVehicleFromAccountLinks(Trigger.new));
        }
        //Existing AU Functionality starts here.
        if(Trigger.isBefore && Trigger.isInsert)
        {
        	AccountLinkHelper.auBefore_Insert_Events(Trigger.new);
        }
    }
}