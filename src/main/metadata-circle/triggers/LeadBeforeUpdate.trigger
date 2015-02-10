/*
    Type:       Trigger
    Purpose:    1. Assigned to Dealer Sales Gate Keeper
    User Story: US-DP-022, US-DP-023
    Used By:    
    ---------------------------------------------------------------
    History:
    
    18-April-2013 Sinow Zhang (NTTData)  Created
*/
trigger LeadBeforeUpdate on Lead__c (before update, before insert) {
    if (!UtilCustomSettings.isEnabled('LeadBeforeUpdate')) {
        return;
    }

    // Get all dealer ids of update leads
    Set<Id> dealerIds = new Set<Id>();

    // Get all dealers of update leads
    List<Lead__c> leadsForUpdate = new List<Lead__c>();
    Map<Id, Lead__c> ownerIdleads = new Map<Id, Lead__c>();
    Set<Id> noPortalUserDealerIds = new Set<Id>();
    Set<Id> existDealerIds = new Set<Id>();
    
    for(Lead__c lead : Trigger.new) {
        existDealerIds.add(lead.ownerId);
        if(Trigger.isInsert && lead.Assigned_Dealer__c != null) {
            dealerIds.add(lead.Assigned_Dealer__c);
            leadsForUpdate.add(lead);
        }
    }
    
    if(existDealerIds.size() > 0) {
        for(User u : [select id, profileId from User where id in :existDealerIds and Profile.Name != 'Dealer Community Delegate Admin' and Profile.Name != 'Dealer Community User']) {
            noPortalUserDealerIds.add(u.Id);
        }
    }
    
    for(Lead__c lead : Trigger.new) {
        if(Trigger.isUpdate) {
            if(lead.Assigned_Dealer__c != null && noPortalUserDealerIds.contains(lead.OwnerId)) {
                dealerIds.add(lead.Assigned_Dealer__c);
                leadsForUpdate.add(lead);
            } 
        }
    }
    
    // Update lead's owner and share contact to lead's owner
    if(leadsForUpdate.size() > 0) {
    	system.debug('dealerIds>>>'+dealerIds+'>>>'+json.serializepretty(leadsForUpdate));
        LeadHelper.UpdateLeadOwner(dealerIds, leadsForUpdate);
    }

    // Update CAC Lead Status to new for integrationAPI
    // Sinow active this part code, Dec 18,2013, because EP will forward leads to Dealer with status qualified.
    List<Profile> pList = [Select Name From Profile Where Id = :UserInfo.getProfileId() Limit 1];
    if(!pList.isEmpty()){
        if(Trigger.isInsert && pList[0].Name == 'IntegrationAPI'){
            for(Lead__c ld : Trigger.new){
                if(ld.Assigned_to_Dealer_Directly__c) {
                    ld.CAC_Lead_Status__c = 'Qualified';
                }
                else {
                    ld.CAC_Lead_Status__c = 'New';
                }
            }        
        }
    }
}