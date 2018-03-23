public class RetailTaskTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isInsert && Trigger.isAfter){
            User loggedInUser=[select Id,Market__c from user where Id=:UserInfo.getUserId()];
            if(loggedInUser.Market__c=='TH')
            {
                RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
            	SharingService.shareRetailTasks(wrapService.wrapRetailTasksTH(Trigger.new));
            }
            
        }
    }

}