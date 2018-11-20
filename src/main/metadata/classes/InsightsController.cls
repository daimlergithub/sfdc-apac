/**
    * @author: Mukul Goel (mukul.goel@infosys.com)
    * @date:  02-Nov-2018
    *
    * @group: Insights
    *
    * @description: This class create the surveys based on the user specification 
    * This class retrieves the saved responses for the questions.
    * This class save the responses for the newly answered questions. 
    * There are 2 defined methods as on 02-Nov-2018
        * fetchQuestionbySurvey(String,String,String) -- used to retireve the question response and create the survey with prefilled data
        * saveQuestions(String,String,String,String)  -- used to save user responses to the questions. 
*/
public class InsightsController {

    public static String marketVal;
    public static String getMarketVal(String recordId) {
        if (marketVal == null || marketVal == '')
            return getMarketValue(recordId);
        else
            return marketVal;
    }

    @AuraEnabled
    public static List < InsightsQuestionsWrapperCls > fetchQuestionbySurvey(String context, String surveyType, String recordId) {

        QuestionWrapperClass tempQWC;
        String selectedAnswer;
        List < InsightsQuestionsWrapperCls > lstIQWC = new List < InsightsQuestionsWrapperCls > ();
        Map < String, List < QuestionWrapperClass >> mapContextQuestion = new Map < String, List < QuestionWrapperClass >> ();
        Map < Id, Insights_Response__c > mapQuestionResponse = new Map < Id, Insights_Response__c > ();
        try {
            Map < Id, Insights_Question__c > mapIdInsightQuestion = new Map < Id, Insights_Question__c > ([Select Id, Insights_Question_Text__c, Insight_Answer_Choices__c, Input_Type__c, Insights_Question_Context__c, Category__c from Insights_Question__c where market__c =: getMarketVal(recordId) and Insight_Status__c = true and Input_Type__c != 'Prepopulate'
                and Insights_Type__c =: surveyType order by Sequence__c
            ]);
            Map < Id, Insights_Response__c > mapIdInsightResponse = new Map < Id, Insights_Response__c > ([Select Id, Insights_Answer_Value__c, Insight_Question__c, recordId__c from Insights_Response__c where RecordId__c =: recordId and Insight_Question__c in: mapIdInsightQuestion.keyset()]);
            if (mapIdInsightResponse.values().size() > 0) {
                for (Insights_Response__c tempResp: mapIdInsightResponse.values())
                    mapQuestionResponse.put(tempResp.Insight_Question__c, tempResp);
            }
            for (Insights_Question__c tempquestion: mapIdInsightQuestion.values()) {
                if (tempquestion.Insights_Question_Context__c.contains(context)) {
                    tempQwC = new QuestionWrapperClass();
                    selectedAnswer = '';
                    tempQWC.recordId = recordId;
                    tempQWC.surveyName = surveyType;
                    tempQwC.questionId = tempquestion.Id;
                    tempQWC.questionText = tempQuestion.Insights_Question_Text__c;
                    tempQWC.questionType = tempQuestion.Input_Type__c;
                    if (tempQuestion.Category__c == null || tempQuestion.Category__c == '')
                        tempQuestion.Category__c = surveyType;
                    if (mapQuestionResponse.get(tempQuestion.id) != null) {
                        selectedAnswer = ((Insights_Response__c) mapQuestionResponse.get(tempQuestion.id)).Insights_Answer_Value__c;
                        tempQWC.answerId = ((Insights_Response__c) mapQuestionResponse.get(tempQuestion.id)).Id;
                    }
                    tempQWC.questionAnswerText = selectedAnswer;

                    if (tempQuestion.Input_Type__c == 'Picklist') {
                        tempQWC.isPicklist = true;
                        List < String > availableOptions = tempQuestion.Insight_Answer_Choices__c.split('\\|');
                        for (String tempStr: availableOptions) {
                            tempQWC.lstSelectOptions.add(new CustomSelectOption(tempStr, tempStr));
                        }
                        if (selectedAnswer != null && selectedAnswer != '')
                            tempQWC.lstSelectedOptions.add(selectedAnswer);
                    }
                    if (tempQuestion.Input_Type__c == 'Multi-select Picklist') {
                        List < String > availableOptions = tempQuestion.Insight_Answer_Choices__c.split('\\|');
                        for (String tempStr: availableOptions)
                            tempQWC.lstSelectOptions.add(new CustomSelectOption(tempStr, tempStr));

                        if (selectedAnswer != null && selectedAnswer != '')
                            tempQWC.lstSelectedOptions.addAll(selectedAnswer.split('\\|'));
                    }
                    if (mapContextQuestion.get(tempQuestion.Category__c) == null)
                        mapContextQuestion.put(tempQuestion.Category__c, new List < QuestionWrapperClass > ());
                    ((List < QuestionWrapperClass > )(mapContextQuestion.get(tempQuestion.Category__c))).add(tempQWC);
                }
            }
            for (String tempContext: mapContextQuestion.keyset())
                lstIQWC.add(new InsightsQuestionsWrapperCls(tempContext, mapContextQuestion.get(tempContext)));
            System.debug('Value of lstQWC' + lstIQWC.size());
        } catch (Exception e) {
            system.debug('Exception Occurred' + e);
        }
        return lstIQWC;
    }

    @AuraEnabled
    public static List < InsightsQuestionsWrapperCls > saveQuestions(String context, String surveyType, String recordId, String questionString) {
        try {
            List < InsightsQuestionsWrapperCls > lstQuestionWrapper = (List < InsightsQuestionsWrapperCls > ) JSON.deserialize(questionString, List < InsightsQuestionsWrapperCls > .class);
            List < Insights_Response__c > lstInsightResp = new List < Insights_Response__c > ();
            Insights_Response__c tempInsightResp;
            for (InsightsQuestionsWrapperCls tempQuestion: lstQuestionWrapper) {
                for (QuestionWrapperClass tempQuestionWrapper: tempQuestion.lstQWC) {
                     if((tempQuestionWrapper.questionAnswerText != null && tempQuestionWrapper.questionAnswerText != '') || (tempQuestionWrapper.lstSelectedOptions != null))
                    {
                        tempInsightResp = new Insights_Response__c();
                        if (tempQuestionWrapper.answerId != null && tempQuestionWrapper.answerId != '')
                            tempInsightResp.Id = tempQuestionWrapper.answerId;
                        tempInsightResp.Insight_Question__c = tempQuestionWrapper.questionId;
                        tempInsightResp.RecordId__c = tempQuestionWrapper.recordId;
                        tempInsightResp.Insights_Answer_Value__c = '';
                        if (tempQuestionWrapper.questionType != 'Multi-select Picklist')
                            tempInsightResp.Insights_Answer_Value__c = tempQuestionWrapper.questionAnswerText;
                        else {
                            for (String tempString: tempQuestionWrapper.lstSelectedOptions)
                                tempInsightResp.Insights_Answer_Value__c += tempString + '|';
                            if (tempInsightResp.Insights_Answer_Value__c != null && tempInsightResp.Insights_Answer_Value__c != '')
                                tempInsightResp.Insights_Answer_Value__c = tempInsightResp.Insights_Answer_Value__c.substring(0, tempInsightResp.Insights_Answer_Value__c.length() - 1);
                        }
                        lstInsightResp.add(tempInsightResp);
                    }
                }
            }
            upsert lstInsightResp;
        } catch (Exception e) {
            system.debug('Exception Occurred' + e);
        }
        return InsightsController.fetchQuestionbySurvey(context, surveyType, recordId);
    }
    
    public static List < PrepopulateInsighstWrapper > fetchPrepopulatedQuestions(String recordId,String surveyType)
    {
        sObject varSObject;
        String queryObj;
        String query = 'SELECT ';
        List < PrepopulateInsighstWrapper > lstLifestyleInsight = new List < PrepopulateInsighstWrapper > ();
        Map < String, List < String >> mapObjFields = new map < String, List < String >> ();
        Map < Id, Insights_Question__c > mapIdPrePopInsightQuestion = new Map < Id, Insights_Question__c > ([Select Id, Insights_Question_Text__c, Insight_Answer_Choices__c,
            Input_Type__c, Insights_Question_Context__c, Category__c
            from Insights_Question__c where market__c =: InsightsController.getMarketVal(recordId) and
            Insight_Status__c = true and Input_Type__c = 'Prepopulate'
            and
            Insights_Type__c =: surveyType order by Sequence__c
        ]);
        for (Insights_Question__c tempIQ: mapIdPrePopInsightQuestion.values()) {
            List < String > lstfieldObject = tempIq.Insight_Answer_Choices__c.split('\\|');
            if (mapObjFields.get(lstfieldObject[0]) == null)
                mapObjFields.put(lstfieldObject[0], new List < String > ());
            ((List < String > ) mapObjFields.get(lstfieldObject[0])).add(lstfieldObject[1]);
        }

        for (String tempObj: mapObjFields.keyset()) {
            queryObj = tempObj;
            for (String tempField: mapObjFields.get(tempObj))
                query += tempfield + ',';

            query = query.substring(0, query.length() - 1);
            query += '  from ' + tempObj + ' where id = :recordId';
            system.debug('Value of Query' + query);
            varSObject = Database.query(query);
        }
        for (Insights_Question__c tempQuestion: mapIdPrePopInsightQuestion.values()) {
            List < String > lstfieldObject = tempQuestion.Insight_Answer_Choices__c.split('\\|');
            lstLifestyleInsight.add(new PrepopulateInsighstWrapper(tempQuestion.Insights_Question_Text__c, String.valueOf(varSobject.get(lstfieldObject[1]))));
        }
        return lstLifestyleInsight;        
    }

    public static String getMarketValue(String recordId) {
        Schema.SObjectType sobjectType = ((Id) recordId).getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        String queryStr = 'select id,market__c from ' + sobjectName + ' where id = :recordId';
        sObject varAcc = Database.query(queryStr);
        marketVal = (String) varAcc.get('market__c');
        return marketVal;
    }
}