public class TriggerAccountlinkHandlerMY implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
       Set < ID > acclids = new Set < ID > ();
        List < Account_Link__c > acclinkr = [Select Id, toRole__r.UCID__c from Account_Link__c where id IN: trigger.new];
        for (Account_Link__c accrec: acclinkr) {
            if (String.isnotblank(accrec.toRole__r.UCID__c))
                acclids.add(accrec.id);
        }

        AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
       
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.MY,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                acchelper.afterInsertEventShareAccount(Trigger.new);
            }
            if (Trigger.isInsert && acclids.size() > 0) {
                if (TriggerRecursiveCheck.run) {
                    TriggerRecursiveCheck.runOnce();
                    CDMInformatica_Services.createAccountLink(acclids, Label.MY, Label.InsertContext);
                }
            }
        }

        if (Trigger.isAfter && Trigger.isupdate) {

            if (TriggerRecursiveCheck.run2 && acclids.size() > 0) {
                TriggerRecursiveCheck.runOnce2();
                CDMInformatica_Services.createAccountLink(acclids, Label.MY, Label.UpdateContext);
            }
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){ 
                acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
            }
        }
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.MY){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.MY,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
               }
               
           }
    }
}