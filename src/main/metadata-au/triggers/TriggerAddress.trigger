trigger TriggerAddress on Address__c (before insert, before update,after insert, after update, after delete) {
	
	if (!TriggerUtil.isTriggerEnabled('TriggerAddress')) {
        return;
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
    }
    if(trigger.isAfter && trigger.isDelete)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
        AddressHelper.auBeforeInsert_update_Events(trigger.new,trigger.OldMap,trigger.isInsert,trigger.isUpdate);
        AddressHelper.updateAddressOnAccount(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        AddressHelper.auBeforeInsert_update_Events(trigger.new,trigger.OldMap,trigger.isInsert,trigger.isUpdate);
        AddressHelper.updateAddressOnAccount(trigger.new);
    }
}