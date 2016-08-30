/**
* Handler for Trigger on Account for KR(Korea)
* Author: Chethan A 
* Created Date : 2016-08-05
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

public class TriggerAccountTriggerHandlerKR implements TriggerHandlerIf{

    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){
    
        if(isBefore && isInsert){
            AccountHelperKR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
        }
        
        if(isBefore && isUpdate){
            AccountHelperKR.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
          //  AccountHelperKR.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
            
            AccounthelperKR.updateOnDoNotCall(Trigger.new);
          //  AccountHelperKR.updateOnPostalOptout(Trigger.new);
            AccountHelperKR.updateOnEmailOptout(Trigger.new);
            AccountHelperKR.updateAgeRange(Trigger.new);
        }
        
        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    
       if(isBefore && isInsert){
            AccountHelperKR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
        }
        
        if(isBefore && isUpdate){
            AccountHelperKR.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
         //   AccountHelperKR.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
            
            AccounthelperKR.updateOnDoNotCall(Trigger.new);
         //   AccountHelperKR.updateOnPostalOptout(Trigger.new);
            AccountHelperKR.updateOnEmailOptout(Trigger.new);
            AccountHelperKR.updateAgeRange(Trigger.new);
        }
        
    }
}