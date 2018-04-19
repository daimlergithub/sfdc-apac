public class TriggerAccountlinkHandlerMY implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
      
            AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
			 if (Trigger.isbefore && Trigger.isupdate ) {               
                 if(Util_GetPermissionList.checkAccessOnUser(Label.addressupdateRT)){  
                    acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);                  
                }
            }
			
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                    acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.MY,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                   
				   if(Trigger.isInsert){
				    if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){
						acchelper.afterInsertEventShareRetailCopy(Trigger.new);
						acchelper.afterInsertEventShareAccount(Trigger.new);
						}
					}
					
                }
                if (Trigger.isInsert  && !System.isFuture()) {
				if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                   acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.MY, Label.InsertContext);
				   }
                }
            }

            if (Trigger.isAfter && Trigger.isupdate ) {  
                if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                    TriggerRecursiveCheck.runOnce2();
					 if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                    acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.MY, Label.UpdateContext); 
                    }					
                }
                if(Util_GetPermissionList.checkAccessOnUser(Label.MYRetail)){                    
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
					acchelper.OnAfterUpdateCreateC2CRetailCopy(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap);
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