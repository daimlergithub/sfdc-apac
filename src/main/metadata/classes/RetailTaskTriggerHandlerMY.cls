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
        List<Retail_Task__c> RtNewList = Trigger.new;
        if(!isDelete && !RtNewList.isEmpty() && RtNewList.size() > 0 && RtNewList[0].MD__c == 'MY')
        {   // Implementation to addedd as required in market
			if(Trigger.isInsert && Trigger.isAfter){
				RetailTaskHelperMY rt=new RetailTaskHelperMY();
				rt.shareRetailTasks(Trigger.new);
			}
		}
    }

}