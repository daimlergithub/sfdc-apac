public class ShareCampaignByCollabTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
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
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}
