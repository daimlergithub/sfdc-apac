/*
    Type:       Trigger
    Purpose:    1. There should only be one contact with "Dealer Lead Gate Keeper" selected or "Dealer Complaint Gate Keeper" selected in one Dealer.
                2. There should only be one contact with "Dealer Complaint Manager" selected or "Dealer Presales" selected in one Dealer.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
    --------------------------
    Type:       Trigger
    Purpose:    1. Copy contact name, phone, email to Dealer.
                2. Populate the information to account if the contact is aftersales manager.
                3. Update related Lead owner when Contact's Lead gate keeper is checked.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
    2. Justin modified on 2013-07-30
    3. Sinow modified on 2013-09-10
    4. Gerhard Henning (NTTData) moved code to ContactTriggerHandler on 2015-04-21
*/
public class ContactTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if (trigger.isAfter && trigger.isInsert) {
            ContactHelper.AfterInsertUpdateEvents(trigger.new);
        }
        if (trigger.isAfter && trigger.isUpdate) {
            ContactHelper.AfterInsertUpdateEvents(trigger.new); 
        }
        if (trigger.isBefore && trigger.isInsert) {
            // Validate Gate Keeper
            ContactHelper.ValidateGateKeeper(Trigger.new);
            // Validate complaint manager and presales
            ContactHelper.ValidateManager(Trigger.new);
        }
        if (trigger.isBefore && trigger.isUpdate) {
            ContactHelper.updatemarket(Trigger.New);
            // Validate Gate Keeper
            ContactHelper.ValidateGateKeeper(Trigger.new);
            // Validate complaint manager and presales
            ContactHelper.ValidateManager(Trigger.new);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}