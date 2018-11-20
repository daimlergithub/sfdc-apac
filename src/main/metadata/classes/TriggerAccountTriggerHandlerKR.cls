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
    list<Account> ListAccOld = (list<Account>)trigger.old;
    list<Account> ListAccNew = (list<Account>)trigger.new;
    string serializedObject;
    public static boolean firstRun = true;
    Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
	public static boolean preventRecurssion= false;
    public static boolean preventRecurssionafter= false;
    public static boolean preventRecurssionaftersahring= false;
    public static boolean preventRecurssionupdateRetail= false;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter){
    
        // Switch functionality for Disabling UCID creation
    	Boolean KRSwitchEnabledFlag = false;
    	Boolean CDMCustomerCreation = false;
        if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
            KRSwitchEnabledFlag = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
        }
        // Switch functionality for CDM customer Creation if CDM is enabled
      	if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CDM Customer Creation and Update')){
            CDMCustomerCreation = KRSwitchMap.get('CDM Customer Creation and Update').Enable_Flag__c;
        }
        if(isBefore && isInsert){
            AccountHelperKR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
         }
        
        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
            AccountHelperTH.updatemarket(Trigger.New);
            AccountHelperKR.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
            
            AccounthelperKR.updateOnDoNotCall(Trigger.new);
            if(preventRecurssion == false){
			AccounthelperKR.updateVehicleCustomerCheckStatus(Trigger.new);
			}
            AccountHelperKR.updateOnPostalOptout(Trigger.new);
            system.debug('@@@@@@ listNewAccounts update trigger');
            AccountHelperKR.updateAllowDataShareBasedonDocFields(Trigger.new);
            AccountHelperKR.updateOnEmailOptout(Trigger.new);
            AccountHelperKR.updateAgeRange(Trigger.new);
        }
        //New Code Block Added on 9/21/2016
        if(isAfter && isInsert && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            // Creation of UCID when CDM is disabled
            if(!KRSwitchEnabledFlag){
            AccountHelperJP.createUCID(Trigger.new,trigger.isInsert);
            }
            else if(KRSwitchEnabledFlag){
                AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
            }
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            // Added if CDM enabled
            if(!CDMCustomerCreation){
            AccountHelperJP.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
            }
            else{
                if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AccountHelperBase.createUpdateCDMUCID(label.InsertContext,'KR',Trigger.new);
				}
            }
            //Creating Retailcopy from dealer #SFDCKR-696 && #SFDCKR-1073
            if(preventRecurssionafter==false){
			AccountHelperKR.CreateRetailCopy(Trigger.new,trigger.isInsert,trigger.isUpdate);
            }
			system.debug('createSharingRecord :');
            //#SFDCKR-1015
            if(preventRecurssionaftersahring==false){
			AccountHelperKR.createSharingRecord ((Map<Id,Account>)Trigger.NewMap);
			}
            
            
        } 
        if(isAfter && isUpdate && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            // Added if CDM is enabled
             if(!CDMCustomerCreation){
            AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
             }
            else{
                if(TriggerRecursiveCheck.run){
                     TriggerRecursiveCheck.runOnce();
                     AccountHelperBase.createUpdateCDMUCID(Label.updateContext,'KR',Trigger.new);
                     firstRun=false;
               }
            }
            //#SFDCKR-846
			if(preventRecurssionupdateRetail==false){
            AccountHelperKR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isafter,trigger.new,(Map<Id,Account>)Trigger.OldMap); 
            }
			AccountHelperJP.deletesharingforSoftDeletedRecords(trigger.new);
            
        }
        
        if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            // Added if CDM is enabled
            if(!CDMCustomerCreation){
            AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
        }
	else{
                if(TriggerRecursiveCheck.run){
            	TriggerRecursiveCheck.runOnce();
            	AccountHelperBase.createUpdateCDMUCID('Delete','KR',Trigger.old);
            	firstRun=false;
          }
            }
        //End of the New code Block 9/21/2016
        //MBK Message Send Manage 6/26/2018
        if(isAfter){
            Map<Id,Account> dummMap = new Map<Id,Account>();
            if(isInsert) AccountHelperKR.MessageSendManage(Trigger.new, dummMap, 'Insert');
            if(isUpdate) AccountHelperKR.MessageSendManage(Trigger.new, (Map<Id,Account>)Trigger.OldMap, 'Update');
        }        
    }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<Account> accountNewList = Trigger.new;
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && accountNewList[0].MD__c == 'KR')
        {

           if(isBefore && isInsert)
            {
                AccountHelperKR.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
            }
            
            if(isBefore && isUpdate)
            {
                AccountHelperKR.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,Trigger.isUpdate);
                
                AccounthelperKR.updateOnDoNotCall(Trigger.new);
                AccountHelperKR.updateOnPostalOptout(Trigger.new);
                AccountHelperKR.updateAllowDataShareBasedonDocFields(Trigger.new);
                AccountHelperKR.updateOnEmailOptout(Trigger.new);
                AccountHelperKR.updateAgeRange(Trigger.new);
                AccountHelperJP.ChangeSoftDeletedRecordsOwner(Trigger.new);
            }
            if(isAfter && isInsert && !System.isFuture())
            {
            //SFDCKR-1207 as per SFDCKR-1721 moved it to Integration user
            AccountHelperKR.shareDealeroutletsWithDealerCompany(trigger.new);
           
            // Added for CDM Switch
           
                Boolean KRSwitchEnableFlag = false;
				if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
					KRSwitchEnableFlag = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
				}
				
				if(KRSwitchEnableFlag){
						AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
				}    
			}
            if(isAfter && isUpdate && !System.isFuture())
            {
            AccountHelperJP.deletesharingforSoftDeletedRecords(trigger.new);
            
            
            //MBK Message Send Manage 6/26/2018
            if(isAfter){
                Map<Id,Account> dummMap = new Map<Id,Account>();
				if(isInsert) AccountHelperKR.MessageSendManage(Trigger.new, dummMap, 'Insert');
				if(isUpdate) AccountHelperKR.MessageSendManage(Trigger.new, (Map<Id,Account>)Trigger.OldMap, 'Update');
            }
// Added for Switch
          
				Boolean CDMRCCreation = false;	
				Boolean KRSwitchFlag = false;
				if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
					KRSwitchFlag = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
				}
				if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CDM RC Creation and Update')){
					CDMRCCreation = KRSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
				}
				if(KRSwitchFlag){
						AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
				}
                if(CDMRCCreation){
					AccountHelperBase.DealerCommAccountlinkcreatecdm(accountNewList,(Map<Id,Account>)Trigger.OldMap,accountNewList[0].md__c);					
				}
			
			}  
        }
    }
}