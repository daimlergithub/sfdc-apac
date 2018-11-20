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
	public static boolean firstRun = true;
	Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();	
 private static  final User assigneduser=[select id,Market__c,profile.name,Profile.UserLicense.Name,ContactId,Contact.Accountid,Username from User where id =:Userinfo.getUserId()];
   	
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
    {	//SN20180723- CDM Release 2
		Boolean jpSwitchEnabledFlag = false;
		Boolean CDMCustomerCreation = false;
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Disable UCID Creation')){
            jpSwitchEnabledFlag = jpSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
        }
	    if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('CDM Customer Creation and Update')){
            CDMCustomerCreation = jpSwitchMap.get('CDM Customer Creation and Update').Enable_Flag__c;
        }		
       
        if(isBefore && isInsert )
        {
            system.debug('Entered before insert TRIGGER');
            AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,trigger.isInsert);
            AccountHelperJP.updatePrimaryContactInformationBeforeInsert(Trigger.new,trigger.isInsert);
            AccountHelperJP.updateCompanyAccountNameBeforeInsert(Trigger.new,Trigger.isInsert,trigger.isupdate);
        }
        if(isBefore && isUpdate)
        {
            /* Data Update MD Fix - Santosh Mohanty*/
            AccountHelperTH.updatemarket(Trigger.New);
            system.debug('Entered before update TRIGGER');
            AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.updatePrimaryContactInformationBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.updateCompanyAccountNameBeforeInsert(Trigger.new,Trigger.isInsert,trigger.isupdate);
            AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
            AccountHelperJP.ChangeSoftDeletedRecordsOwner(Trigger.new);
            AccountHelperJP.ChangePublicGroupName((Map<Id,Account>)Trigger.OldMap,Trigger.New);
        }
        if(isAfter && isInsert && !System.isFuture())
        {
           // User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
            system.debug('Entered aFTER insert TRIGGER');
            serializedObject=json.serialize(ListAccNew);
            //AccountHelperJP.createUCID(Trigger.new,trigger.isInsert);
			//SN20180723- CDM Release 2 added condition
			if(!jpSwitchEnabledFlag){
                AccountHelperJP.createUCID(Trigger.new,trigger.isInsert);
            }
			else if(jpSwitchEnabledFlag){
                        AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
            }							 
            AccountHelperJP.CreateRetailCopy(trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');  
			//SN20180723- CDM Release 2 added condition			
			if(!CDMCustomerCreation){			
				AccountHelperJP.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
			}
			else{
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AccountHelperBase.createUpdateCDMUCID(label.InsertContext,Label.JP,Trigger.new);
				}
			}
        } 
        if(isAfter && isUpdate && !System.isFuture() && System.IsBatch() == false)
        {
            serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
			//SN20180723- CDM Release 2 added condition
			if(!CDMCustomerCreation){
				AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
			}
			else{
				 if(TriggerRecursiveCheck.run){
                     TriggerRecursiveCheck.runOnce();
                     AccountHelperBase.createUpdateCDMUCID(Label.UpdateContext,Label.JP,Trigger.new);
                     firstRun=false;
               }
			}
            AccountHelperJP.CreateRetailCopy(trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            if(LeadUtil.accountTrigger)
            {
                LeadUtil.vrTrigger = false;
                AccountHelperJP.UpdateVRonAccount(trigger.new,(Map<Id,Account>)Trigger.OldMap);
            }
             AccountHelperJP.deletesharingforSoftDeletedRecords(trigger.new);
        }
        
        if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
			//SN20180723- CDM Release 2 added condition
			if(!CDMCustomerCreation){
				AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);			
			}
			else{
				 if(TriggerRecursiveCheck.run){
						TriggerRecursiveCheck.runOnce();
						AccountHelperBase.createUpdateCDMUCID('Delete',Label.JP,Trigger.old);
						firstRun=false;
					}
				}
			}
     }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<Account> accountNewList = Trigger.new;
		String usrName=assigneduser.Username; 
		
        if(!isDelete && !accountNewList.isEmpty() && accountNewList.size() > 0 && accountNewList[0].MD__c == 'JP')
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
                //Added below method for updating account fields by Informatica JP-Yanase-2018-06-21 -Reetesh
				AccountHelperJP.updateAccountFieldsBeforeUpdateByInformatica(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
                AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
                AccountHelperJP.ChangeSoftDeletedRecordsOwner(Trigger.new);
                AccountHelperJP.ChangePublicGroupName((Map<Id,Account>)Trigger.OldMap,Trigger.New);
								
			}			
			if(isafter && isinsert){
				Boolean jpSwitchEnabledFlag = false;
				if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Disable UCID Creation')){
					jpSwitchEnabledFlag = jpSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
				}
				
				if(jpSwitchEnabledFlag){
						AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
				}
			}
			// Added by venky on 2018/08/22 , As per ogi request added below logic to call entityNotifyUpdate method in informatica user.
			if(usrName.contains(Label.InfomraticaUserLabel))
            {
             if(isAfter && isInsert && !System.isFuture())
             {
             serializedObject=json.serialize(ListAccNew);
             serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');            
            AccountHelperJP.entityNotifyUpdate('INSERT',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
             }
            }
			
			if(isafter && isupdate){
				//SN20180723- CDM Release 2 added condition
				Boolean CDMRCCreation = false;	
				Boolean jpSwitchEnabledFlag = false;
				if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Disable UCID Creation')){
					jpSwitchEnabledFlag = jpSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
				}
				if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('CDM RC Creation and Update')){
					CDMRCCreation = jpSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
				}
				if(jpSwitchEnabledFlag){
						AccountHelperbase.createAccountLinkExtLinkRecordAfterUCIDGeneration(trigger.New, (Map<Id,Account>)trigger.OldMap, trigger.isUpdate,trigger.isInsert);
				}
                if(CDMRCCreation){
					AccountHelperBase.DealerCommAccountlinkcreatecdm(accountNewList,(Map<Id,Account>)Trigger.OldMap,accountNewList[0].md__c);					
				}
			
			}
			
            if(isAfter && isUpdate && !System.isFuture())
            {   
                if(LeadUtil.accountTrigger)
                {
                    AccountHelperJP.UpdateVRonAccount(trigger.new,(Map<Id,Account>)Trigger.OldMap);
                    LeadUtil.vrTrigger = false;
                }
                AccountHelperJP.deletesharingforSoftDeletedRecords(trigger.new);
					// Added by venky on 2018/08/22 , As per ogi request added below logic to call entityNotifyUpdate method in informatica user.
				 if(usrName.contains(Label.InfomraticaUserLabel))
               {
                serializedObject=json.serialize(ListAccNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('UPDATE',ListAccNew[0].Id,ListAccNew[0].MD__c,serializedObject);
			//Commented on 10/09/2018 testing is not completed
			// AccountHelperJP.CreateRetailCopy(trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            }
            }
        }
			// Added by venky on 2018/08/22 , As per ogi request added below logic to call entityNotifyUpdate method in informatica user.
		if(usrName.contains(Label.InfomraticaUserLabel))
         {
         if(isAfter && isDelete && !System.isFuture())
        {
            serializedObject=json.serialize(ListAccOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AccountHelperJP.entityNotifyUpdate('DELETE',ListAccOld[0].Id,ListAccNew[0].MD__c,serializedObject);
			//Commented on 10/09/2018 testing is not completed
			//AccountHelperJP.CreateRetailCopy(trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            
        }
         }
    }
}
