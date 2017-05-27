/**
* Handler for Trigger on Account for TH(Thailand)
* Author: Mohammed Touseef Ahmed 
* Created Date : 2017-01-23
* Purpose:
* 1.Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are inserted/updated. 
* 2.Update primary address details from the associated preferred address records.
* 3.Outbound webservice callout to send customer information to EP. [ ON HOLD ]
* 4.Calculate Vehicle Amount based on Number of Vehicle Relationships (current date is within start_date and end_date with validy__c is "yes" and 
*   if this account has multiple roles for one vehicle, should be counted as 1).
* 5.Implement Do Not Call(PersonDoNotCall) to automate opt-out for all channels which means that selecting this flag opts out the customer from 
*    being contacted via all Phone numbers (Ex: Home Phone, Mobile, Work Phone).
* 6.Implement Postal_Opt_Out__c to automate opt-out for all addresses which means that selecting this flag opts out the customer from being contacted 
*   via Addresses (Ex: Home Address, Office Address, etc.).
* 7.Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
* 8.Calculate “Age Range” based on birthdate.
*/

public class TriggerAccountTriggerHandlerTH implements TriggerHandlerIf{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){

        if(isBefore && isInsert){
            AccountHelperTH.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
        }
        
         if(isAfter && isInsert )
        {
            AccountHelperTH.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
        }
        
        if(isBefore && isUpdate){
            AccountHelperTH.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperTH.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
            
            AccounthelperTH.updateOnDoNotCall(Trigger.new);
            AccountHelperTH.updateOnPostalOptout(Trigger.new);

            AccountHelperTH.updateOnEmailOptout(Trigger.new);
            AccountHelperTH.updateAgeRange(Trigger.new);
            AccountHelperTH.activeContracts(Trigger.new);
        }
        //New Code Block Added on 9/21/2016
        if(isAfter && isInsert && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            AccountHelperTH.createUCID(Trigger.new,trigger.isInsert);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
            AccountHelperTH.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);
        }
        
        if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
            //AccountHelperTH.activeContracts(Trigger.new);
        }
        //End of the New code Block 9/21/2016
        
    
    
      /*
        # Description:Calling UpdateRetailCopy to update the retail Copy when related account(Account 1) is updated.       
        # Date: 02/20/2017
        # Author : Mohammed Touseef Ahmed
        */
        if(isAfter && isUpdate && Usr.Profile.Name != 'IntegrationAPI'){
            AccountHelperTH.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){

       if(isBefore && isInsert){
            AccountHelperTH.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
        }
		If(isBefore && (isInsert||isUpdate)){      
      AccountHelperTH.updatePhoneFormat(Trigger.new);
      }
        
        if(isBefore && isUpdate){
            AccountHelperTH.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperTH.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
            
            AccounthelperTH.updateOnDoNotCall(Trigger.new);
            AccountHelperTH.updateOnPostalOptout(Trigger.new);
            AccountHelperTH.updateOnEmailOptout(Trigger.new);
            AccountHelperTH.updateAgeRange(Trigger.new);
            AccountHelperTH.activeContracts(Trigger.new);
        }
        
        // Copied from JP
        if(isAfter && isInsert && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
            
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
            
        }
        
        if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
        }
        
    }
}