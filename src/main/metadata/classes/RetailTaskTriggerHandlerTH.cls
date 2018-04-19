public class RetailTaskTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {   
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isInsert && Trigger.isAfter){
            List<Retail_Task__c> retailTaskRecordsLst=Trigger.new;
            List<Retail_Task__c> retailTaskLst=new List<Retail_Task__c>();
            if(retailTaskRecordsLst!=null && retailTaskRecordsLst.size()>0)
            {
                for(Retail_Task__c retailTaskObj:retailTaskRecordsLst)
                {
                    if(retailTaskObj.Market__c=='TH')
                        retailTaskLst.add(retailTaskObj);
                }
                
            }
            
            if(retailTaskLst!=null && !retailTaskLst.isEmpty() && retailTaskLst.size()>0)
            {
                RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
            	SharingService.shareRetailTasks(wrapService.wrapRetailTasksTH(Trigger.new));
            }
            
        }
    }

}