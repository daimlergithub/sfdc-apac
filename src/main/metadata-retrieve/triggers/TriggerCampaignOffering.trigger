/*
    Type:       Trigger
    Purpose:    Generate Campaign Offering History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
*/
trigger TriggerCampaignOffering on Campaign_Offering__c (after insert, after update, before delete) {
    if (!UtilCustomSettings.isEnabled('TriggerCampaignOffering')) {
        return;
    }
    
    Id cId;
    
    if(trigger.isDelete){
        // Get Current Reocrd ID
        cId = Trigger.old[0].Id;
    } else {
        cId = Trigger.new[0].Id;
    }
    Campaign_Offering__c co = [Select Id, Name, Campaign__c, Campaign__r.Name From Campaign_Offering__c Where Id = :cId];
    String type = 'Campaign Offering';
    String action = '';
    String cm = co.Campaign__c;
    String objName = co.Name;
    Id us = Userinfo.getUserId();
    
    // LOG Generation Class initialize
    campaignHistoryLogGeneration chlg = new campaignHistoryLogGeneration();
    
    if(trigger.isInsert){
        // INSERT LOG
        action = 'INSERT';
    }
    
    if(trigger.isUpdate){
        // UPDATE LOG
        action = 'UPDATE';
    }
    
    if(trigger.isDelete){
        // DELETE LOG
        action = 'DELETE';
    }
    
    chlg.logGeneration(type, String.valueof(cId), action, cm, us, objName);
}