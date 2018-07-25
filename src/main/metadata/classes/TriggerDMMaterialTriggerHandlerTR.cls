public class TriggerDMMaterialTriggerHandlerTR 
    implements TriggerHandlerIf 
{
    string market = System.Label.TR;
    DMMaterialHelperTR dmobj=new DMMaterialHelperTR();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
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