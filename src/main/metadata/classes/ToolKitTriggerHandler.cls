public class ToolKitTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,(Map<Id,Tool_Kit__c>)Trigger.oldMap,(Map<Id,Tool_Kit__c>)Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
            TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
            SharingService.shareToolKits(wrapService.wrapToolKits(Trigger.new));
            SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(Trigger.new));
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,(Map<Id,Tool_Kit__c>)Trigger.oldMap,(Map<Id,Tool_Kit__c>)Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
            ToolKitTriggerHelper.shareToolKit((Map<Id,Tool_Kit__c>)Trigger.oldMap,(Map<Id,Tool_Kit__c>)Trigger.newMap);
        }
        if(trigger.isAfter && trigger.isDelete)
        {
            ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,(Map<Id,Tool_Kit__c>)Trigger.oldMap,(Map<Id,Tool_Kit__c>)Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
        }
        if(trigger.isBefore && trigger.isInsert)
        {
             ToolKitTriggerHelper.beforeInsertUpdateDeleteEvents(Trigger.new,trigger.isinsert);  
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
             ToolKitTriggerHelper.beforeInsertUpdateDeleteEvents(Trigger.new,trigger.isinsert);  
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
    {
    	// Implementation to addedd as required in market
    }
}