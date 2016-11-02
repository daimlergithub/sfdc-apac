public class TriggerDealerSystemTriggerHandler
		implements TriggerHandlerIf
{
	public void handleTrigger()
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            DealerSystemHelper.shareWithDealer(trigger.new);
        }
    }
}