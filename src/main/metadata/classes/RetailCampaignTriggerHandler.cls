public class RetailCampaignTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if (trigger.isAfter && trigger.isInsert) {
            RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
            SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(Trigger.new));
            RetailCampaignHelper.afterInsertUpdateEvents(Trigger.new,(Map<Id,Retail_Campaign__c>)Trigger.oldmap,Trigger.isInsert,Trigger.isUpdate);
        }
        if (trigger.isAfter && trigger.isUpdate) {
            RetailCampaignHelper.afterInsertUpdateEvents(Trigger.new,(Map<Id,Retail_Campaign__c>)Trigger.oldmap,Trigger.isInsert,Trigger.isUpdate);
        }
        if (trigger.isBefore && trigger.isInsert) {
            RetailCampaignHelper.ShareRecordToDealer_BeforeInsert(Trigger.new);
            RetailCampaignHelper.beforeInsertUpdateEvents(Trigger.new,(Map<Id,Retail_Campaign__c>)Trigger.oldmap,Trigger.isInsert,Trigger.isUpdate);
        }
        if (trigger.isBefore && trigger.isUpdate) {
            RetailCampaignHelper.beforeInsertUpdateEvents(Trigger.new,(Map<Id,Retail_Campaign__c>)Trigger.oldmap,Trigger.isInsert,Trigger.isUpdate);
        }
        if(Trigger.isBefore && Trigger.isDelete)
        {
           RetailCampaignHelper.beforeDeleteEvents(Trigger.old);
           RetailCampaignHelper.beforeDeleteRetailCampaignStatus(Trigger.old);  
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}