trigger ContentBeforeTrigger on ContentVersion (before insert) {
    for(ContentVersion cv : Trigger.new) {
        cv.Publish_Date__c = Date.valueOf(cv.CreatedDate);
    }
}