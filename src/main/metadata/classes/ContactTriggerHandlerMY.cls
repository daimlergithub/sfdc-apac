/**
* Utility for Trigger on Lead__c for MY(Malaysia)
* Dealer gate keeper validation functionality 
* Author: Laqshay
* Created Date : 2018-01-22
*/
public class ContactTriggerHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
                ContactHelperMY.AfterInsertUpdateEvents(trigger.new);
            }
            if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
                ContactHelperMY.ValidateGateKeeper(Trigger.new);
            }
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}