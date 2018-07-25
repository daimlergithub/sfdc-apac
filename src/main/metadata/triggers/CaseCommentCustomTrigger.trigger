/*
 @Author: Tejbir Singh(TH Team)
 @Description: Trigger on Case comment. Used for sending case comments from SFDC to Informatica.
*/ 
trigger CaseCommentCustomTrigger on Case_Comment__c (after insert,after update,before insert) {
TriggerUtil.handleTrigger('CaseCommentCustomTrigger');
}