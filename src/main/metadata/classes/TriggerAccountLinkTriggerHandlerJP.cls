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
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
          if(LeadUtil.isAcctrigger ){
          if(Trigger.isAfter && Trigger.isInsert)
          {
          system.debug('Entered aFTER TRIGGER');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
               AccountLinkHelper.afterInsertDeleteEvent(Trigger.new); 
                AccountLinkHelper.afterInsertEvent(Trigger.new);
            AccountLinkHelper.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
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
            AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
            AccountLinkHelper.ExportNotification(Trigger.new, oldmap); 
            AccountLinkHelper.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
        }
         //if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert) )
          if(Trigger.isBefore &&  Trigger.isInsert)
        {        
            system.debug('Entered before TRIGGER');
            AccountLinkHelper.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
            AccountLinkHelper.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );            
       
        }
        if(Trigger.isAfter &&  Trigger.isInsert)
        {
         AccountLinkHelper.Sharecontact2conatct(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
        }

          if(Trigger.isBefore && Trigger.isUpdate)
          {
          system.debug('Entered b efore update TRIGGER');
            AccountLinkHelper.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
                AccountLinkHelper.Sharecontact2conatct(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
       
        }
    }
       } 
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        List<Account_Link__c> accList = Trigger.new; 
        if(!isDelete && !accList.isEmpty() && accList.size() > 0 && accList[0].MD__c == 'JP')
        {
        
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
            AccountLinkHelper.ExportNotification(Trigger.new, oldmap); 
        }
         if(Trigger.isAfter && Trigger.isInsert)
          {
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterInsertEvent(Trigger.new);
            AccountLinkHelper.afterInsertDeleteEvent(Trigger.new); 
          }
        if(Trigger.isAfter && Trigger.isDelete)
        {
            AccountLinkHelper.afterDeleteEvent(Trigger.old); 
        }
   }
    }
}