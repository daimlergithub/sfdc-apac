/*
Created by suryavarma
date:1/11/2017
*/


trigger TriggerSurvey on Survey__c (before insert,before update,after insert,after update) {
TriggerUtil.handleTrigger('TriggerSurvey');
}