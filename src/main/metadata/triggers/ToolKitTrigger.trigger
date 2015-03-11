trigger ToolKitTrigger on Tool_Kit__c (before insert,before update, after insert, after update, after delete) {


if (!UtilCustomSettings.isEnabled('ToolKitBeforeInsertUpdateDelete')) {
        return;
   }
 //  for(Tool_Kit__c tk1 : trigger.new) {
     if(trigger.isBefore)
    {
    ToolKitTriggerHelper.ToolKitBeforeInsertUpdateDelete(trigger.new);
    }
 //  }

    if (!UtilCustomSettings.isEnabled('ToolKitAfterInsertUpdateDelete')) {
        return;
    }
    // When new or update tool kit, share it to Vendor
    if (trigger.isInsert || trigger.isUpdate) {
       ToolKitTriggerHelper.toolkitinsertupdate(trigger.new,Trigger.oldMap);
    }  
    
    // Get the shared Tool Kits
    if (trigger.isUpdate || trigger.isDelete) {
               ToolKitTriggerHelper.toolkitupdatedelete(trigger.old,Trigger.newmap);
        
    }
    
    if (!UtilCustomSettings.isEnabled('ShareToolKits')) {
        return;
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        // Shares new tool kits to campaign users and 3rd party users.
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        SharingService.shareToolKits(wrapService.wrapToolKits(Trigger.new));
        SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(Trigger.new));
    }
    else if(Trigger.isAfter && Trigger.isUpdate) {
        // Updates the dealer sharing if a tool kit's dealer has changed.
       ToolKitTriggerHelper.sharetoolkitupdate(Trigger.newmap,Trigger.oldMap);
    }
    
    
   
   }