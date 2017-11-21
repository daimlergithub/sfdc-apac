public class TriggerAccountlinkHandlerTH
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
	
	AccountLinkHelperTH acchelper=new AccountLinkHelperTH();
	/* Data Migration Explicit Fix - Santosh Mohanty */
	if(Trigger.isBefore && Trigger.isUpdate){
	   AccountLinkHelper.updatemarket(Trigger.New);
	}
    if(Trigger.isAfter && (Trigger.isupdate||Trigger.isInsert)){
    System.debug('hello');
        acchelper.afterInsertEventShareRetailCopy(Trigger.new);
        acchelper.afterInsertEventShareAccount(Trigger.new);        
    }
    if(Trigger.isAfter && Trigger.isupdate){
    acchelper.RevokeApexSharingAfterUpdate(Trigger.new,(Map<Id,Account_Link__c>)Trigger.oldmap,Trigger.Old);
    }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}