/*
    Type:       Trigger on Account
    Purpose:    1. If customer has no vehicle relationship, Status must not be �Customer� 
                2. Update dealer record in salesforce manually check
                3. When city change , update look up
    User Story: US-DS-001, US-Lead-009
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-28 for US-DS-OO1
    2. Mouse Updated on 2013-07-04 for US-Lead-009
    3. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
    4. Gerhard Henning (NTTData)  Moved code to TriggerAccountHandler on 2015-04-21
*/
trigger TriggerAccount on Account (before insert,before update,after insert, after update, after delete) 
{
    if (!TriggerUtil.isTriggerEnabled('TriggerAccount')) {
        return;
    }
    if(trigger.isAfter && trigger.isInsert)
    {
        AccountHelper.auAfter_Insert_Update_Delete_Events(trigger.NewMap,trigger.OldMap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {
        AccountHelper.auAfter_Insert_Update_Delete_Events(trigger.NewMap,trigger.OldMap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
    }
    if(trigger.isAfter && trigger.isDelete)
    {
        AccountHelper.auAfter_Insert_Update_Delete_Events(trigger.NewMap,trigger.OldMap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
        AccountHelper.auBefore_Insert_Update_Events(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        AccountHelper.auBefore_Insert_Update_Events(trigger.new,trigger.OldMap,trigger.isinsert,trigger.isUpdate);
    }
}