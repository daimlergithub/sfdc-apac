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
            acchelper.ValidateC2CAfterUpdateInsert(trigger.new,'TH',Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
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
        List<Account_link__c> accLink2NewList = Trigger.new;
        List<Account_link__c> accLinkNewList = new List<Account_link__c>();
        List<Account_link__c> accLink2OldList = Trigger.old;
        List<Account_link__c> accLinkOldList = new List<Account_link__c>();
        if(accLink2NewList!=null && accLink2NewList.size()>0)
        {
            for(Account_link__c alNew: accLink2NewList){
                if(alNew.MD__c == 'TH' || alNew.Market__c == 'TH'){
                    accLinkNewList.add(alNew);
                }
            }
        }
        if(accLink2OldList!=null && accLink2OldList.size()>0)
        {
            for(Account_link__c alOld: accLink2OldList){
                if(alOld.MD__c == 'TH' || alOld.Market__c == 'TH'){
                    accLinkOldList.add(alOld);
                }
            }
        }
        
        Map<Id,SObject> accountlnkOldMap= Trigger.oldMap;
        if(!isDelete && accLinkNewList != null && accLinkNewList.size() > 0){
            //if(accLinkNewList != null && accLinkNewList.size() > 0 && accLinkNewList[0].MD__c == 'TH'){
            AccountLinkHelperTH acchelper = new AccountLinkHelperTH();
            
            if (Trigger.isBefore && (Trigger.isUpdate||Trigger.isInsert)) {
                system.debug('ddddddddd');
                acchelper.updateActiveStatusBeforeInser(accLinkNewList,Trigger.isinsert,Trigger.isUpdate,true);
            }
            if (Trigger.isAfter && Trigger.isupdate) {
                TriggerRecursiveCheck.AccountLinkRecursiveCheck();
                Map < Id, Account_Link__c > oldmap = (Map < Id, Account_Link__c > ) Trigger.oldmap;
                AccountlinkhelperTH.addressupdateRT(accLinkNewList, oldmap);
            }
                Set < ID > acclids = new Set < ID > ();
                Set < ID > acclidUpds = new Set < ID > ();
                String fsAccountLinkRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get(UtilConstant.FS_Account_Link).getRecordTypeId();
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                acchelper.ValidateC2CAfterUpdateInsert(accLinkNewList,'TH',Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                acchelper.afterInsertEventShareRetailCopy(accLinkNewList);
                acchelper.afterInsertEventShareAccount(accLinkNewList);
                //Added below code for Calling Informatica service for Integration user By Ashish Jadhav 23 july, 2018
                List < Account_Link__c > acclinkr = [Select Id,recordtypeID, toRole__r.UCID__c,toRole__r.StouchUniqueId__c,Retail_DMS_Customer_ID__c from Account_Link__c where id IN: accLinkNewList AND fromRole__r.Dealer_Rollout_Status__c = 'Done'];
                for (Account_Link__c accrec: acclinkr) {
                    //condition added by Tejbir. FS account link should not to go to autoline.
                    if (String.isnotblank(accrec.toRole__r.UCID__c) && accrec.RecordTypeId != fsAccountLinkRecordTypeId && String.isnotblank(accrec.toRole__r.StouchUniqueId__c)){
                        acclids.add(accrec.id);
                        if (Trigger.isUpdate && (Trigger.oldMap.get(accrec.id) != null)){
                            Account_Link__c acl = (Account_Link__c)Trigger.oldMap.get(accrec.id);
                            if (accrec.Retail_DMS_Customer_ID__c == acl.Retail_DMS_Customer_ID__c)
                                acclidUpds.add(accrec.id);
                        }
                    }
                }
                if (Trigger.isInsert && acclids.size() > 0) {
                    if (TriggerRecursiveCheck.run) {
                        TriggerRecursiveCheck.runOnce();
                        CDMInformatica_Services.createAccountLink(acclids, 'TH', 'insert');
                    }
                }

                if(Trigger.isUpdate){
                    AccountLinkHelperTH.accesschange(accLinkNewList,accountlnkOldMap);
                    if(accLinkOldList != null && accLinkOldList.size() > 0)
                        acchelper.RevokeApexSharingAfterUpdate(accLinkNewList, (Map < Id, Account_Link__c > ) Trigger.oldmap, accLinkOldList);
                    //Rajesh Added below to ensure retail copy updates also flow to DMS when received via Stouch
                    if (TriggerRecursiveCheck.run2 && acclidUpds.size() > 0) {
                        TriggerRecursiveCheck.runOnce2();
                        system.debug('Update:call_CDM_service'+acclidUpds);
                        CDMInformatica_Services.createAccountLink(acclidUpds, 'TH', 'update');
                    }
                }
                acchelper.revokeAccLinkSharingDuplicateFlag(accLinkNewList,(Map<Id,Account_Link__c>) trigger.oldMap,Trigger.IsInsert,Trigger.IsUpdate);
            }    
        }       
    }
}