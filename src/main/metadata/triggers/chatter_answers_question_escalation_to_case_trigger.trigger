trigger chatter_answers_question_escalation_to_case_trigger on Question (after update) 
{
    TriggerUtil.handleTrigger('chatter_answers_question_escalation_to_case_trigger');
}