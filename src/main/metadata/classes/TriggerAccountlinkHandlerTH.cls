public class TriggerAccountlinkHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        Set < ID > acclids = new Set < ID > ();
        List < Account_Link__c > acclinkr = [Select Id, toRole__r.UCID__c from Account_Link__c where id IN: trigger.new];
        for (Account_Link__c accrec: acclinkr) {
            if (accrec.toRole__r.UCID__c != '')
                acclids.add(accrec.id);
        }

        AccountLinkHelperTH acchelper = new AccountLinkHelperTH();
        /* Data Migration Explicit Fix - Santosh Mohanty */
        if (Trigger.isBefore && Trigger.isUpdate) {
            AccountLinkHelper.updatemarket(Trigger.New);
        }
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
            System.debug('hello');
            acchelper.afterInsertEventShareRetailCopy(Trigger.new);
            acchelper.afterInsertEventShareAccount(Trigger.new);
            if (Trigger.isInsert && acclids.size() > 0) {
                if (TriggerRecursiveCheck.run) {
                    TriggerRecursiveCheck.runOnce();
                    CDMInformatica_Services.createAccountLink(acclids, 'TH', 'insert');
                }
            }
        }

        if (Trigger.isAfter && Trigger.isupdate) {

            if (TriggerRecursiveCheck.run && acclids.size() > 0) {
                TriggerRecursiveCheck.runOnce();
                CDMInformatica_Services.createAccountLink(acclids, 'TH', 'update');
            }

            acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
        }
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
    }
}