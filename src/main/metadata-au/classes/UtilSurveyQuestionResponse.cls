public class UtilSurveyQuestionResponse {
    public static void countSurveyQuestionResponseRecordsOnParent(List<SurveyQuestionResponse__c> listSqr){
        
        Set<String> sqrSet = new Set<String>();
        
        for(SurveyQuestionResponse__c sqrObj : listSqr){
            if(sqrObj.Survey_Question__c != null){
                sqrSet.add(sqrObj.Survey_Question__c);
            }
        }
        
        if(!sqrSet.isEmpty())
        {
           database.executeBatch(new BatchSurveyQuestionResponse(sqrSet), 2000);
        }
    }
}