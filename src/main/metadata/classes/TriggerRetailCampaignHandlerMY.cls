public class TriggerRetailCampaignHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        RetailCampaignHelperMY rethelper=new RetailCampaignHelperMY();
        if(Trigger.Isafter&&(Trigger.Isinsert||Trigger.Isupdate)){
    
            if(RetailCampaignHelperMY.booleanCampaignUpdate==true){
               RetailCampaignHelperMY.booleanCampaignUpdate=false;
               rethelper.parentCampaingStatusChange(Trigger.new,Trigger.Isinsert);
               
               //This will  continue as part of Dealers communities setup
               //RetailCampaignHelperMY.sharerecordswithDealers(trigger.new);
               /*if(trigger.isupdate){
                  RetailCampaignHelperMY.RevokeRecordaccesstoDealers(Trigger.new,(Map<Id,Retail_Campaign__C>)Trigger.oldmap,Trigger.Old);
               }*/
               
             }
    }
    
     if (Trigger.isbefore)
        { 
            if(trigger.isupdate||trigger.isinsert){
            rethelper.UpdateDealerEmail(Trigger.new);
            }
            
        } 
        if(Trigger.isDelete&&Trigger.isBefore){
        rethelper.deleteParentCampaignsandRelatedChildcampaigns(Trigger.Old);
        }
    }
    
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}