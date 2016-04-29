/*
    Type:       Trigger on Account
    Purpose:    1. If customer has no vehicle relationship, Status must not be Customer
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
public class TriggerAccountHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
    Map<Id,Account> oldmap = (Map<Id,Account>)trigger.oldmap;
        Map<Id,Account> newmap = (Map<Id,Account>)trigger.newmap;
        list<Account> oldDL = (list<Account>)trigger.old;
        list<Account> newDL = (list<Account>)trigger.new;
        string serializedObject;
        user obj=[select id,profileid,profile.Name from user where id=:userinfo.getuserid()];
        if(trigger.isAfter && trigger.isInsert)
         {
             AccountHelper.auAfter_Insert_Update_Delete_Events(newmap,oldmap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
             serializedObject=json.serialize(newDL);
             if(obj.profile.Name!='IntegrationAPI' && System.IsBatch() == false && System.isFuture() == false)
			 {
			  serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
                 AccountHelper.entityNotifyUpdate('INSERT',newDL[0].Id,serializedObject);
		    }
         }
         if(trigger.isAfter && trigger.isUpdate)
         {
             AccountHelper.auAfter_Insert_Update_Delete_Events(newmap,oldmap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
             AccountHelper.auAfter_Update_UpdatePc_Status_Values(trigger.new);
             serializedObject=json.serialize(newDL);
          if(obj.profile.Name!='IntegrationAPI' && !test.isrunningtest() && System.IsBatch() == false && System.isFuture() == false)
		  {
		      serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
               AccountHelper.entityNotifyUpdate('UPDATE',newDL[0].Id,serializedObject);
	      }
             //Kernel code
             //UtilAccount.accountSetForUpdateLead(trigger.new,oldmap);
         }
         if(trigger.isAfter && trigger.isDelete)
         {
             AccountHelper.auAfter_Insert_Update_Delete_Events(newmap,oldmap,trigger.new,trigger.old,trigger.isinsert,trigger.isDelete,trigger.isUpdate);
             serializedObject=json.serialize(oldDL);
             if(obj.profile.Name!='IntegrationAPI' && System.IsBatch() == false && System.isFuture() == false)
			 {
			     serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
                 AccountHelper.entityNotifyUpdate('DELETE',oldDL[0].Id,serializedObject);
		    }
         }
         if(trigger.isBefore && trigger.isInsert)
         {
             AccountHelper.auBefore_Insert_Update_Events(trigger.new,oldmap,trigger.isinsert,trigger.isUpdate);
             AccountHelper.auBeforeInsertUpdateTrimPhoneFileds(trigger.new);
            AccountHelper.auBeforeInsert_Update_Phonenum_validation(trigger.new);
             //Kernel code
             //UtilAccount.beforeAccDealerInfo(Trigger.new,oldmap,Trigger.isInsert,Trigger.isUpdate);
         }
         if(trigger.isBefore && trigger.isUpdate)
         {
             AccountHelper.auBefore_Insert_Update_Events(trigger.new,oldmap,trigger.isinsert,trigger.isUpdate);
             AccountHelper.auBeforeUpdateCheckRequiredPhoneFields(trigger.new);
             AccountHelper.auBeforeInsertUpdateTrimPhoneFileds(trigger.new);
            AccountHelper.auBeforeInsert_Update_Phonenum_validation(trigger.new);
             //Kernel code
             //UtilAccount.beforeAccDealerInfo(Trigger.new,oldmap,Trigger.isInsert,Trigger.isUpdate);
         }
    }
}