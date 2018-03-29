/**
* Handler for Trigger on Account for IN(India)
* Author: Honey
* Created Date : 2018-02-27
* Purpose:
1. When the lead information goes to the eDealer system, address is going to be mandatory on the account. 
Currently this integration is at the point of time when booking is done on the lead.
2. Set value of Customer phase field to Care when open complaint exists( Precedence of rule = 1), Sales if sales lead exists ( Precedence of rule = 2), 
Service if Service Lead exists (Precedence of rule =3)
3. If  the vehicle count associated with a customer becomes zero then customer status should become “Ex-Customer”
4. Vehicle amount should auto-populate
5. Created by Dealership field should popolate with the name of the dealership of the user who created the record
*/

public class TriggerAccountTriggerHandlerIN implements TriggerHandlerIf{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public Static boolean insertcontext=true;
    public Static boolean updatecontext=true;
    public static boolean firstRun = true;  
    
   // Util_getPermissions util_getP = new Util_getPermissions();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){
        if(isBefore && isInsert){
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                AccountHelperIN.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
                AccountHelperBase.updatemarket(Trigger.New);
                AccountHelperIN.updateAccountCountry(Trigger.new, trigger.isInsert);
            }
        }
        if(isBefore && isUpdate){
            AccountHelperBase.updatemarket(Trigger.New);
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                AccountHelperIN.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperIN.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
                AccounthelperIN.updateOnDoNotCall(Trigger.new);
                AccountHelperIN.updateOnPostalOptout(Trigger.new);
                AccountHelperIN.updateOnEmailOptout(Trigger.new);
                AccountHelperIN.updateAgeRange(Trigger.new);
                //AccountHelperIN.activeContracts(Trigger.new);        
            }           
        }
        if(isAfter && isInsert && !System.isFuture()){   
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    //AccountHelperIN.createUCID(Trigger.new,trigger.isInsert);
                    AccountHelperIN.createUpdateCDMUCID(label.InsertContext,Label.IN,Trigger.new);
                }  
            }           
        }                                                                      
        if(isAfter && isInsert ){
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                AccountHelperIN.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
            }                                                                               
        } 
        if(isAfter && isUpdate && !System.isFuture()){
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric)){
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AccountHelperIN.createUpdateCDMUCID(Label.UpdateContext,Label.IN,Trigger.new);
                    firstRun=false;
                }
            }
            if(Util_getPermissions.checkCustomPermission(Label.updateRetailCopy)){                                                                
                AccountHelperIN.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);
            }
        }
        if(isAfter && isDelete && !System.isFuture()){
        }
        /*
        # Description:Calling UpdateRetailCopy to update the retail Copy when related account(Account 1) is updated.       
        */
        if(isAfter && isUpdate && Usr.Profile.Name != Label.IntProfileName){
            AccountHelperIN.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Account> accountNewList = Trigger.new;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && accountNewList[0].MD__c == Label.IN){
            if(isBefore && isInsert){
                AccountHelperIN.updateAccountFieldsBeforeInsertInt(Trigger.new,trigger.isInsert);
            }
            if(isBefore && isUpdate){
                AccountHelperIN.updateAccountFieldsBeforeIntUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperIN.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate,(Map<Id,Account>)Trigger.OldMap);
                AccountHelperIN.updateOnDoNotCall(Trigger.new);
                AccountHelperIN.updateOnPostalOptout(Trigger.new);
                AccountHelperIN.updateOnEmailOptout(Trigger.new);
                AccountHelperIN.updateAgeRange(Trigger.new);
                
                
            }
        }
    }
}