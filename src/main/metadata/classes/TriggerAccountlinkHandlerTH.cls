public class TriggerAccountlinkHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        Set < ID > acclids = new Set < ID > ();
        
        AccountLinkHelperTH acchelper = new AccountLinkHelperTH();
        /* Data Migration Explicit Fix - Santosh Mohanty */
        if (Trigger.isBefore && Trigger.isUpdate) {
            AccountLinkHelper.updatemarket(Trigger.New);
            acchelper.updateActiveStatusBeforeInser(Trigger.New,Trigger.isinsert,Trigger.isUpdate,false);
        }
        if (Trigger.isBefore && Trigger.isinsert) {
            acchelper.updateActiveStatusBeforeInser(Trigger.New,Trigger.isinsert,Trigger.isUpdate,false);
        }
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
            System.debug('check if went inside');
            List < Account_Link__c > acclinkr = [Select Id,recordtypeID, toRole__r.UCID__c from Account_Link__c where id IN: trigger.new AND fromRole__r.Dealer_Rollout_Status__c = 'Done'];
            for (Account_Link__c accrec: acclinkr) {
                //condition added by Tejbir. FS account link should not to go to autoline.
                if (String.isnotblank(accrec.toRole__r.UCID__c) && accrec.RecordTypeId!=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilConstant.FS_Account_Link).getRecordTypeId())
                    acclids.add(accrec.id);
            }
            
            
            acchelper.afterInsertEventShareRetailCopy(Trigger.new);
            acchelper.afterInsertEventShareAccount(Trigger.new);
            if (Trigger.isInsert && acclids.size() > 0) {
                if (TriggerRecursiveCheck.run) {
                    TriggerRecursiveCheck.runOnce();
                    CDMInformatica_Services.createAccountLink(acclids, 'TH', 'insert');
                }
            }
            
            if (Trigger.isupdate) {
                if (TriggerRecursiveCheck.AccountLinkCheck ) 
                {
                    TriggerRecursiveCheck.AccountLinkRecursiveCheck();
                    Map < Id, Account_Link__c > oldmap = (Map < Id, Account_Link__c > ) Trigger.oldmap;
                    AccountlinkhelperTH.ExportNotificationTH(Trigger.new, oldmap);
                    AccountlinkhelperTH.addressupdateRT(Trigger.new, oldmap);
                    if (TriggerRecursiveCheck.run2 && acclids.size() > 0) {
                        TriggerRecursiveCheck.runOnce2();
                        CDMInformatica_Services.createAccountLink(acclids, 'TH', 'update');
                    }
                    
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
                }
            }
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
        // addedd as per SFDCTH-727
        List<Account_link__c> accountNewList = Trigger.new;
		
        Map<Id,SObject> accountlnkOldMap= Trigger.oldMap;
        if(!isDelete){
            if(accountNewList != null && accountNewList.size() > 0 && accountNewList[0].MD__c == 'TH'){
                AccountLinkHelperTH acchelper = new AccountLinkHelperTH();
                
                if (Trigger.isBefore && (Trigger.isUpdate||Trigger.isInsert)) {
                    system.debug('ddddddddd');
                    acchelper.updateActiveStatusBeforeInser(Trigger.New,Trigger.isinsert,Trigger.isUpdate,true);
                }
                if (Trigger.isAfter && Trigger.isupdate) {
                    TriggerRecursiveCheck.AccountLinkRecursiveCheck();
                    Map < Id, Account_Link__c > oldmap = (Map < Id, Account_Link__c > ) Trigger.oldmap;
                    AccountlinkhelperTH.addressupdateRT(Trigger.new, oldmap);
                }
                    Set < ID > acclids = new Set < ID > ();
                    String fsAccountLinkRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilConstant.FS_Account_Link).getRecordTypeId();
                if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                    acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                    acchelper.afterInsertEventShareAccount(Trigger.new);
					//Added below code for Calling Informatica service for Integration user By Ashish Jadhav 23 july, 2018
					List < Account_Link__c > acclinkr = [Select Id,recordtypeID, toRole__r.UCID__c,toRole__r.StouchUniqueId__c from Account_Link__c where id IN: trigger.new AND fromRole__r.Dealer_Rollout_Status__c = 'Done'];
					for (Account_Link__c accrec: acclinkr) {
						//condition added by Tejbir. FS account link should not to go to autoline.
						if (String.isnotblank(accrec.toRole__r.UCID__c) && accrec.RecordTypeId != fsAccountLinkRecordTypeId && String.isnotblank(accrec.toRole__r.StouchUniqueId__c))
							acclids.add(accrec.id);
					}
					if (Trigger.isInsert && acclids.size() > 0) {
						if (TriggerRecursiveCheck.run) {
							TriggerRecursiveCheck.runOnce();
							CDMInformatica_Services.createAccountLink(acclids, 'TH', 'insert');
						}
					}

                    if(Trigger.isUpdate){
						
                        AccountLinkHelperTH.accesschange(accountNewList,accountlnkOldMap);
                        acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
                        //Rajesh 07/23/2018 Commented out CDM call for update to prevent infinite loop between SFDC -> IC and IC -> SFDC
						/*if (TriggerRecursiveCheck.run2 && acclids.size() > 0) {
							TriggerRecursiveCheck.runOnce2();
							system.debug('Update:call_CDM_service'+acclids);
							CDMInformatica_Services.createAccountLink(acclids, 'TH', 'update');
						}*/
                    }
                }
            }
            
        }       
    }
}