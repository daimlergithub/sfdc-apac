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
        if(Trigger.isBefore &&  Trigger.isInsert)
        {        
            system.debug('Entered before TRIGGER');
            
            AccountLinkHelperKR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
           
        }
                
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            system.debug('Entered b efore update TRIGGER');
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
            
        }  
        if(Trigger.isAfter && Trigger.isUpdate)
        {   system.debug('Entered After TRIGGER');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
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