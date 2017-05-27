/*
Type:       Trigger on Account
Purpose:    1. Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are updated. 
2. Upadte Primary address display field based on primary address reference lookup field.
3. Upadte Primary contact information based on corresponding picklist values.
Created By: Sudhir
Date: 2015-12-22
User Story: US-DS-001, US-Lead-009
Used By:    
---------------------------------------------------------------
*/
public class TriggerAccountTriggerHandlerJP 
implements TriggerHandlerIf
{
   // User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {
     system.debug('------->');   
        
        if(isBefore && isInsert )
        {
            system.debug('Entered before insert TRIGGER');
            AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
            AccountHelperJP.updatePrimaryContactInformationBeforeInsert(Trigger.new,trigger.isInsert);
            AccountHelperJP.updateCompanyAccountNameBeforeInsert(Trigger.new);
        }
        if(isAfter && isInsert )
        {
            system.debug('Entered aFTER TRIGGER');
         // AccountHelperJP.handleAfterInsertEvent(Trigger.new);
        
        }
        
         if(isAfter && isUpdate )
        {
            system.debug('Entered aFTER update TRIGGER');
        //  AccountHelperJP.handleAfterInsertEvent(Trigger.new);
          if(LeadUtil.accountTrigger){
          LeadUtil.vrTrigger = false;

          AccountHelperJP.UpdateVRonAccount (trigger.new);
                    }
        
        }

        if(isBefore && isUpdate)
        {
            system.debug('Entered before update TRIGGER');
            AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.updateCompanyAccountNameBeforeInsert(Trigger.new);
            AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
        }
        if(isAfter && isInsert && !System.isFuture())
        {
           // User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
            system.debug('Entered aFTER insert TRIGGER');
            serializedObject=json.serialize(ListAccNew);
			AccountHelperJP.createUCID(Trigger.new,trigger.isInsert);
             AccountHelperJP.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);            
          //  if(usr.Profile.Name.contains('Dealer') && LeadUtil.Campaigntrigger){
           
        //  }

            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');            
            AccountHelperJP.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);

        }
        
        if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
            
        }
        /*
        # Description:Calling UpdateRetailCopy to update the retail Copy when related account(Account 1) is updated.
        # SFDCJP-669
        # Date: 02/12/2016
        # Author : Kiran
        */
        if(isAfter && isUpdate){
            System.debug('----->Is update is called');
          AccountHelperJP.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new,(Map<Id,Account>)Trigger.OldMap);
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       if(isBefore && isInsert )
        {
            
            AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
            AccountHelperJP.updatePrimaryContactInformationBeforeInsert(Trigger.new,trigger.isInsert);
            
        }
        if(isBefore && isUpdate)
        {
		   //Commented as part of SFDCJP-2305
           // AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            
            AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
        }
        
        if(isAfter && isInsert && !System.isFuture())
        {
           /* serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject); */
            AccountHelperJP.UpdateVRonAccount (trigger.new);
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
           /* serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject); */
            
            if(LeadUtil.accountTrigger){
              LeadUtil.vrTrigger = false;

              AccountHelperJP.UpdateVRonAccount (trigger.new);
            }

        }
          if(isAfter && isInsert )
        {
       //  AccountHelperJP.handleAfterInsertEvent(Trigger.new);             
         }
        
         if(isAfter && isUpdate )
        {
        //  AccountHelperJP.handleAfterInsertEvent(Trigger.new);
            //AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
        }

        
       /* if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
        } */
            //AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
        }
    }