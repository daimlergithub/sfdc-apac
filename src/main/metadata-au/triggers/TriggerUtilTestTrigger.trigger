trigger TriggerUtilTestTrigger on Idea (before insert, before update, before delete, after insert, after update, after delete) 
{
    if (!TriggerUtil.isTriggerEnabled('TestTrigger')) {
        return;
    }

    TriggerUtilTest.triggerProcessed = true;
}