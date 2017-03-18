public class TriggerAccountLinkTriggerHandlerKR 
    implements TriggerHandlerIf
{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {   system.debug('Trigger 1 :');
        if(Trigger.isAfter && Trigger.isInsert){
            system.debug('Trigger 2 :');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.afterInsertEvent(Trigger.new);
            system.debug('Trigger 3 :');
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            system.debug('Trigger 4 :');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.afterUpdateEvent(Trigger.new, oldmap);
            system.debug('Trigger 5 :');
        }     
    }        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
        }
        if(Trigger.isAfter && Trigger.isInsert)
        {
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterInsertEvent(Trigger.new);
        }
    }
}