public class ChatterAnswersEscalationTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
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
            } catch (Exception e) {}
            
        }
    }
}