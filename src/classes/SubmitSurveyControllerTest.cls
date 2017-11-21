/**
    Type:       Test Class
    Purpose:    Test On SubmitSurveyController
    ---------------------------------------------------------------
    History:
    1. zhongyang.si Created on 2015-01-09

*/
@isTest
public class SubmitSurveyControllerTest{

Private static Survey__c survey;
Private static Survey_Question__c question1;
Private static Survey_Question__c question2;
Private static Survey_Question__c question3;
Private static Survey_Question__c question4;
Private static SurveyTaker__c surveyTaker;
Private static SurveyQuestionResponse__c surveyQuestionResponse;
Private static List<Campaign> campaigns;
Private static Campaign campaign;
Private static Question qu;
Private static Community community;
Private static List<Contact> contacts;
Private static Contact contact;
Private static List<Task> tasks;
Private static Task task;
Private static String type='type';
Private static String taskid='taskid';
Private static String campaignid='campaignid';
Private static String contactid='contactid';
Private static String submit='submit';
Private static String preview='preview';
Private static String surveyID='surveyID'; 

    static{
        upsert new Trigger__c(Name = 'TriggerSurveyQuestionResponse', Trigger_Name__c = 'TriggerSurveyQuestionResponse', 
                              Trigger_Handler__c = 'TriggerSurveyQuestionResponseHandler', 
                              enabled__c = true, before__c = true, after__c = true, insert__c = true,
                              update__c = true, delete__c = true,Market__c='JP');       
    } 
    public static void preparedTestDate()
        {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        survey = new Survey__c(name='Test',Survey_Header__c='Test',Thank_You_Text__c='Test',Submit_Response__c='Test Response');
        insert survey;
        question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',
                                                              Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        
        campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        
        contacts = new List<Contact>();
        contacts.add(new Contact());
        contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        
        surveyTaker = new SurveyTaker__c(Task_ID__c=task.id, survey__c=survey.id,Last_Answered_Question__c=question2.id,Survey_Taking_Status__c='');
        insert surveyTaker;
        
        surveyQuestionResponse = new SurveyQuestionResponse__c(Survey_Question__c=question2.id,SurveyTaker__c=surveyTaker.id,Response__c='a');
        insert surveyQuestionResponse;
        
        community = [ SELECT Id FROM Community WHERE Name = 'INTERNAL COMMUNITY' ];
        qu=new Question();
        qu.communityId = community.id;
        qu.title='Hello';
        insert qu;
           
           
           }


    @isTest static void testgetNextQuestion() {
        preparedTestDate();
        Test.startTest();
        ApexPages.currentPage().getParameters().put(type, preview);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getPreviousQuestion();
        Test.stopTest();
        system.assertEquals(question2.Type__c,'Single Select--Vertical');
        system.assertEquals(question3.Type__c,'Single Select--Horizontal');

    }

    @isTest static void testsubmitSurvey() {
        preparedTestDate();
        Test.startTest();
         ApexPages.currentPage().getParameters().put(type, preview);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        Apexpages.currentPage().getParameters().put(taskid, task.id);
        Apexpages.currentPage().getParameters().put(campaignid,campaign.id);
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        Test.stopTest();
        System.assertEquals(surveyTaker.Survey_Taking_Status__c, '');
    }
/*
    @isTest static void testMethod03() {
        preparedTestDate();
        Test.startTest();
        ApexPages.currentPage().getParameters().put(type, preview);
        ApexPages.currentPage().getParameters().put(surveyID, 'invalid id');
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        Test.stopTest();
        System.assertEquals(con.finishSurvey,false);
    }
*/
    @isTest static void testbreakSurvey() {
        preparedTestDate();
        Test.startTest();
         ApexPages.currentPage().getParameters().put(type, preview);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        Apexpages.currentPage().getParameters().put(taskid, task.id);
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        Apexpages.currentPage().getParameters().put(campaignid,campaign.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        con.breakSurvey();
        Test.stopTest();
        System.assertEquals(con.operationType,preview);
    }

    @isTest static void testgetPreviousQuestion() {
        preparedTestDate();
        Test.startTest();
         ApexPages.currentPage().getParameters().put(type, preview);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        Apexpages.currentPage().getParameters().put(campaignid,campaign.id);
        Apexpages.currentPage().getParameters().put(taskid, task.id);
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        Test.stopTest();
        System.assertEquals(con.surveyID,survey.id);
    }
    
    
    @isTest static void testupsertSurveyData() {
        preparedTestDate();
        
        boolean returnValueBoolean = false;
        Test.startTest();
         ApexPages.currentPage().getParameters().put(type, submit);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        Apexpages.currentPage().getParameters().put(campaignid,campaign.id);
        Apexpages.currentPage().getParameters().put(taskid, task.id);
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        ApexPages.currentPage().getParameters().put(type, submit);
        ApexPages.currentPage().getParameters().put(type, submit);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        Test.stopTest();
        System.assertEquals(con.taskID,task.id);
    }   
    
    
    @isTest static void testupsertSurveyData1() {
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        survey = new Survey__c(name='Test',Survey_Header__c='Test',Thank_You_Text__c='Test',Submit_Response__c='Test Response');
        insert survey;
        question1 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test01',Type__c='Free Text',OrderNumber__c=1);
        insert question1;
        question2 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test02',Type__c='Single Select--Vertical',
                                                              OrderNumber__c=2,Choices__c='a',Redirect_Question_Number__c='3');
        insert question2;
        question3 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test03',Type__c='Single Select--Horizontal',
                                                              OrderNumber__c=3,Choices__c='a',Redirect_Question_Number__c='4',
                                                              Need_Free_TextBox__c=true,Single_FreeText_Next_Question_No__c=4);
        insert question3;
        question4 = new Survey_Question__c(Survey__c=survey.id,Question__c='Test04',Type__c='Multi-Select--Vertical',
                                                              OrderNumber__c=4,Choices__c='a\nb');
        insert question4;
        
        campaigns = new List<Campaign>();
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaigns.add(new Campaign(Questionnaire__c=survey.id));
        campaign = (Campaign)UtilTestData.createSobjects(campaigns,'Campaign Execution - Simple').get(0);
        
        contacts = new List<Contact>();
        contacts.add(new Contact());
        contact = (Contact)UtilTestData.createSobjects(contacts,'').get(0);
        tasks = new List<Task>();
        tasks.add(new Task(whatid=campaign.id,whoid=contact.id));
        task = (Task)UtilTestData.createSobjects(tasks, 'OB Task').get(0);
        
      
        community = [ SELECT Id FROM Community WHERE Name = 'INTERNAL COMMUNITY' ];
        qu=new Question();
        qu.communityId = community.id;
        qu.title='Hello';
        insert qu;
        
        boolean returnValueBoolean = false;
        Test.startTest();
         ApexPages.currentPage().getParameters().put(type, submit);
        ApexPages.currentPage().getParameters().put(surveyID, survey.id);
        Apexpages.currentPage().getParameters().put(campaignid,campaign.id);
        Apexpages.currentPage().getParameters().put(taskid, task.id);
        Apexpages.currentPage().getParameters().put(contactid,contact.id);
        ApexPages.currentPage().getParameters().put(type, submit);
        ApexPages.currentPage().getParameters().put(type, submit);
        SubmitSurveyController con = new SubmitSurveyController();
        con.getNextQuestion();
        con.getNextQuestion();
        con.getPreviousQuestion();
        con.submitSurvey();
        Test.stopTest();
        System.assertEquals(con.taskID,task.id);
    }   
}