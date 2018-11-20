/**
* Handler for Trigger on Account for TR(Turkey)
* Author: Hildaa
* Created Date : 2018-02-28
* Purpose:
* 1.Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are inserted/updated. 
* 2.Update primary address details from the associated preferred address records.

* 3.Calculate Vehicle Amount based on Number of Vehicle Relationships (current date is within start_date and end_date with validy__c is "yes" and 
*   if this account has multiple roles for one vehicle, should be counted as 1).
* 4.Implement Do Not Call(PersonDoNotCall) to automate opt-out for all channels which means that selecting this flag opts out the customer from 
*    being contacted via all Phone numbers (Ex: Home Phone, Mobile, Work Phone).
* 5.Implement Postal_Opt_Out__c to automate opt-out for all addresses which means that selecting this flag opts out the customer from being contacted 
*   via Addresses (Ex: Home Address, Office Address, etc.).
* 6.Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
* 7.Calculate “Age Range” based on birthdate..
* 8.Implement SMSOptOut_PC and Phone opt out
* 9.Implement Social Id and Vat No validations
* 10.Implement KVK Rule
*/

public class TriggerAccountTriggerHandlerTR implements TriggerHandlerIf{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public Static boolean insertcontext=true;
    public Static boolean updatecontext=true;
    public static boolean firstRun = true;  
    public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){
        
        if(isBefore && isInsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
                AccountHelperTR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperBase.updatemarket(Trigger.New);
                AccountHelperTR.errorOnDOCPermissions(Trigger.new,false);
                 AccountHelperTR.validateProvinceCodes(Trigger.new);
            }
        }
        
        if(isBefore && isUpdate){
            //Added by Veena for Social ID and VAT number validation after edit
            
            list<Account> socialAcc = (list<Account>)trigger.new;
            for(Account acc : socialAcc){
                if(acc.Social_id__C!=Null && acc.RecordTypeId== accPerson_RecordTypeId){
                    boolean validId=AccountHelperTR.validateSocialIdTR(acc,'SocId');
                    if(!validId){                   
                        acc.Social_id__C.addError(Label.SocialIdError);
                    }
                }
            }
            list<Account> vatAcc = (list<Account>)trigger.new;
            for(Account acc : vatAcc){
                system.debug('start validation for VAT');
                if(acc.Vat_No__c!=Null && acc.RecordTypeId== accCompany_RecordTypeId && string.valueof(acc.Vat_No__c).length() < 11){
                    boolean validVAT=AccountHelperTR.validateVATNoTR(acc);
                    if(!validVAT){                   
                        acc.Vat_No__c.addError(Label.VATNOError);
                    }
                }
                else if(acc.Vat_No__c!=Null && acc.RecordTypeId== accCompany_RecordTypeId && string.valueof(acc.Vat_No__c).length() == 11){
                    boolean validVAT=AccountHelperTR.validateSocialIdTR(acc,'VatNo');
                    if(!validVAT){                   
                        acc.Vat_No__c.addError(Label.SocialIdError);
                    }
                }
            }
            //end of social id and VAT validation
           
            AccountHelperBase.updatemarket(Trigger.New);
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
                AccountHelperTR.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperTR.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
                 AccountHelperTR.errorOnDOCPermissions(Trigger.new,true);
                 AccountHelperTR.validateProvinceCodes(Trigger.new);
                AccountHelperTR.updateOnDoNotCall(Trigger.new);
                AccountHelperTR.updateOnPostalOptout(Trigger.new);
                AccountHelperTR.UpdateKVKFields(Trigger.new);
                AccountHelperTR.updateOnEmailOptout(Trigger.new);
                AccountHelperTR.updateOnSMSoptout(Trigger.new);
                AccountHelperTR.updateOnPhoneoptout(Trigger.new);
                AccountHelperTR.updateAgeRange(Trigger.new);
                
            }           
        }
        
        if(isAfter && isInsert && !System.isFuture())
        {   
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AccountHelperTR.createUCID(Trigger.new,trigger.isInsert);
                    AccountHelperTR.createUpdateCDMUCID(label.InsertContext,Label.TR,Trigger.new);
                }  
            }           
        }                                                                      
        if(isAfter && isInsert )
        {
            
            if(Util_GetPermissionList.checkAccessOnUser('CreateRetailCopy')){
                AccountHelperTR.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
            }                                                                               
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AccountHelperTR.createUpdateCDMUCID(Label.UpdateContext,Label.TR,Trigger.new);
                    firstRun=false;
                }
            }
            
            if(Util_GetPermissionList.checkAccessOnUser(Label.updateRetailCopy))
            {                                                                
                AccountHelperTR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);
                
            }
            
        }
        if(isAfter && isDelete && !System.isFuture())
        {
            
            
        }
        
        
        
        
        
        if(isAfter && isUpdate && Usr.Profile.Name != Label.IntProfileName){
            AccountHelperTR.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        
        
        List<Account> accountNewList = Trigger.new;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && accountNewList[0].Market__c == label.TR)
        {
            if(isBefore && isInsert){
                //AccountHelperTR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperTR.updateAccountFieldsBeforeInsertInt(Trigger.new,trigger.isInsert);
               // AccountHelperTR.validateProvinceCodes(Trigger.new);
            }
            
            if(isBefore && isUpdate){
                AccountHelperTR.updateAccountFieldsBeforeIntUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperTR.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
                AccountHelperTR.updateOnDoNotCall(Trigger.new);
                AccountHelperTR.updateOnPostalOptout(Trigger.new);
               //  AccountHelperTR.validateProvinceCodes(Trigger.new);
                AccountHelperTR.updateOnEmailOptout(Trigger.new);
                AccountHelperTR.updateOnSMSoptout(Trigger.new);
                AccountHelperTR.updateOnPhoneoptout(Trigger.new);
                AccountHelperTR.updateAgeRange(Trigger.new); 
            }
            if(isAfter && isUpdate){
                AccountHelperTR.updateUcidRetailCopy(trigger.new);
            }
        }
    }
}