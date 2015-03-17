/*
    Type:       Utility for TriggerCampaignLead
    Purpose:    Populate Campaign Title and Campaign Notes 
                according to contact of corresponding lead and campaign
    User Story: US-Lead-013, US-Lead-014,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-24
    2. Mouse Add logic for populating Campaign Title and Notes on 2013-04-26
    3. Mouse Add logic for populate Contact__c on 2013-0509
*/
public with sharing class UtilCampaignLead
{
    // Update Contact__c of Campaign Lead
    public static void updateContact(List<Campaign_Lead__c> campaignLeads)
    {
        for (Campaign_Lead__c campaignLead : campaignLeads) {
            campaignLead.Contact__c = campaignLead.Lead_Account_Id__c;
        }
    }

    // Populating Campaign Title and Notes
    public static void updateCampaignTitleAndNotes(List<Campaign_Lead__c> campaignLeads)
    {
        // Get the map between AccountId and PersonContactId
        Set<Id> accountIds = new Set<Id>();
        for (Campaign_Lead__c campaignLead : campaignLeads)
        {
            accountIds.add(campaignLead.Lead_Account_Id__c);
        }

        Map<Id, Account> accMap = new Map<Id, Account>(
            [SELECT Id, PersonContactId FROM Account WHERE Id IN :accountIds]);

        // Get CampaignMembers by PersonContactIds and CampaignIds in Campaign Lead
        Set<Id> contactIds = new Set<Id>();
        Set<Id> campaignIds = new Set<Id>();
        for (Campaign_Lead__c campaignLead : campaignLeads)
        {
            if (campaignLead.Lead_Account_Id__c != null)
            {
                contactIds.add(accMap.get(campaignLead.Lead_Account_Id__c).PersonContactId);
            }

            if (campaignLead.Campaign__c != null)
            {
                campaignIds.add(campaignLead.Campaign__c);
            }
        }

        // Populate Map<CampaignId + ContactId => CampaignMember>
        List<CampaignMember> members = 
            [SELECT Id, CampaignId, ContactId, Package_Name__c, 
                    Package_Description__c, Participating_Dealer_Name__c,
                    Registration_Notes__c
             FROM CampaignMember 
             WHERE CampaignId IN :campaignIds
             AND ContactId IN :contactIds
             AND (Package_Name__c != NULL 
                  OR Package_Description__c != null
                  OR Participating_Dealer_Name__c != null
                  OR Package_Description__c != null)];

        Map<String, CampaignMember> campaignMemberMap = 
            new Map<String, CampaignMember>();
        for (CampaignMember member : members) {
            String key = String.valueOf(member.CampaignId) + 
                String.valueOf(member.ContactId);
            campaignMemberMap.put(key, member);
        }
        System.debug(campaignMemberMap);

        // Populate Campaign Title
        for (Campaign_Lead__c campaignLead : campaignLeads) {
            // Get CampaignMember by Campaign__c and contactId
            // If acc is null, it means we didn't find the campaign member 
            // in the corresponding campaign, so campaign title should be empty
            Account acc = accMap.get(campaignLead.Lead_Account_Id__c);
            if (acc == null) {
                campaignLead.Campaign_Title__c = null;
                campaignLead.Campaign_Notes__c = null;
                continue;
            }
            
            String contactId = acc.PersonContactId;
            CampaignMember member = 
                campaignMemberMap.get(campaignLead.Campaign__c + contactId);
            
            if (member != null) {
                // Populate Campaign Title by Campaign Member Package info
                campaignLead.Campaign_Title__c = 
                    'Package Name: ' + 
                    (member.Package_Name__c == null ? '' : member.Package_Name__c) + 
                    '\nPackage Description: ' + 
                    (member.Package_Description__c == null ? '' : member.Package_Description__c);
                    
                // Populate Campaign Notes
                campaignLead.Campaign_Notes__c = 
                    'Participating Dealer Name: ' + 
                    (member.Participating_Dealer_Name__c == null ? '' : 
                        member.Participating_Dealer_Name__c) + 
                    '\nRegistration Notes: ' + 
                    (member.Registration_Notes__c == null ? '' : member.Registration_Notes__c);
            }
            else {
                campaignLead.Campaign_Title__c = null;
                campaignLead.Campaign_Notes__c = null;
            }
        }
    }
    
    public static void beforeInsertEvents(list<Campaign_Lead__c> campaignLeadsNew)
    {
    	Set<String> campaignIds = new Set<String>();
        Set<String> leadIds = new Set<String>();
        for(Campaign_Lead__c cl : campaignLeadsNew)
        {
            campaignIds.add(cl.Campaign__c);
            leadIds.add(cl.Lead__c);
        }
        if(campaignIds!=null && !campaignIds.IsEmpty() && leadIds!=null && !leadIds.IsEmpty())
        {
        	Set<String> campaignLeadIndexs = new Set<String>();
	        for(Campaign_Lead__c cl : [select Campaign__c, Lead__c from Campaign_Lead__c where Campaign__c in :campaignIds and Lead__c in :leadIds])
	        {
	            String index = cl.Campaign__c + ':' + cl.Lead__c;
	            campaignLeadIndexs.add(index);
	        }
	        
	        List<Campaign_Lead__c> updatedCampaignLeads = new List<Campaign_Lead__c>();
	        for(Campaign_Lead__c cl : campaignLeadsNew)
	        {
	            String index = cl.Campaign__c + ':' + cl.Lead__c;
	            if(!campaignLeadIndexs.contains(index))
	            {
	                cl.FirstTimeImported__c = true;
	            }
	        }
        }
    }
    
    public static void beforeUpdateEvents(list<Campaign_Lead__c> campaignLeadsNew,map<id,Campaign_Lead__c> campaignLeadOldMap)
    {
    	// Get the campaign Lead which campaign or lead has change
        List<Campaign_Lead__c> campaignLeads = new List<Campaign_Lead__c>();
        for (Campaign_Lead__c campaignLead : campaignLeadsNew)
        {
            Campaign_Lead__c oldCampaignLead = campaignLeadOldMap.get(campaignLead.Id);
            if (oldCampaignLead.Campaign__c != campaignLead.Campaign__c || oldCampaignLead.Lead__c != campaignLead.Lead__c)
            {
                campaignLeads.add(campaignLead);
            }
        }

        // US-Lead-013, US-Lead-014: Update the Campaign Lead Title 
        // which campaign or lead has change
        if (campaignLeads!=null && !campaignLeads.IsEmpty())
        {
            updateCampaignTitleAndNotes(campaignLeads);
        }
    }
}