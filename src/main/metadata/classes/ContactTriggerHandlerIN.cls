/**
* Utility for Trigger on Lead__c for IN(India)
* Dealer gate keeper validation functionality 
* Author: Honey
* Created Date : 2018-07-11
*/
public class ContactTriggerHandlerIN implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
            if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
                ContactHelperIN.AfterInsertUpdateEvents(trigger.new);
            }
            if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
                ContactHelperIN.ValidateGateKeeper(Trigger.new);
            }
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}