trigger ToolKitTrigger on Tool_Kit__c (before insert,before update, after insert, after update, after delete)
{
    if (!TriggerUtil.isTriggerEnabled('ToolKitTrigger')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.oldMap,Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        SharingService.shareToolKits(wrapService.wrapToolKits(Trigger.new));
        SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(Trigger.new));
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.oldMap,Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
        ToolKitTriggerHelper.shareToolKit(Trigger.oldMap,Trigger.newMap);
    }
    if(trigger.isAfter && trigger.isDelete)
    {
        ToolKitTriggerHelper.afterInsertUpdateDeleteEvents(Trigger.new,Trigger.old,Trigger.oldMap,Trigger.newMap,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete);
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