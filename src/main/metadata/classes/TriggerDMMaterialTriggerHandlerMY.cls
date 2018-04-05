public class TriggerDMMaterialTriggerHandlerMY 
    implements TriggerHandlerIf 
{
    string market = System.Label.MarketMY;
    DMMaterialHelperMY dmobj=new DMMaterialHelperMY();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            if (Trigger.isAfter && Trigger.isInsert)
            { 
                dmobj.shareDMMaterialRecordsWithDealer(trigger.new,market);                        
            }
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    }
}