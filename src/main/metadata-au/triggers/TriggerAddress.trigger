trigger TriggerAddress on Address__c (before insert, before update,after insert, after update, after delete) {
     
     if (!TriggerUtil.isTriggerEnabled('TriggerAddress')) {
        return;
    }
    string serializedObject;
    user obj=[select id,profileid,profile.Name from user where id=:userinfo.getuserid()];
    
    if(trigger.isAfter && trigger.isInsert)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
        serializedObject=json.serialize(trigger.New);
        if(obj.profile.Name!='IntegrationAPI')
             AddressHelper.entityNotifyUpdate('INSERT',trigger.New[0].Id,serializedObject);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
        serializedObject=json.serialize(trigger.New);
        if(obj.profile.Name!='IntegrationAPI')
             AddressHelper.entityNotifyUpdate('UPDATE',trigger.New[0].Id,serializedObject);
    }
    if(trigger.isAfter && trigger.isDelete)
    {
        AddressHelper.auAfter_Insert_Update_Delete_Events(trigger.New,trigger.Old,trigger.oldMap,trigger.isUpdate,trigger.isDelete);
        serializedObject=json.serialize(trigger.Old);
        if(obj.profile.Name!='IntegrationAPI')
             AddressHelper.entityNotifyUpdate('DELETE',trigger.Old[0].Id,serializedObject);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
	  if(obj.profile.Name!='IntegrationAPI')
        {
        AddressHelper.auBeforeInsert_update_Events(trigger.new,trigger.OldMap,trigger.isInsert,trigger.isUpdate);
		}
        AddressHelper.updateAddressOnAccount(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
	    if(obj.profile.Name!='IntegrationAPI')
        {
        AddressHelper.auBeforeInsert_update_Events(trigger.new,trigger.OldMap,trigger.isInsert,trigger.isUpdate);
		}
        AddressHelper.updateAddressOnAccount(trigger.new);
    }
}
