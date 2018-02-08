public class TriggerAccountlinkHandlerMY implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        if (TriggerRecursiveCheck.AccountLinkCheck) {
           TriggerRecursiveCheck.AccountLinkRecursiveCheck();
           
    
            AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
       
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                    acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.MY,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                    acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                    acchelper.afterInsertEventShareAccount(Trigger.new);
                }
                if (Trigger.isInsert  && !System.isFuture()) {
                   acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.MY, Label.InsertContext);
                }
            }

            if (Trigger.isAfter && Trigger.isupdate && !System.isFuture()) {  
                if (TriggerRecursiveCheck.run2 ) {
                    TriggerRecursiveCheck.runOnce2();
                    acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.MY, Label.UpdateContext);                    
                }
                if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){ 
                    acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
                }
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