public class RetailCampaignTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
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
    }
}