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
          if(Trigger.isAfter && Trigger.isInsert){
        Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
           AccountLinkHelper.afterInsertDeleteEvent(Trigger.new); 
            AccountLinkHelper.afterInsertEvent(Trigger.new);
        }
        if(Trigger.isAfter && Trigger.isDelete){
            
            AccountLinkHelper.afterDeleteEvent(Trigger.old);
            

        }
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterUpdateEvent(Trigger.new, oldmap);
            AccountLinkHelper.ExportNotification(Trigger.new, oldmap); 
        }
        if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
        {
        
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.beforeInsertUpdateEvent(Trigger.new, oldMap);
        }
         if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert) )
        {        
            
            AccountLinkHelper.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
           
        }
    }
        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            
            AccountLinkHelper.ExportNotification(Trigger.new, oldmap); 
        }
         if(Trigger.isAfter && Trigger.isInsert)
          {
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelper.afterInsertDeleteEvent(Trigger.new); 
          }
        if(Trigger.isAfter && Trigger.isDelete)
        {
            AccountLinkHelper.afterDeleteEvent(Trigger.old); 
        }

    }
}