/**
* Handler for Trigger on Account for FM Markets
* Author: Tejbir Singh 
* Created Date : 08-Oct-2018
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
* 8.
*/

public class TriggerAccountTriggerHandlerFM implements TriggerHandlerIf{
    //User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    User usr=Utility_FM.getLoggedInUserInfo();
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public Static boolean insertcontext=true;
    public Static boolean updatecontext=true;
    public static boolean firstRun = true;  
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){

        if(isBefore && isInsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
                AccountHelperFM.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperBase.updatemarket(Trigger.New);
            }
        }
            
        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
            AccountHelperBase.updatemarket(Trigger.New);
            if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
                AccountHelperFM.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperFM.updateOnDoNotCall(Trigger.new);
                AccountHelperFM.updateOnEmailOptout(Trigger.new);
                AccountHelperFM.updateAgeRange(Trigger.new);
                    
            }           
        }
        //New Code Block Added on 9/21/2016
        if(isAfter && isInsert && !System.isFuture())
        {   
             if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AccountHelperFM.createUCID(Trigger.new,trigger.isInsert);
                    AccountHelperFM.createUpdateCDMUCID(label.InsertContext,usr.Market__c,Trigger.new);
                }  
            }           
        }                                                                      
         if(isAfter && isInsert )
        {
           //Harshit added to check for User permission-Access Management
            if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                AccountHelperFM.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
                }                                                                               
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
             if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){
                if(TriggerRecursiveCheck.run){
                        TriggerRecursiveCheck.runOnce();
                        AccountHelperFM.createUpdateCDMUCID(Label.UpdateContext,usr.Market__c,Trigger.new);
                        firstRun=false;
                    }
            }
            //Harshit added to check for User permission-Access Management
            if(Util_GetPermissionList.checkAccessOnUser(Label.updateRetailCopy))
            {                                                                
                AccountHelperFM.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);
           
            }
             if(Util_GetPermissionList.checkAccessOnUser(Label.ALPreferredAddressUpdate)){
                AccountHelperFM.updatePrimaryAddressDetailsOnALK(Trigger.new,(Map<Id,Account>)Trigger.OldMap);
            }
        }
        if(isAfter && isDelete && !System.isFuture())
        {
          
            
        }
        //End of the New code Block 9/21/2016
        
        //to call market specific trigger handler
        FMMarketTriggerFactory.run('Account', usr.Market__c, true, true, true, true, true);
        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){

       
        List<Account> accountNewList = Trigger.new;
        //Added for FM markets
        String marketCodes=Label.HandleIntegrationTriggerFMCountries;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && marketCodes.contains(accountNewList[0].Market__c))
        {
            if(isBefore && isInsert){
				AccountHelperFM.updateAccountFieldsBeforeInsertInt(Trigger.new,trigger.isInsert);
            }
        
        if(isBefore && isUpdate){
            AccountHelperFM.updateAccountFieldsBeforeIntUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperFM.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
            AccountHelperFM.updateAgeRange(Trigger.new);
         
            }
			
			/*	
			//Created By : Mohammed Touseef Ahmed
                //Date: 01/09/2018
                //Description: Create Account Link record in CDM as Retail Copy
            
            */
            if(isAfter && isupdate && !accountNewList.isEmpty() && accountNewList.size() > 0)
            {
                AccountHelperFM.createAccountLinkCDM(accountNewList,(Map<Id,Account>)Trigger.OldMap,usr.Market__c);			
				AccountHelperFM.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
        
            }   
        }
    }
}