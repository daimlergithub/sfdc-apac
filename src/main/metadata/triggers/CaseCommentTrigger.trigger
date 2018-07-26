/*
 @Author: Tejbir Singh(TH Team)
 @Description: Trigger on Case comment. Used for sending case comments from SFDC to Informatica.
*/ 
trigger CaseCommentTrigger on CaseComment (after insert,after update,before insert) {
    TriggerUtil.handleTrigger('CaseCommentTrigger');
}