public class InsightsQuestionsWrapperCls {
    
    @AuraEnabled public string surveyContext;
    @AuraEnabled public List<QuestionWrapperClass> lstQWC;
    
    public InsightsQuestionsWrapperCls()
    {
         surveyContext = '';
         lstQWC = new List<QuestionWrapperClass>();
    }
    public InsightsQuestionsWrapperCls(String surveyContext,List<QuestionWrapperClass> lstQWC )
    {
         this.surveyContext = surveyContext;
         this.lstQWC = lstQWC;
    }

}