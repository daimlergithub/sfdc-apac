public class TriggerRetailCampaignHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    { RetailCampaignHelperTH rethelper=new RetailCampaignHelperTH();
    if(Trigger.Isafter&&(Trigger.Isinsert||Trigger.Isupdate)){
    
        if(RetailCampaignHelperTH.booleanCampaignUpdate==true){
           RetailCampaignHelperTH.booleanCampaignUpdate=false;
           RetailCampaignHelperTH.parentCampaingStatusChange(Trigger.new);
           RetailCampaignHelperTH.sharerecordswithDealers(trigger.new);
           
           if(trigger.isupdate){
               
              RetailCampaignHelperTH.RevokeRecordaccesstoDealers(Trigger.new,(Map<Id,Retail_Campaign__C>)Trigger.oldmap,Trigger.Old);
           }
           
         }
    }
    
     if (Trigger.isbefore)
        { 
            if(trigger.isupdate||trigger.isinsert){
            RetailCampaignHelperTH.UpdateDealerEmail(Trigger.new);
            }
            
        } 
    }
    
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}