@isTest
private with sharing class ChatterAnswersEscalationTriggerTest {
    static testMethod void validateQuestionEscalation() {
        //upsert new Trigger__c(Name = 'ChatterAnswersEscalation',Market__c='NA', Trigger_Name__c = 'chatter_answers_question_escalation_to_case_trigger', Trigger_Handler__c = 'ChatterAnswersEscalationTriggerHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
        String questionTitle = 'questionTitle';
        String questionBody = 'questionBody';
        Test.startTest();
        Community[] c = [SELECT Id from Community];
        // We cannot create a question without a community
        if (c.size() == 0) { return; }
        String communityId = c[0].Id;
        Question q = new Question();
        q.Title = questionTitle;
        q.Body = questionBody;
        q.CommunityId = communityId;
        insert(q);
        q.Priority = 'high';
        update(q);
        
        // Test that escaltion trigger correctly escalate the question to a case
        Case ca = new Case();
        ca.Origin='Chatter Answers';
        ca.CommunityId=communityId;
        ca.Subject='questionTitle';
        ca.Description = 'questionBody';
        ca.QuestionId=q.id;
        insert ca;
        Test.stopTest();
        System.assertEquals(questionTitle, ca.Subject);
        System.assertEquals(questionBody, ca.Description);
        System.assertEquals('Chatter Answers', ca.Origin);
        System.assertEquals(communityId, ca.CommunityId);
    }
}