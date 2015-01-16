/*
    Type:       Trigger
    Purpose:    Populate Campaign Title and Campaign Notes 
                according to contact of corresponding lead and campaign
    User Story: US-Lead-013, US-Lead-014,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. (US-Lead-013) Mouse Created on 2013-04-24
    2. (US-Lead-014) Mouse Add logic for populating campaign Notes on 2013-04-26
    3. (US-Lead-001) Mouse Add logic for populate Contact__c on 2013-0509
    4. 2014-2-21 Modified by Justin Yu
*/
trigger TriggerCampaignLead on Campaign_Lead__c (before insert, before update) {
    if (!UtilCustomSettings.isEnabled('TriggerCampaignLead')) {
        return;
    }

    // If trigger is Enabled, continue
    if (!UtilCustomSettings.isEnabled('TriggerCampaignLead')) {
        return;
    }

    if (trigger.isBefore && trigger.isInsert) {
        // US-Lead-013, US-Lead-014: Update Campaign Title and Notes
        UtilCampaignLead.updateCampaignTitleAndNotes(trigger.new);

        // US-Lead-001: Update Contact__c of Campaign Lead
        UtilCampaignLead.updateContact(trigger.new);
    }
    
    if (trigger.isBefore && trigger.isUpdate) {
        // Get the campaign Lead which campaign or lead has change
        List<Campaign_Lead__c> campaignLeads = new List<Campaign_Lead__c>();
        for (Campaign_Lead__c campaignLead : trigger.new) {
            Campaign_Lead__c oldCampaignLead = trigger.oldMap.get(campaignLead.Id);
            if (oldCampaignLead.Campaign__c != campaignLead.Campaign__c
                  || oldCampaignLead.Lead__c != campaignLead.Lead__c) {
                campaignLeads.add(campaignLead);
            }
        }

        // US-Lead-013, US-Lead-014: Update the Campaign Lead Title 
        // which campaign or lead has change
        if (campaignLeads.size() > 0) {
            UtilCampaignLead.updateCampaignTitleAndNotes(campaignLeads);
        }
    }
    
    /**
     * 2014-2-21 adds By Justin Yu -- Set the First Time Imported filed on campaign lead
     */
    if(trigger.isInsert){
    	
	    Set<String> campaignIds = new Set<String>();
	    Set<String> leadIds = new Set<String>();
	    for(Campaign_Lead__c cl : trigger.new){
	    	campaignIds.add(cl.Campaign__c);
	    	leadIds.add(cl.Lead__c);
	    }
	    
	    Set<String> campaignLeadIndexs = new Set<String>();
	    for(Campaign_Lead__c cl : [select Campaign__c, Lead__c from Campaign_Lead__c where Campaign__c in :campaignIds and Lead__c in :leadIds]){
	    	String index = cl.Campaign__c + ':' + cl.Lead__c;
	    	campaignLeadIndexs.add(index);
	    }
	    
	    List<Campaign_Lead__c> updatedCampaignLeads = new List<Campaign_Lead__c>();
	    for(Campaign_Lead__c cl : trigger.new){
	    	String index = cl.Campaign__c + ':' + cl.Lead__c;
	    	if(!campaignLeadIndexs.contains(index)){
	    		cl.FirstTimeImported__c = true;
	    	}
	    }
    }
}