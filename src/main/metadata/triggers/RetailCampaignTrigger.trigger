trigger RetailCampaignTrigger on Retail_Campaign__c (before insert, before update,after insert, after update) {
    if (!TriggerUtil.isTriggerEnabled('RetailCampaignTrigger')) {
        return;
    }

    if (trigger.isAfter && trigger.isInsert) {
        RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
        SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(Trigger.new));
        RetailCampaignHelper.afterInsertUpdateEvents(Trigger.new,Trigger.Oldmap,Trigger.isInsert,Trigger.isUpdate);
    }
    if (trigger.isAfter && trigger.isUpdate) {
        RetailCampaignHelper.afterInsertUpdateEvents(Trigger.new,Trigger.Oldmap,Trigger.isInsert,Trigger.isUpdate);
    }
    if (trigger.isBefore && trigger.isInsert) {
        RetailCampaignHelper.ShareRecordToDealer_BeforeInsert(Trigger.new);
        RetailCampaignHelper.beforeInsertUpdateEvents(Trigger.new,Trigger.Oldmap,Trigger.isInsert,Trigger.isUpdate);
    }
    if (trigger.isBefore && trigger.isUpdate) {
        RetailCampaignHelper.beforeInsertUpdateEvents(Trigger.new,Trigger.Oldmap,Trigger.isInsert,Trigger.isUpdate);
    }
}