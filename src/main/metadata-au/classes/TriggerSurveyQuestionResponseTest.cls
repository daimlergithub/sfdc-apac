@isTest
public class TriggerSurveyQuestionResponseTest {
    static{
 		upsert new Trigger__c(Name = 'TriggerSurveyQuestionResponse', Trigger_Name__c = 'TriggerSurveyQuestionResponse', 
                              Trigger_Handler__c = 'TriggerSurveyQuestionResponseHandler', 
							  enabled__c = true, before__c = true, after__c = true, insert__c = true,
                              update__c = true, delete__c = true);       
    }    
    Public static Survey__c sy;
    Public static Survey_Question__c sq;
    Public static SurveyTaker__c st;    
    
    Public static void preparedTestData()
    {
        sy = new Survey__c();
        sy.Submit_Response__c='test';
        insert sy;
        sq = new Survey_Question__c();
        sq.Survey__c=sy.id; //OrderNumber__c, Question__c
        sq.OrderNumber__c=123.00;
        sq.Question__c='testQuestion';
        insert sq;
        st = new SurveyTaker__c();
        insert st;
    }
    Public static testMethod void testcountSurveyQuestionResponseRecordsOnParent1()
    {
        preparedTestData();
        test.startTest();
        SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
        sqr.Survey_Question__c=sq.Id;
        sqr.SurveyTaker__c=st.Id;
        insert sqr;      
        test.stopTest();        
        Survey_Question__c sq1=[select id,Total_Responses__c from Survey_Question__c where id=:sq.Id];
        system.assertEquals(1, sq1.Total_Responses__c);
    }

    Public static testMethod void testcountSurveyQuestionResponseRecordsOnParent2()
    {
        preparedTestData();
        test.startTest();
        SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
        sqr.Survey_Question__c=sq.Id;
        sqr.SurveyTaker__c=st.Id;
        insert sqr;      
        delete sqr;
        test.stopTest();        
        Survey_Question__c sq1=[select id,Total_Responses__c from Survey_Question__c where id=:sq.Id];        
        system.assertEquals(0, sq1.Total_Responses__c);
    }    
}
