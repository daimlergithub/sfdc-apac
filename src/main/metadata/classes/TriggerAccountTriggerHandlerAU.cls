/**
* Handler for Trigger on Account for AU(Australia)
* Author: Mohammed Touseef Ahmed 
* Created Date : 2018-23-03
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

public class TriggerAccountTriggerHandlerAU implements TriggerHandlerIf{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public Static boolean insertcontext=true;
    public Static boolean updatecontext=true;
    public static boolean firstRun = true;  
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){

        if(isBefore && isInsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
                AccountHelperAU.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperBase.updatemarket(Trigger.New);
            }
        }
            
        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
            AccountHelperBase.updatemarket(Trigger.New);
            if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
                AccountHelperAU.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
               
                AccounthelperAU.updateOnDoNotCall(Trigger.new);
                AccountHelperAU.updateOnEmailOptout(Trigger.new);
                AccountHelperAU.updateAgeRange(Trigger.new);
                    
            }           
        }
        //New Code Block Added on 9/21/2016
        if(isAfter && isInsert && !System.isFuture())
        {   
             // if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){ // Commented on 2018/may/3 as per Touseef for account create/update issue 
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AccountHelperAU.createUCID(Trigger.new,trigger.isInsert);
                    AccountHelperAU.createUpdateCDMUCID(label.InsertContext,Label.AU,Trigger.new);
                }  
           // }           
        }                                                                      
         if(isAfter && isInsert )
        {
           //Harshit added to check for User permission-Access Management
            if(Util_GetPermissionList.checkAccessOnUser(Label.CreateRetailCopy)){
                AccountHelperAU.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
                }                                                                               
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            // if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){ // Commented on 2018/may/3 as per Touseef for account create/update issue 
                if(TriggerRecursiveCheck.run){
                        TriggerRecursiveCheck.runOnce();
                        AccountHelperAU.createUpdateCDMUCID(Label.UpdateContext,Label.AU,Trigger.new);
                        firstRun=false;
                    }
            // }
            //Harshit added to check for User permission-Access Management
            if(Util_GetPermissionList.checkAccessOnUser(Label.updateRetailCopy))
            {                                                                
                AccountHelperAU.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);
           
            }
            
        }
        if(isAfter && isDelete && !System.isFuture())
        {
          
            
        }
        //End of the New code Block 9/21/2016
        

    
      /*
        # Description:Calling UpdateRetailCopy to update the retail Copy when related account(Account 1) is updated.       
        # Date: 02/20/2017
        # Author : Mohammed Touseef Ahmed
        */
        if(isAfter && isUpdate && Usr.Profile.Name != Label.IntProfileName){
            AccountHelperAU.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){

       
        List<Account> accountNewList = Trigger.new;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && accountNewList[0].MD__c == label.AU)
        {
            if(isBefore && isInsert){                
        AccountHelperAU.updateAccountFieldsBeforeInsertInt(Trigger.new,trigger.isInsert);
            }
        
        if(isBefore && isUpdate){
            AccountHelperAU.updateAccountFieldsBeforeIntUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperAU.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
            AccountHelperAU.updateAgeRange(Trigger.new);
            }
      
      /*  
      //Created By : Mohammed Touseef Ahmed
                //Date: 03/23/2018
                //Description: Create Account Link record in CDM as Retail Copy
            
            */
            if(isAfter && isupdate && !accountNewList.isEmpty() && accountNewList.size() > 0)
            {
                AccountHelperAU.createAccountLinkCDM(accountNewList,(Map<Id,Account>)Trigger.OldMap);
            }   
        }
    }
}