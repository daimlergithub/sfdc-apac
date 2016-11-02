public class TriggerAccountLinkTriggerHandler
			implements TriggerHandlerIf
{
	public void handleTrigger()
    {
        if(trigger.isAfter && trigger.isInsert)
        {
        	AccountLinkHelper.shareAccountToDealer(trigger.new);
        }
    }
}