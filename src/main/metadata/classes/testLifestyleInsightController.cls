@isTest

Private class testLifestyleInsightController {
   @isTest
    static void lifestyle(){
        Insights_Question__c InSightsQ= new Insights_Question__c();
        InSightsQ.Insights_Question_Context__c = 'Account|Purchase Factors';
        InSightsQ.Category__c = ''; 
        InSightsQ.Input_Type__c = 'Picklist';
        InSightsQ.Insight_Answer_Choices__c = '1|2|3|4|5';
        InSightsQ.Insights_Question_Text__c = 'Purchase Factor - Brand';
        InSightsQ.market__c = 'AU';
        InSightsQ.Insight_Status__c = true;
        InSightsQ.Insights_Type__c = 'Vehicle'; 
        insert InSightsQ;
        string recordId = InSightsQ.Id;
        String surveyType = InSightsQ.Insights_Type__c;
        LifestyleInsightController.fetchAccountById(recordId,surveyType);
    }
}