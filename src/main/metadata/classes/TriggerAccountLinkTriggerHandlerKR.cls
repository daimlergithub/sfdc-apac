public class TriggerAccountLinkTriggerHandlerKR 
    implements TriggerHandlerIf
{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {   system.debug('Trigger 1 :');
        if(isAfter && isInsert){
            system.debug('Trigger 2 :');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.afterInsertEvent(Trigger.new);
			AccountLinkHelperKR.updateRetailPositionfromC2C(Trigger.isUpdate, Trigger.isAfter ,Trigger.isInsert, trigger.new);
            system.debug('Trigger 3 :');
        }
        if(isAfter && isUpdate){
            system.debug('Trigger 4 :');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.afterUpdateEvent(Trigger.new, oldmap);
			AccountLinkHelperKR.updateRetailPositionfromC2C(Trigger.isUpdate, Trigger.isAfter ,Trigger.isInsert, trigger.new);
			AccountLinkHelperKR.ExportNotification(Trigger.new, oldmap);
			system.debug('Entered After TRIGGER');
            //AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
            system.debug('Trigger 5 :');
        }     
        if(isBefore && isInsert)
        {        
            system.debug('Entered before TRIGGER');
            
            AccountLinkHelperKR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
           
        }
                
        if(isBefore && isUpdate)
        {
            system.debug('Entered b efore update TRIGGER');
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
            
        }    
    }        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
		List<Account_Link__c> accountLinkNewList = Trigger.new;
        if(!isDelete && !accountLinkNewList.isEmpty() && accountLinkNewList.size() > 0 && accountLinkNewList[0].MD__c == 'KR')
        {
			if(Trigger.isAfter && Trigger.isUpdate)
			{
				Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
				AccountLinkHelperKR.afterUpdateEvent(Trigger.new, oldmap);
			}
			if(Trigger.isAfter && Trigger.isInsert)
			{
				Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
				AccountLinkHelperKR.afterInsertEvent(Trigger.new);
			}
		}
    }
}