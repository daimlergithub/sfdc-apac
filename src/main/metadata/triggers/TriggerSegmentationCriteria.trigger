trigger TriggerSegmentationCriteria on Segmentation_Criteria__c (before insert,before update, after insert, after update) {
    TriggerUtil.handleTrigger('TriggerSegmentationCriteria');
}