public class TriggerAccountlinkHandlerAU implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
      
            AccountlinkhelperAU acchelper = new AccountlinkhelperAU();
       if (Trigger.isbefore && Trigger.isupdate ) {               
                 if(Util_GetPermissionList.checkAccessOnUser(Label.addressupdateRT)){  
                    acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);                  
                }
            }
      
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
                    acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.AU,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                   
           if(Trigger.isInsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail)){
            acchelper.afterInsertEventShareRetailCopy(Trigger.new);
            acchelper.afterInsertEventShareAccount(Trigger.new);
            }
          }
          
                }
                if (Trigger.isInsert  && !System.isFuture()) {
        if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                   acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.AU, Label.InsertContext);
           }
                }
            }

            if (Trigger.isAfter && Trigger.isupdate ) {  
                if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                    TriggerRecursiveCheck.runOnce2();
           if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                    acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.AU, Label.UpdateContext); 
                    }          
                }
                if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail)){ 
                   
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
                }
            }
       
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.AU){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperAU acchelper = new AccountlinkhelperAU();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.AU,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
               }
               
           }
    }
}