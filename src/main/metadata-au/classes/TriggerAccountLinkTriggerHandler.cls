public class TriggerAccountLinkTriggerHandler
			implements TriggerHandlerIf
{
	public void handleTrigger()
    {
        if(trigger.isAfter && trigger.isInsert)
        {
        	AccountLinkHelper.shareAccountToDealer(trigger.new);
        }
		if(trigger.isAfter && trigger.isUpdate)
        {
        	AccountLinkHelper.shareAccountToDealer(trigger.new);
        }
    }
}