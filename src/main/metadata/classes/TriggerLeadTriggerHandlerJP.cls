/*
    Type:       Trigger HAndler class for Lead object
    Created By : Narasimha 
    Created Date : 1/20/2016
*/
public class TriggerLeadTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(isBefore && isUpdate)
        {
            LeadHelperJP.updateCustomerStage(trigger.new, (Map<Id,Lead__C>)Trigger.OldMap, (Map<Id,Lead__C>)Trigger.NewMap);
            
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }

}