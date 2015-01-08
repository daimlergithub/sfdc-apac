trigger ShareLeadsToCampaignUser on Lead__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('ShareLeadsToCampaignUser')) {
        return;
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        LeadSharingWrapService wrapService = new LeadSharingWrapService();
        SharingService.shareLeads(wrapService.wrapLeads(Trigger.new));
    } else if(Trigger.isAfter && Trigger.isUpdate) {
        List<Lead__c> dealerChangedLeads = new List<Lead__c>();
        for(Id leadId : Trigger.newMap.keySet()){
            if(Trigger.oldMap.get(leadId).Assigned_Dealer__c != Trigger.newMap.get(leadId).Assigned_Dealer__c){
                dealerChangedLeads.add(Trigger.newMap.get(leadId));    
            }
        }
        delete [select Id from Lead__Share where parentId in :dealerChangedLeads and RowCause = :Schema.Lead__Share.RowCause.Dealer_Campaign_Share__c];
        
        LeadSharingWrapService wrapService = new LeadSharingWrapService();
        SharingService.shareLeads(wrapService.wrapLeads(dealerChangedLeads));
    }
}