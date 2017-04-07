public class RetailCampaignTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       
       if(Trigger.isBefore && Trigger.isInsert)
        {
           RetailCampaignHelper.validationParentRetailCampaign(Trigger.New,(Map<Id,Retail_Campaign__c>)Trigger.OldMap, isInsert, isUpdate);
           RetailCampaignHelper.validationChildRetailCampaign(Trigger.New,(Map<Id,Retail_Campaign__c>)Trigger.OldMap, isInsert, isUpdate);
            
        }
        if(Trigger.isBefore && Trigger.isUpdate)
        {
           RetailCampaignHelper.validationParentRetailCampaign(Trigger.New,(Map<Id,Retail_Campaign__c>)Trigger.OldMap, isInsert, isUpdate);
           RetailCampaignHelper.validationChildRetailCampaign(Trigger.New,(Map<Id,Retail_Campaign__c>)Trigger.OldMap, isInsert, isUpdate);
            
        }
      if(Trigger.isAfter && Trigger.isUpdate)
        {
        RetailCampaignHelper.parentRetailCampaignSatusChange(Trigger.New,(Map<ID,Retail_Campaign__c>)trigger.oldMap);
            
        } 
       
       
       
       
        if(Trigger.isBefore && Trigger.isDelete)
        {
           RetailCampaignHelper.beforeDeleteEvents(Trigger.old);
            
        }
         if(Trigger.isAfter && Trigger.isInsert)
        {
           RetailCampaignHelper.afterInsertCopyRetailCampaign(Trigger.New);
           RetailCampaignHelper.emailNotificationRetail(Trigger.New); 
            
        } 
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}