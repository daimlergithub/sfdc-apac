trigger TriggerSurveyQuestionResponse on SurveyQuestionResponse__c (after delete, after insert, after update) {
	TriggerUtil.handleTrigger('TriggerSurveyQuestionResponse');
}