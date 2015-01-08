/*
    Type:       Trigger
    Purpose:    1. Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
                2. Share lead's contact to Dealer Sales Gate Keeper
                3. If a lead is created from Inquiry case, copy lead id to Case's lead.  US-IB-001
    User Story: US-DP-022, US-DP-023, US-DP-014, US-IB-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    18-April-2013 Sinow Zhang (NTTData)  Created
    16-06-2014 Bing(NDC) Modified
*/
trigger LeadAfterInsertUpdate on Lead__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('LeadAfterInsertUpdate')) {
        return;
    }

    // Map all lead ids and case Ids US-IB-001
    Map<Id, Id> NewCaseLeadIds = new Map<Id, Id>();
    
    // Map all lead ids and dealer Ids for use car
    Map<Id, Id> UsedCarLeadDealerId = new Map<Id, Id>();
    
    // Map all lead ids and dealer Ids for new car
    Map<Id, Id> NewCarLeadDealerId = new Map<Id, Id>();
    
    // Get all dealer ids of update leads for share to contact
    Set<Id> dealerIds = new Set<Id>();

    //------------------Added by bing---------------------
    // Assigned dealer list 
    List<String> assignedDealers = new List<String>();
    //------------------Added by bing---------------------    
    
    // Get all dealers of update leads for share to contact
    List<Lead__c> leadsForUpdate = new List<Lead__c>();
    
    // Share the lead to assigned dealer if "Need Assign To Dealer" field is "Need"
    Set<String> oldDealerIds = new Set<String>();
    Set<String> leadIdsForSharingToDealerOwner = new Set<String>();
    
    for(Lead__c lead : Trigger.new) {
        
        if(Trigger.isInsert){
            
            // By Justin, assgin account sharings to lead owner
            if(lead.Need_Assign_To_Dealer__c == 'Need' && lead.OwnerId != null){
                dealerIds.add(lead.Assigned_Dealer__c);
                leadsForUpdate.add(lead);
            }
            
            if(lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need') {
                leadIdsForSharingToDealerOwner.add(lead.Id);
            }
        }
        
        if(Trigger.isUpdate) {
            if(lead.Lead_Type__c == 'Used Car' && lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need' && lead.Assigned_Dealer__c != Trigger.oldMap.get(lead.Id).Assigned_Dealer__c) {
                UsedCarLeadDealerId.put(lead.Id, lead.Assigned_Dealer__c);
            }
            if(lead.Lead_Type__c == 'New Car' && lead.Assigned_Dealer__c != null && lead.Interested_Vehicle_Brand__c == 'Smart' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.Assigned_Dealer__c != Trigger.oldMap.get(lead.Id).Assigned_Dealer__c) {
                NewCarLeadDealerId.put(lead.Id, lead.Assigned_Dealer__c);
            }
            
            // By Justin, assgin account sharings to lead owner
            if(lead.OwnerId != null && lead.OwnerId != Trigger.oldMap.get(lead.Id).OwnerId){
                dealerIds.add(lead.Assigned_Dealer__c);
                leadsForUpdate.add(lead);
            }
            
            if(lead.Assigned_Dealer__c != null && lead.Need_Assign_To_Dealer__c == 'Need' && (lead.Need_Assign_To_Dealer__c != Trigger.oldMap.get(lead.Id).Need_Assign_To_Dealer__c || lead.Assigned_Dealer__c != Trigger.oldMap.get(lead.Id).Assigned_Dealer__c)) {
                oldDealerIds.add(Trigger.oldMap.get(lead.Id).Assigned_Dealer__c);
                leadIdsForSharingToDealerOwner.add(lead.Id);
            }
        }
    
        //US-IB-001
        if(Trigger.isInsert && lead.Case__c != null) {
            NewCaseLeadIds.put(lead.Case__c, lead.Id);
        }
        
    }

    //------------------Added by bing---------------------
    system.debug('Bing.log===========' + assignedDealers);
    //shareing person account to same crm code dealer
    AccountSharingDataHandler handler = new AccountSharingDataHandler('Lead__c');
    handler.shareAccountByCRMCode(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
    
    //------------------Added by bing---------------------
        
    if(UsedCarLeadDealerId.keySet().size() > 0 || NewCarLeadDealerId.keySet().size() > 0) {
        LeadHelper.insertLeadSharing(UsedCarLeadDealerId, NewCarLeadDealerId);
    }
    
    // Share contact to lead's owner
    if(leadsForUpdate.size() > 0) {
        LeadHelper.ShareToGateKeeper(dealerIds, leadsForUpdate);
    }
    
    if(NewCaseLeadIds.keySet().size() > 0) {
        LeadHelper.UpdateCasesWithLeadId(NewCaseLeadIds);
    }
    
    if(leadIdsForSharingToDealerOwner.size() > 0){
        oldDealerIds.remove(null);
        LeadHelper.shareToAssignedDealer(oldDealerIds, leadIdsForSharingToDealerOwner);
    }
}