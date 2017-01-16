/*
    Type:       Trigger
    Purpose:    Every insert / delete on pack item will do same operation on dealer offering record. 
    User Story: US-Cpn-005
    Used By:    
    ---------------------------------------------------------------
    History:
    
    29-Mar-2013 Jorry Chen (Breakingpoint)    Created
    23-Apr-2015 Gerhard Henning (NTTData)     Moved code to TriggerPackageItemTriggerHandler
*/
public class TriggerPackageItemTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isInsert) UtilDealerOffering.UpdateDOByPackageItem(trigger.new, 'insert');
        else if(trigger.isDelete) UtilDealerOffering.UpdateDOByPackageItem(trigger.old, 'delete');
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    	// Implementation to addedd as required in market
    }
}