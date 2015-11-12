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
    4. 2014-02-21 Modified by Justin Yu
    5. 2015-04-23 Gerhard Henning (NTTData) Moved code to TriggerCampaignLeadTriggerHandler
*/
public class TriggerCampaignLeadTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
        Map<Id,Campaign_Lead__c> oldmap = (Map<Id,Campaign_Lead__c>)trigger.oldmap;
        Map<Id,Campaign_Lead__c> newmap = (Map<Id,Campaign_Lead__c>)trigger.newmap;
        
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
            UtilCampaignLead.beforeUpdateEvents(trigger.new,oldmap);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}