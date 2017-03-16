public class TriggerAccountLinkTriggerHandlerKR 
    implements TriggerHandlerIf
{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
        if(Trigger.isAfter && Trigger.isInsert){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterInsertEventKR(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterUpdateEventKR(Trigger.new, oldmap);
        }     
    }        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterUpdateEventKR(Trigger.new, oldmap);
        }
        if(Trigger.isAfter && Trigger.isInsert)
        {
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterInsertEventKR(Trigger.new);
        }
    }
}