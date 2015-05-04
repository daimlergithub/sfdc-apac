/**
    Type:       Test Class
    Purpose:    Test On SubmitSurveyController
    ---------------------------------------------------------------
    History:
    1. zhongyang.si Created on 2015-01-09

*/
@isTest(SeeAllData=true)
public class SubmitSurveyControllerTest{

    @isTest static void testMethod01() {
        Survey__c survey = new Survey__c(name='Test',Survey_Header__c='Test',Thank_You_Text__c='Test');
        insert survey;
        Survey_Question__c question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        Survey_Question__c question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        Survey_Question__c question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        Survey_Question__c question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        ApexPages.currentPage().getParameters().put('type', 'preview');
        ApexPages.currentPage().getParameters().put('surveyID', survey.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
    }

    @isTest static void testMethod02() {
        Survey__c survey = new Survey__c(name='Test',Survey_Header__c='Test',Thank_You_Text__c='Test');
        insert survey;
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        Campaign campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        Apexpages.currentPage().getParameters().put('campaignID',campaign.id);
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact());
        Contact contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        Task task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        Apexpages.currentPage().getParameters().put('taskID', task.id);
        Apexpages.currentPage().getParameters().put('contactID',contact.id);
        ApexPages.currentPage().getParameters().put('type', 'submit');
        Survey_Question__c question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        Survey_Question__c question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        Survey_Question__c question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        Survey_Question__c question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        ApexPages.currentPage().getParameters().put('type', 'submit');
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
    }

    @isTest static void testMethod03() {
        ApexPages.currentPage().getParameters().put('type', 'preview');
        ApexPages.currentPage().getParameters().put('surveyID', 'invalid id');
        SubmitSurveyController con = new SubmitSurveyController();
    }

    @isTest static void testMethod04() {
        Survey__c survey = new Survey__c(name='Test',Thank_You_Text__c='Test');
        insert survey;
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        Campaign campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        Apexpages.currentPage().getParameters().put('campaignID',campaign.id);
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact());
        Contact contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        Task task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        Apexpages.currentPage().getParameters().put('taskID', task.id);
        Apexpages.currentPage().getParameters().put('contactID',contact.id);
        ApexPages.currentPage().getParameters().put('type', 'submit');
        Survey_Question__c question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        Survey_Question__c question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        Survey_Question__c question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        Survey_Question__c question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        SurveyTaker__c surveyTaker = new SurveyTaker__c(Task_ID__c=task.id, survey__c=survey.id,Last_Answered_Question__c=question2.id);
        insert surveyTaker;
        SurveyQuestionResponse__c surveyQuestionResponse = new SurveyQuestionResponse__c(Survey_Question__c=question2.id,SurveyTaker__c=surveyTaker.id,Response__c='a');
        insert surveyQuestionResponse;
        ApexPages.currentPage().getParameters().put('type', 'submit');
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.breakSurvey();
        con.submitSurvey();
    }

    @isTest static void testMethod05() {
        Survey__c survey = new Survey__c(name='Test',Thank_You_Text__c='Test');
        insert survey;
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        Campaign campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        Apexpages.currentPage().getParameters().put('campaignID',campaign.id);
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact());
        Contact contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        Task task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        Apexpages.currentPage().getParameters().put('taskID', task.id);
        Apexpages.currentPage().getParameters().put('contactID',contact.id);
        ApexPages.currentPage().getParameters().put('type', 'submit');
        Survey_Question__c question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        Survey_Question__c question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        Survey_Question__c question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        Survey_Question__c question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        ApexPages.currentPage().getParameters().put('type', 'submit');
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
    }

    @isTest static void testMethod06() {
        Survey__c survey = new Survey__c(name='Test',Thank_You_Text__c='Test');
        insert survey;
        List<Campaign> campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        Campaign campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        Apexpages.currentPage().getParameters().put('campaignID',campaign.id);
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact());
        Contact contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        Task task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        Apexpages.currentPage().getParameters().put('taskID', task.id);
        Apexpages.currentPage().getParameters().put('contactID',contact.id);
        ApexPages.currentPage().getParameters().put('type', 'submit');
        Survey_Question__c question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        Survey_Question__c question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        Survey_Question__c question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        Survey_Question__c question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        SurveyTaker__c surveyTaker = new SurveyTaker__c(Task_ID__c=task.id, survey__c=survey.id,Last_Answered_Question__c=question1.id,Survey_Taking_Status__c='Finish');
        insert surveyTaker;
        ApexPages.currentPage().getParameters().put('type', 'submit');
        SubmitSurveyController con = new SubmitSurveyController();
    }
}