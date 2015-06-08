/*
    Type:       Trigger
    Purpose:    1. US-Lead-016: Assign Dealer Lead Status to CAC Lead Status 
                   when assigned dealer has been verified
                2. US-Lead-014: Share related Campaign Lead to Lead Owner after dealer is assigned
    User Story: US-Lead-016, US-Lead-014
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-26
    2. Mouse add logic on sharing related campaign lead to lead owner on 2013-04-27
    3. Mouse add logic for US-Lead-021 on 2013-05-17
*/
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
trigger TriggerLead on Lead__c(before insert, before update, after update,after insert) {
    if (!TriggerUtil.isTriggerEnabled('TriggerLead')) {
        return;
    }

    if(trigger.isAfter && trigger.isInsert)
    {
        //TODO-Commented kernel functionality need to add switching mechanism
        /*AccountSharingDataHandler handler = new AccountSharingDataHandler('Lead__c');
        handler.shareAccountByCRMCode(Trigger.newMap, Trigger.oldMap, Trigger.isInsert);
        LeadHelper.afterInsert_UpdateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
        LeadHelper.ShareLeadsToCampaignUser(trigger.new,trigger.OldMap,trigger.NewMap,trigger.isinsert,trigger.isUpdate);*/
        LeadHelper.auAfter_Insert_Update_Events(trigger.new,trigger.NewMap,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        //TODO-Commented kernel functionality need to add switching mechanism
        /*LeadHelper.afterInsert_UpdateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
        LeadHelper.ShareLeadsToCampaignUser(trigger.new,trigger.OldMap,trigger.NewMap,trigger.isinsert,trigger.isUpdate);*/
        LeadHelper.auAfter_Insert_Update_Events(trigger.new,trigger.NewMap,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
        //TODO-Commented kernel functionality need to add switching mechanism
        /*// US-Lead-009
        UtilLead.updateLeadForDataSharing(trigger.new);
        UtilLead.beforeInsert_updateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
        LeadHelper.beforeInsert_UpdateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);*/
        LeadHelper.auBefore_Insert_Update_Events(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        //TODO-Commented kernel functionality need to add switching mechanism
        /*UtilLead.beforeInsert_updateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
        LeadHelper.beforeInsert_UpdateEvents(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);*/
        LeadHelper.auBefore_Insert_Update_Events(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
        LeadHelper.auBeforeUpdateGenericVehicleRecordOnVehicleRelationship(trigger.new,trigger.OldMap,trigger.newmap);
    }
}