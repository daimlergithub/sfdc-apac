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
trigger TriggerCampaignLead on Campaign_Lead__c (before insert, before update,after insert) {
    if (!TriggerUtil.isTriggerEnabled('TriggerCampaignLead')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {       
        UtilCampaignLead.insertMembers(trigger.new);   
    }
  
    if(trigger.isBefore && trigger.isInsert)
    {
         UtilCampaignLead.updateCampaignTitleAndNotes(trigger.new);
         // US-Lead-001: Update Contact__c of Campaign Lead
         UtilCampaignLead.updateContact(trigger.new);
         
         UtilCampaignLead.beforeInsertEvents(trigger.new);
    }
         
    if(trigger.isBefore && trigger.isUpdate)
    {
        UtilCampaignLead.beforeUpdateEvents(trigger.new,trigger.oldmap);
    }
}