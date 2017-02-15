public class TriggerAccountLinkTriggerHandler
			implements TriggerHandlerIf
{
	public void handleTrigger()
    {
        Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)trigger.oldmap;
        
        if(trigger.isAfter && trigger.isInsert)
        {
        	AccountLinkHelper.shareAccountToDealer(trigger.new);
            AccountLinkHelper.shareaccountlinksToDealer(trigger.new, oldmap, trigger.isInsert, trigger.isUpdate);
        }
		if(trigger.isAfter && trigger.isUpdate)
        {
        	AccountLinkHelper.shareAccountToDealer(trigger.new);
            AccountLinkHelper.shareaccountlinksToDealer(trigger.new, oldmap, trigger.isInsert, trigger.isUpdate);
        }
    }
}