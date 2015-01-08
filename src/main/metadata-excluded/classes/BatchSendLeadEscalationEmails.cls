/*
 * Name                 : BatchSendLeadEscalationEmails
 * Object               : Account(Dealer), Lead
 * Requirement          : US-Lead-46, US-Lead-47, US-Lead-48
 * Refer classes        : BatchSendLeadEscalationEmail
 * Author               : Mouse Liu
 * Create Date          : 2013-06-17
 * Modify History       : 
 * 
 */
global class BatchSendLeadEscalationEmails implements Database.Batchable<SObject> {
    private String query;
    private Map<Id, Attachment> parentIdAttMap;
    private String addressId;
    
    global BatchSendLeadEscalationEmails(String q, Map<Id, Attachment> p, String a) {
        this.query = q;
        this.parentIdAttMap = p;
        this.addressId = a;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Outbound_Email__c> scope) {
        List<Messaging.SingleEmailMessage> mails = 
            new List<Messaging.SingleEmailMessage>();

        for (Outbound_Email__c outboundEmail : scope) {
            if (outboundEmail.ToAddresses__c == null) {
                continue;
            }

            // Get the Attachment
            Attachment att = parentIdAttMap.get(outboundEmail.Id);

            // Compose Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(outboundEmail.ToAddresses__c.split(';'));
            mail.setSubject(outboundEmail.Subject__c);
            mail.setHtmlBody(att.Body.toString());
            mail.setOrgWideEmailAddressId(addressId);

            if (outboundEmail.CcAddresses__c != null) {
                mail.setCcAddresses(outboundEmail.CcAddresses__c.split(';'));
            }
            mails.add(mail);

            // We assume all email sending are successful.
            outboundEmail.Status__c = 'Sent';
        }

        // Send Email
        try {
        Messaging.SendEmailResult[] sendMailResults = Messaging.sendEmail(mails, false);
        } catch(Exception ex) {
            system.debug('Send Collaboration Team Email Exception : execute :' + ex.getMessage());
        }

        // Update Outbound Email status
        update scope;
    }

    global void finish(Database.BatchableContext bc) {

    }
}