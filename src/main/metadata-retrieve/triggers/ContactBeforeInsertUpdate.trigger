/*
    Type:       Trigger
    Purpose:    1. There should only be one contact with "Dealer Lead Gate Keeper" selected or "Dealer Complaint Gate Keeper" selected in one Dealer.
                2. There should only be one contact with "Dealer Complaint Manager" selected or "Dealer Presales" selected in one Dealer.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
*/
trigger ContactBeforeInsertUpdate on Contact (before update, before insert) {
    if (!UtilCustomSettings.isEnabled('ContactBeforeInsertUpdate')) {
        return;
    }

    List<Contact> newContactsForGateKeeper = new List<Contact>();
    List<Contact> newContactsForManager = new List<Contact>();
    
    for(Contact con : Trigger.new) {
        if(con.Dealer_Complaint_Gate_Keeper__c || con.Dealer_Lead_Gate_Keeper__c) {
            newContactsForGateKeeper.add(con);
        }
    }
    
    for(Contact con : Trigger.new) {
        if(con.Dealer_Complaint_Manager__c || con.Dealer_Presales__c || con.Dealer_CRM_Manager__c || con.Dealer_Marketing_Manager__c) {
            newContactsForManager.add(con);
        }
    }
    
    // Validate Gate Keeper
    if(newContactsForGateKeeper.size() > 0) {
        ContactHelper.ValidateGateKeeper(newContactsForGateKeeper);
    }
    
    // Validate complaint manager and presales
    if(newContactsForManager.size() > 0) {
        ContactHelper.ValidateManager(newContactsForManager);
    }
}