/*
 * Name                 : ScheduleSendLeadEscalationEmail
 * Object               : Account(Dealer), Lead
 * Requirement          : US-Lead-46, US-Lead-47, US-Lead-48
 * Refer classes        : ScheduleLeadEmailEscalation
 * Author               : Mouse Liu
 * Create Date          : 2013-06-17
 * Modify History       : 
 * 
 */
global class ScheduleSendLeadEscalationEmails implements Schedulable {
    global void execute(SchedulableContext sc) {
        String query = 'SELECT Id, CcAddresses__c, ToAddresses__c, ' + 
                       'Subject__c, TargetObjectId__c, Status__c, ' +
                       'Html_Body__c, Text_Body__c ' +
                       'FROM Outbound_Email__c ' + 
                       'WHERE Status__c = \'Not Sent\'';
        System.debug(query);

        // Populate parentIdAttMap
        List<Attachment> atts = [SELECT ParentId, Name, Body 
                                 FROM Attachment 
                                 WHERE ParentId IN 
                                 (SELECT Id FROM Outbound_Email__c 
                                  WHERE Status__c = 'Not Sent')];
        Map<Id, Attachment> parentIdAttMap = new Map<Id, Attachment>();
        for (Attachment att : atts) {
            parentIdAttMap.put(att.ParentId, att);
        }

        // Get Id of Organization-Wide Email Addresses by Name
        OrgWideEmailAddress address = 
            [SELECT Id FROM OrgWideEmailAddress
             WHERE DisplayName = 'BMBS CRM Governance'];
        String addressId = address.Id;

        BatchSendLeadEscalationEmails sendEmailBatch = 
            new BatchSendLeadEscalationEmails(query, parentIdAttMap, addressId);
        Id batchId = Database.executeBatch(sendEmailBatch, 100);
        System.debug('ScheduleMSASolidBaseRevenue Batch Job Id: ' + batchId);
    }
}