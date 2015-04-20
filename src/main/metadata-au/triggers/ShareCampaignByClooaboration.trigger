/*
    Type:       Trigger
    Purpose:    Share Campaign according to the collaboration team object 
    User Story: US-Cpn-006
    Used By:    
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
*/

trigger ShareCampaignByClooaboration on Collaboration_Team__c (before insert, before update, before delete, after insert) {
    if (!TriggerUtil.isTriggerEnabled('ShareCampaignByClooaboration')) {
        return;
    }

    if (trigger.isBefore && trigger.isInsert) {
        UtilCampaignShareByCollaboration.shareToUserInsert(trigger.new);
    }
    
    if (trigger.isBefore && trigger.isUpdate) {
        UtilCampaignShareByCollaboration.shareToUserUpdate(trigger.new);
    }
    
    if (trigger.isBefore && trigger.isDelete) {
        UtilCampaignShareByCollaboration.shareToUserDelete(trigger.old);
    }
   /* 
    if (trigger.isAfter && trigger.isInsert) {
        Collaboration_Team__c cm = [Select Id, Campaign__r.Name, Member_Name__c, Member_Name__r.Email, Resource_Required__c From Collaboration_Team__c Where Id=:trigger.new[0].Id];
        User us = [Select Id, Email From User Where Id=:cm.Member_Name__c];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        final String template = 'Collaboration Team Notification Template';
        message.setTemplateId([select id from EmailTemplate where Name = :template].id);
        message.setTargetObjectId(us.Id);
        message.setWhatId(cm.Id);       
        message.setToAddresses(new String[] {cm.Member_Name__r.Email});
        message.setSaveAsActivity(false);
        try {
            Messaging.sendEmail(new Messaging.Email[] {message});
        }
        catch(Exception ex) {
            system.debug('Send Collaboration Team Email Exception ::' + ex.getMessage());
        }
    } */
}