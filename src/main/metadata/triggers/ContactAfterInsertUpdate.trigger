/*
    Type:       Trigger
    Purpose:    1. Copy contact name, phone, email to Dealer.
                2. Populate the information to account if the contact is aftersales manager.
                3. Update related Lead owner when Contact's Lead gate keeper is checked.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
    2. Justin modified on 2013-07-30
    3. Sinow modified on 2013-09-10
*/
trigger ContactAfterInsertUpdate on Contact (after update, after insert) {
    if (!UtilCustomSettings.isEnabled('ContactAfterInsertUpdate')) {
        return;
    }

    List<Contact> ComplaintManagerContacts = new List<Contact>();
    List<Contact> PresalesContacts = new List<Contact>();
    List<Contact> CRMManagerContacts = new List<Contact>();
    List<Contact> MarketingManagerContacts = new List<Contact>();
    List<String> aftersalesManagerIds = new List<String>();
    Set<ID> dealerIdsForAssignGateKeeper = new Set<ID>();
    
    //Query new Contacts and map account id and contact infomation
    for(Contact con : Trigger.new) {
        if(con.Dealer_Complaint_Manager__c) {
            ComplaintManagerContacts.add(con);
        }
        if(con.Dealer_Presales__c) {
            PresalesContacts.add(con);
        }
        if(con.Dealer_CRM_Manager__c) {
            CRMManagerContacts.add(con);
        }
        if(con.Dealer_Marketing_Manager__c) {
            MarketingManagerContacts.add(con);
        }
        if(con.Dealer_Aftersales_Manager__c){
            aftersalesManagerIds.add(con.Id);
        }
        if(con.Dealer_Lead_Gate_Keeper__c){
            dealerIdsForAssignGateKeeper.add(con.AccountId);
        }
    }
    
    //setup Complaint Manager infos to dealer
    if(ComplaintManagerContacts.size() > 0) {
        ContactHelper.CopyComplaintManagerInfoToDealer(ComplaintManagerContacts);
    }
    
    //setup presales infos to dealer
    if(PresalesContacts.size() > 0) {
        ContactHelper.CopyPresalesInfoToDealer(PresalesContacts);
    }
    
    //setup CRM manager infos to dealer
    if(CRMManagerContacts.size() > 0) {
        ContactHelper.CopyCRMManagerInfoToDealer(CRMManagerContacts);
    }
    
    //setup marketing manager infos to dealer
    if(MarketingManagerContacts.size() > 0) {
        ContactHelper.CopyMarketingManagerInfoToDealer(MarketingManagerContacts);
    }
    
    // Setup aftersales manager info to dealer
    if(aftersalesManagerIds.size() > 0){
        ContactHelper.copyAftersalesManagerInfoToDealer(aftersalesManagerIds);
    }
    
    //Update related Lead owner when Contact's Lead gate keeper is checked.
    dealerIdsForAssignGateKeeper.remove(null);
    if(dealerIdsForAssignGateKeeper.size() > 0){
        ContactHelper.assignGateKeeperToLeadOwner(dealerIdsForAssignGateKeeper);
    }
}