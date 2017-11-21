/*
Created by suryavarma
date:1/11/2017
*/


trigger TriggerSurveyTaker on SurveyTaker__c (before insert,before update,after insert,after update,after delete) {
TriggerUtil.handleTrigger('TriggerSurveyTaker');
}