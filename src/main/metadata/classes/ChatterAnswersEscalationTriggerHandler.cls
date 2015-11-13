public class ChatterAnswersEscalationTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
        Map<Id,Question> oldmap = (Map<Id,Question>)trigger.oldmap;
        Map<Id,Question> newmap = (Map<Id,Question>)trigger.newmap;
        
        for (Question q: (List<Question>)Trigger.new) {
            try {
                if (q.Priority == 'high' && (q.Cases == null || q.Cases.size() == 0) && oldMap.get(q.id).Priority != 'high') {
                    q = [select Id, Title, Body, CommunityId, createdById, createdBy.AccountId, createdBy.ContactId from Question where Id = :q.Id];
                    Case newCase = new Case(Origin='Chatter Answers', OwnerId=q.CreatedById, QuestionId=q.Id, CommunityId=q.CommunityId, Subject=q.Title, Description=q.Body, AccountId=q.CreatedBy.AccountId, ContactId=q.CreatedBy.ContactId);
                    insert newCase;
                }
            } catch (Exception e) {
                String subjectText = 'Case Escalation exception in site ' + Site.getName();
                String bodyText = 'Case Escalation on Question having ID: ' + q.Id + ' has failed with the following message: ' + e.getMessage() +
                    '\n\nStacktrace: ' + e.getStacktraceString();
    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] { Site.getAdminEmail() };
    
                mail.setReplyTo('no-reply@salesforce.com');
                mail.setSenderDisplayName('Salesforce Chatter Answers User');
    
                // The default sender is the portal user causing this trigger to run, to change this, set an organization-wide address for
                // the portal user profile, and set the ID in the following line.
                // mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                mail.setToAddresses(toAddresses);
                mail.setSubject(subjectText);
                mail.setPlainTextBody(bodyText);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}