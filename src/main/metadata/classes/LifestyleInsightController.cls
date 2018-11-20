public class LifestyleInsightController {

    @AuraEnabled
    public static List < PrepopulateInsighstWrapper > fetchAccountById(String recordId, String surveyType) {
        return InsightsController.fetchPrepopulatedQuestions(recordId, surveyType);
    }
}