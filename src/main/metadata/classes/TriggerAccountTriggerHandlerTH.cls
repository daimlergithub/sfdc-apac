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
* 8.Calculate “Age Range” based on birthdate..
* 9.
*/

public class TriggerAccountTriggerHandlerTH implements TriggerHandlerIf{
    public static boolean firstRun = true;
    
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public Static boolean insertcontext=true;
    public Static boolean updatecontext=true;
    
    CDM_EP_Switch__c switchto = CDM_EP_Switch__c.getValues('Switch');
    public void handleTriggerContextVariables(){
    
    }
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){

        if(isBefore && isInsert){
           AccountHelperTH.ValidatePhoneNumberonBeforeEvents(Trigger.new);
           AccountHelperTH.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
        }
        
        
        if(isBefore && isUpdate){
            AccountHelperTH.ValidatePhoneNumberonBeforeEvents(Trigger.new);
            /* Data Update MD Fix - Santosh Mohanty*/
            AccountHelperTH.updatemarket(Trigger.New);
            AccountHelperTH.ValidateNationalid(Trigger.new);
            AccountHelperTH.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperTH.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
            
            AccounthelperTH.updateOnDoNotCall(Trigger.new); 
            //AccountHelperTH.updateOnPostalOptout(Trigger.new);
            AccountHelperTH.updateOnEmailOptout(Trigger.new);
            AccountHelperTH.updateAgeRange(Trigger.new); 
            //AccountHelperTH.activeContracts(Trigger.new);
           // AccountHelperTH.eliminateZerofrmPhone(Trigger.new);
        }
        //New Code Block Added on 9/21/2016
        if(isAfter && isInsert && !System.isFuture() && !System.isBatch())
        {
             if(switchto!=null && switchto.CDM__c==true){
                set<ID> accids=new set<ID>();
                
                for(Account accrec:(List<Account>)trigger.new){
                    accids.add(accrec.id);
                }
                //CDMInformatica_Services.createCustomerCDM(accids);
                if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                CDMInformatica_Services.createCustomerCDM(accids,'TH','insert');
                //firstRun=false;
                }
            }
            AccountHelperTH.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
        } 
        if(isAfter && isUpdate && !System.isFuture() && !System.isBatch())
        {
            /*if(switchto!=null && switchto.EP__c==true){
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
            AccountHelperTH.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new);}*/
            if(switchto!=null && switchto.CDM__c==true){
            Set<ID> accids=new Set<ID>();
            List<Account>acc=[Select Id from Account where id IN:trigger.new];
            for(Account accrec:acc){
                accids.add(accrec.id);
            }
            if(TriggerRecursiveCheck.run){
            TriggerRecursiveCheck.runOnce();
            //CDMInformatica_Services.createCustomerCDM(accids);
            CDMInformatica_Services.createCustomerCDM(accids,'TH','update');
            //firstRun=false;
            }
            }
            AccountHelperTH.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
            if(AccountHelperTH.consentHistoryCodeCalled){
                AccountHelperTH.UpdateConsentHistory((Map<Id,Account>)Trigger.oldMap,Trigger.New);
                AccountHelperTH.consentHistoryCodeCalled = false;
            }
        }
           
    
        
        if(isAfter && isDelete && !System.isFuture())
        {
            if(switchto!=null && switchto.EP__c==true){
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperTH.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);}
            if(switchto.CDM__c==true){}
            //AccountHelperTH.activeContracts(Trigger.new);
        }
        //End of the New code Block 9/21/2016
        
    
    
        /*** This is used for updating the Document Consent History related to ticket SFDCTH-509 ***/
        /*if(isAfter && isUpdate){
            AccountHelperTH.updateRetailCopy(isUpdate, isInsert, isAfter, trigger.new);
            if(AccountHelperTH.consentHistoryCodeCalled){
                AccountHelperTH.UpdateConsentHistory((Map<Id,Account>)Trigger.oldMap,Trigger.New);
                AccountHelperTH.consentHistoryCodeCalled = false;
            }
        }*/
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
     List<Account> accountNewList2 = Trigger.new ; 
        Map<Id,SObject> accountOldMap= Trigger.oldMap;
        List<Account> changedUCIDaccountLst=new List<Account>();
        List<Account> accountNewList = new List<Account>(); 
        if(accountNewList2!= null && accountNewList2.size() >0)
        {
            for(Account aTH : accountNewList2)
            {
                if(aTH.MD__c == 'TH' && isAfter && isupdate)  
                {
                    accountNewList.add(aTH);
                    if(accountOldMap!=null && accountOldMap.size()>0)
                    {
                        Account oldAcc=(Account)accountOldMap.get(aTH.Id);
                        if(oldAcc!=null && oldAcc.UCID__c!=aTH.UCID__c)
                            changedUCIDaccountLst.add(aTH);
                    }
                    
                }
            }
        }
        //List<Account> accountNewList = Trigger.new;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0)
        {
            if(isBefore && isInsert){
               AccountHelperTH.updateAccountFieldsBeforeInsert(accountNewList,trigger.isInsert);
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
            if(isAfter && isupdate && !accountNewList.isEmpty() && accountNewList.size() > 0)
            {
                AccountHelperTH.DealerCommAccountlinkcreatecdm(accountNewList,(Map<Id,Account>)Trigger.OldMap);
				AccountHelperTH.updateRetailCopy(isUpdate, isInsert, isAfter, accountNewList);
                if(changedUCIDaccountLst!=null && !changedUCIDaccountLst.isEmpty() && changedUCIDaccountLst.size()>0)
                    AccountHelperTH.shareAccountMerge(changedUCIDaccountLst);
            }
        }

    }
}