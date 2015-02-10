/*
    Type:       Utility for LeadAfterUpdate
    Purpose:    1.Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
                2.Assigned lead to Dealer Lead Gate Keeper
                3.Share lead's contact to Dealer Sales Gate Keeper
                4.If a lead is created from Inquiry case, copy lead id to Case's lead.  US-IB-001
    User Story: US-DP-022, US-DP-023, US-DP-014, US-IB-001
    Used By:   
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-27
    3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
*/
public class LeadHelper {
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    //TODO -- modified
    private static List<QueueSobject> LeadGateKeeperQ = [select Id, QueueId, Queue.Name from QueueSobject where SobjectType = 'Lead__c' and Queue.Name = 'Dealer Lead Gate Keeper Queue' limit 1];
        
    private static void insertSobjects(List<Sobject> sos) {
        try {
            insert sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Insert Lead sharing DMLException Exception: ' + e);
        }
    }
    
    private static void updateSobjects(List<Sobject> sos) {
        try {
            update sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Insert Lead sharing DMLException Exception: ' + e);
        }
    }
    
    // Insert the corresponding lead sharing records
    public static void insertLeadSharing(Map<Id, Id> UsedCarLeadDealerId, Map<Id, Id> newCarLeadDealerId) {
        Set<Id> existSharingLeadIds = new Set<Id>();
        Map<Id, Id> dealerStarElitOwners = new Map<Id, Id>();
        Map<Id, Id> dealerSmartAccountOwners = new Map<Id, Id>();
        Map<Id, Id> leadIdContactIds = new Map<Id, Id>();
        List<Lead__Share> SharesToInsert = new List<Lead__Share>();
        List<AccountShare> AccSharesToInsert = new List<AccountShare>();
        
        // Map account id and Star Elite Owner or Smart Owner
        for(Account acc : [select Id, Star_Elite_Account_Owner__c, Star_Elite_Account_Owner__r.isActive, Smart_Account_Owner__c, Smart_Account_Owner__r.isActive from Account where Id in :UsedCarLeadDealerId.values() or Id in :newCarLeadDealerId.values()]) {
            if(acc.Star_Elite_Account_Owner__c != null && acc.Star_Elite_Account_Owner__r.isActive == true) {
                dealerStarElitOwners.put(acc.Id, acc.Star_Elite_Account_Owner__c);
            }
            
            if(acc.Smart_Account_Owner__c != null && acc.Smart_Account_Owner__r.isActive == true) {
                dealerSmartAccountOwners.put(acc.Id, acc.Smart_Account_Owner__c);
            }
        }
        
        // Get exist lead share record ids
        for(Lead__share ls : [select Id from Lead__share where ParentID in :UsedCarLeadDealerId.keySet() or ParentID in :newCarLeadDealerId.keySet()]) {
            existSharingLeadIds.add(ls.Id);
        }
        
        // Get exist lead contact ids
        for(Lead__c lead : [select Id, Contact__c from Lead__c where Id in :UsedCarLeadDealerId.keySet() or Id in :newCarLeadDealerId.keySet()]) {
            leadIdContactIds.put(lead.Id, lead.Contact__c);
        }
        
        // Create lead sharing records for Used car
        for(Id leadId : UsedCarLeadDealerId.keySet()) {
            if(!existSharingLeadIds.contains(leadId) && dealerStarElitOwners.containsKey(UsedCarLeadDealerId.get(leadId))) {
                SharesToInsert.add(newLeadShare(leadId, dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
                AccSharesToInsert.add(newAccountShare(leadIdContactIds.get(leadId), dealerStarElitOwners.get(UsedCarLeadDealerId.get(leadId))));
            }
        }
        
        // Create lead sharing records for new car 
        for(Id leadId : newCarLeadDealerId.keySet()) {
            if(!existSharingLeadIds.contains(leadId) && dealerSmartAccountOwners.containsKey(newCarLeadDealerId.get(leadId))) {
                SharesToInsert.add(newLeadShare(leadId, dealerSmartAccountOwners.get(newCarLeadDealerId.get(leadId))));
                AccSharesToInsert.add(newAccountShare(leadIdContactIds.get(leadId), dealerSmartAccountOwners.get(newCarLeadDealerId.get(leadId))));
            }
        }
        
        if(SharesToInsert.size() > 0) {
            insertSobjects(SharesToInsert);
        }
        
        if(AccSharesToInsert.size() > 0) {
            insertSobjects(AccSharesToInsert);
        }
    }
    
    public static void UpdateLeadOwner(Set<Id> dealerIds, List<Lead__c> leadsForUpdate) {
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]) {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate) {
            if(lead.CAC_Lead_Status__c == 'Qualified') {
                if(dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c)) {
                    if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId) {
                        lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    }
                }
                else  if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId){
                    //TODO--added null check
                    if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                    lead.OwnerId = LeadGateKeeperQ[0].QueueId; 
                }
            }
        }
    }
    
    //US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
    public static void UpdateLeadOwnerFromContact(Set<Id> dealerIds, List<Lead__c> leadsForUpdate) {
        List<Lead__c> leadForUpdate = new List<Lead__c>();
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]) {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate) {
            if(lead.Assigned_Dealer__c != null && dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c)) {
                if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId) {
                    lead.OwnerId = dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c);
                    leadForUpdate.add(lead);
                }
                if(lead.Dealer_LMS__c == 'Yes' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) {
                    leadForUpdate.add(lead);
                }
            }
            else  if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId){
                //TODO--added null check
                if(LeadGateKeeperQ!=null && !LeadGateKeeperQ.isEmpty())
                lead.OwnerId = LeadGateKeeperQ[0].QueueId;
                leadForUpdate.add(lead);
            }
        }
        
        if(leadForUpdate.size() > 0) {
            updateSobjects(leadForUpdate);
        }
    }
    
    public static void ShareToGateKeeper(Set<Id> dealerIds, List<Lead__c> leadsForUpdate) {
        List<AccountShare> SharesToInsert = new List<AccountShare>();
        
        // Map dealer id and gate keeper id of dealer
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>();
        
        // Query users for map dealer id and gate keeper id of dealer
        for(User u : [select Id, AccountId from User where isActive = true and AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]) {
            dealerIdGateKeeperIds.put(u.AccountId, u.Id);
        }
        
        // Update lead owner to gate keeper id, if not exist, update lead owner to dealer owner
        for(Lead__c lead : leadsForUpdate) {
            if(dealerIdGateKeeperIds.containsKey(lead.Assigned_Dealer__c)) {
                if((lead.Dealer_LMS__c == 'No' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) || lead.RecordTypeId == afterSalesRecordTypeId) {
                    SharesToInsert.add(newAccountShare(lead.Contact__c, dealerIdGateKeeperIds.get(lead.Assigned_Dealer__c)));
                }/*
                else if(lead.Dealer_LMS__c == 'Yes' && lead.Need_Assign_To_Dealer__c == 'Need' && lead.RecordTypeId == salesRecordTypeId) {
                }
                else {
                    SharesToInsert.add(newAccountShare(lead.Contact__c,  LeadGateKeeperQ.QueueId));
                }*/
            }/*
            else {
                SharesToInsert.add(newAccountShare(lead.Contact__c, LeadGateKeeperQ.QueueId));
            }*/
        }
        
        if(SharesToInsert.size() > 0) {
            insertSobjects(SharesToInsert);
        }
    }
    
    //US-IB-001
    public static void UpdateCasesWithLeadId(Map<Id, Id> NewCaseLeadIds) {
        List<Case> caseForUpdate = new List<Case>();
        for(Case cas : [select Id, Lead__c from Case where Id in :NewCaseLeadIds.keySet()]) {
            cas.Lead__c = NewCaseLeadIds.get(cas.Id);
            caseForUpdate.add(cas);
        }
        
        if(caseForUpdate.size() > 0) {
            updateSobjects(caseForUpdate);
        }
    }
    
    public static void shareToAssignedDealer(Set<String> oldDealerIds, Set<String> leadIds){
        
        // Get the old dealer owner ids
        Set<ID> oldDealerOwnerIds = new Set<ID>();
        for(Account dealer : [select OwnerId from Account where Id in :oldDealerIds]){
            oldDealerOwnerIds.add(dealer.OwnerId);
        }
        
        // Remove the sharing record for old dealer
        delete [select Id from Lead__Share where AccessLevel = 'Read' and ParentId in :leadIds and UserOrGroupId in :oldDealerOwnerIds];
        
        // Create the sharing record for new dealer
        List<Lead__c> leads = [select Id, Assigned_Dealer__r.OwnerId from Lead__c where Id in :leadIds and Assigned_Dealer__r.Owner.isActive = true];
        
        Set<ID> dealerOwnerIds = new Set<ID>();
        for(Lead__c item : leads){
            dealerOwnerIds.add(item.Assigned_Dealer__r.OwnerId);
        }
        
        Set<String> existentShares = new Set<String>();
        for(Lead__Share share : [select ParentId, UserOrGroupId from Lead__Share where ParentId in :leadIds and UserOrGroupId in :dealerOwnerIds]){
            existentShares.add(share.ParentId + '&' + share.UserOrGroupId);
        }
        
        List<Lead__Share> leadShares = new List<Lead__Share>();
        for(Lead__c lead : leads){
            if(!existentShares.contains(lead.Id + '&' + lead.Assigned_Dealer__r.OwnerId)){
                leadShares.add(newLeadShare(lead.Id, lead.Assigned_Dealer__r.OwnerId));
            }
        }
        
        if(leadShares.size() > 0){
            insert leadShares;
        }
    }
    
    /**
     * Private classes
     */
    private static Lead__Share newLeadShare(String leadId, String userOrGroupId) {
        Lead__Share tempShare = new Lead__Share();
        tempShare.AccessLevel = 'Read';
        tempShare.ParentID = leadId;
        tempShare.RowCause = Schema.Lead__Share.RowCause.Manual;
        tempShare.UserOrGroupId = userOrGroupId;
        return tempShare;
    }
    
    private static AccountShare newAccountShare(String accountId, String userOrGroupId) {
        AccountShare tempShare = new AccountShare();
        tempShare.AccountAccessLevel = 'Read';
        tempShare.AccountId = accountId;
        tempShare.UserOrGroupId = userOrGroupId;
        tempShare.OpportunityAccessLevel = 'Read';
        return tempShare;
    }
}