/* Purpose: Handler class for Retail Task trigger for MY
   Date: 01/02/2018
   Created By: Sushma */

public class RetailTaskTriggerHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isInsert && Trigger.isAfter){
            RetailTaskHelperMY rt=new RetailTaskHelperMY();
            rt.shareRetailTasks(Trigger.new);
        }
    }

}