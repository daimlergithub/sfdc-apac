/* Purpose: Handler class for Retail Task trigger for IN
   Date: 07/09/2018
   Created By: Honey
*/
public class RetailTaskTriggerHandlerIN implements TriggerHandlerIf{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){   
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Retail_Task__c> RtNewList = Trigger.new;
        if(!isDelete && !RtNewList.isEmpty() && RtNewList.size() > 0 && RtNewList[0].MD__c == System.Label.IN){
           // Implementation to addedd as required in market
            if(Trigger.isInsert && Trigger.isAfter){
                RetailTaskHelperIN rt=new RetailTaskHelperIN();
                rt.shareRetailTasks(Trigger.new);
            }
        }
    }
}