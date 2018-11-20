/* Purpose: Handler class for Retail Task trigger for ANZ
   Date: Oct 10 2018
   
*/
public class RetailTaskTriggerHandlerAU implements TriggerHandlerIf{
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
              if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric) || Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric) ){
                
                            RetailTaskHelperAU rt=new RetailTaskHelperAU();
                      rt.shareRetailTasks(Trigger.new); 
              }
        }
    }
    //integration
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Retail_Task__c> RtNewList = Trigger.new;
        if(!isDelete && !RtNewList.isEmpty() && RtNewList.size() > 0 && ( RtNewList[0].MD__c == System.Label.AU ||  RtNewList[0].MD__c == System.Label.NZ)){
           // Implementation to addedd as required in market
            if(Trigger.isInsert && Trigger.isAfter){
                RetailTaskHelperAU rt=new RetailTaskHelperAU();
                rt.shareRetailTasks(Trigger.new);
            }
        }
    }
}