public class TestTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        TriggerUtilTest.triggerHandlerCalled = true;
    }
}