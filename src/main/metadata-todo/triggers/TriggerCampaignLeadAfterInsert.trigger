/*
    Type:       Trigger
    Purpose:    Insert Campaign Member after insert CampaignLead
    User Story: US-Lead-016, US-Lead-014
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. 2013-5-7 Jorry Created
*/

trigger TriggerCampaignLeadAfterInsert on Campaign_Lead__c (after insert) {
    if (!UtilCustomSettings.isEnabled('TriggerCampaignLeadAfterInsert')) {
        return;
    }

    UtilInsertMemberByCampaignLeads u = new UtilInsertMemberByCampaignLeads();
    u.insertMembers(trigger.new);
}