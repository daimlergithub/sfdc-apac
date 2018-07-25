/*
    Type:       Trigger on AccountLink
    Purpose:    To be added 
    Created By: Narasimha
    Date: 2015-1-11
    User Story:
    Used By:    
    ---------------------------------------------------------------
*/

public class TriggerAccountLinkTriggerHandlerJP 
    implements TriggerHandlerIf
{ 	
	Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
			Boolean CDMRCCreation = false;	
				if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('CDM RC Creation and Update')){
					CDMRCCreation = jpSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
				}		
		
		if(LeadUtil.isAcctrigger )
        {
            if(Trigger.isBefore && Trigger.isInsert)
            {        
                system.debug('Entered before TRIGGER');
                AccountLinkHelper.updateRetailCopy(trigger.isUpdate,trigger.isinsert,trigger.new,(Map<Id,Account_Link__c>)Trigger.oldmap);
                AccountLinkHelper.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
            }
            if(Trigger.isBefore && Trigger.isUpdate)
            {
                /* Data Migration Explicit Fix - Santosh Mohanty */
              AccountLinkHelper.updatemarket(Trigger.New);
        AccountLinkHelper.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
            }
            if(Trigger.isAfter && Trigger.isInsert)
            {
                system.debug('Entered aFTER TRIGGER');
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelper.afterInsertDeleteEvent(Trigger.new,oldmap,Trigger.isInsert,Trigger.isUpdate); 
                AccountLinkHelper.afterInsertEvent(Trigger.new);
                if(LeadUtil.Share2contactInsert)
                {
                AccountLinkHelper.Sharecontact2conatct(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
                LeadUtil.Share2contactInsert=false;
                }
                AccountLinkHelper.deleteduplicatec2calk(Trigger.new);
                //AccountLinkHelper.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
				if (!System.isFuture() && CDMRCCreation) {
					AccountLinkHelperBase.CDMAccountlinkContextGroup(trigger.new,'JP',Label.InsertContext );
				}
            }
            if(Trigger.isAfter && Trigger.isDelete)
            {
                system.debug('Entered delete TRIGGER');
                AccountLinkHelper.afterDeleteEvent(Trigger.old);
            }
            if(Trigger.isAfter && Trigger.isUpdate)
            {
                system.debug('Entered aFTER update TRIGGER');
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelper.updateRetailCopyafterUpdate(Trigger.new, oldmap);
                AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
                AccountLinkHelper.ExportNotification(Trigger.new, oldmap);
                if(LeadUtil.Share2contactUpdate)
                {
                AccountLinkHelper.Sharecontact2conatct(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
                LeadUtil.Share2contactUpdate=false;
                }
                AccountLinkHelper.updateAccountlinks(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
                if (!System.isFuture() && CDMRCCreation) {
				 if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                     TriggerRecursiveCheck.runOnce2();
                     AccountLinkHelperBase.CDMAccountlinkContextGroup(trigger.new, 'JP', Label.UpdateContext); 
                    }   
				}
                //AccountLinkHelper.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
            }
        }
    } 
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        List<Account_Link__c> accList = Trigger.new; 
        if(!isDelete && !accList.isEmpty() && accList.size() > 0 && accList[0].MD__c == 'JP')
        {
            if(Trigger.isAfter && Trigger.isInsert)
            {
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelper.afterInsertEvent(Trigger.new);
                AccountLinkHelper.afterInsertDeleteEvent(Trigger.new,oldmap,Trigger.isInsert,Trigger.isUpdate);
            }
            if(Trigger.isAfter && Trigger.isUpdate)
            {
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
                AccountLinkHelper.ExportNotification(Trigger.new, oldmap);
                AccountLinkHelper.afterInsertDeleteEvent(Trigger.new,oldmap,Trigger.isInsert,Trigger.isUpdate);
            }
            if(Trigger.isAfter && Trigger.isDelete)
            {
                AccountLinkHelper.afterDeleteEvent(Trigger.old); 
            }
        }
    }
}