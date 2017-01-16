public class TriggerOrderTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        Map<Id,PreOrder__c> oldmap = (Map<Id,PreOrder__c>)trigger.oldmap;
        Map<Id,PreOrder__c> newmap = (Map<Id,PreOrder__c>)trigger.newmap;
        
        if(trigger.isbefore && trigger.isInsert)
        {
            OrderHelper.Populate_VehicleClass(trigger.new);
        }
        if(trigger.isbefore && trigger.isUpdate)
        {
                OrderHelper.Populate_VehicleClass(trigger.new);
        }
    }
}