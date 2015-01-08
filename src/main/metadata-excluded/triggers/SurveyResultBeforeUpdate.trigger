/*
    Type:       Trigger
    Purpose:    1. The trigger will be fired before the QC's modification to the Survey result.
                2. Trigger will invoke changeCode method of SurveyResultTriggerHandler.
                3. For more information, please check class SurveyResultTriggerHandler.
                
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Patrick Zhang Created on 2013-09-16
    2. Patrick Zhang added new if condition on 2013-09-24
    3. Patrick Zhang added new if condition on 2013-09-25
*/

trigger SurveyResultBeforeUpdate on Survey_Result__c (before update, before insert) {

    if (!UtilCustomSettings.isEnabled('SurveyResultBeforeUpdate')) {
        return;
    }
    
    List<Survey_Result__c> newSurveys = Trigger.new;
    List<Survey_Result__c> oldSurveys = Trigger.old;
    
    if (Trigger.isUpdate) {
        SurveyResultTriggerHandler.reviewAndChange(Trigger.newMap, Trigger.oldMap);
    }

    if (Trigger.isUpdate) {
        SurveyResultTriggerHandler.removePrefix(newSurveys);
    }

    SurveyResultTriggerHandler.changeCode(newSurveys);
    
}