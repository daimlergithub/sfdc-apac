trigger TriggerMBKSendManage on MBKSendManage__c (before Insert, before Update) {
    TriggerUtil.handleTrigger('TriggerMBKSendManage');
}