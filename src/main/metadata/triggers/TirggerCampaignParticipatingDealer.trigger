/*
    Type:       Trigger
    Purpose:    Generate Campaign Participating Dealer History LOG 
    User Story: US-Cpn-005,
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Stephano Created on 2013-06-18
*/
trigger TirggerCampaignParticipatingDealer on Participating_Dealer__c (after insert, after update, before delete) {
    if (!UtilCustomSettings.isEnabled('TirggerCampaignParticipatingDealer')) {
        return;
    }
    
    Id cId;
    
    if(trigger.isDelete){
        // Get Current Reocrd ID
        cId = Trigger.old[0].Id;
    } else {
        cId = Trigger.new[0].Id;
    }
    Participating_Dealer__c co = [Select Id, Name, Campaign__c From Participating_Dealer__c Where Id = :cId];
    String type = 'Participating Dealer';
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