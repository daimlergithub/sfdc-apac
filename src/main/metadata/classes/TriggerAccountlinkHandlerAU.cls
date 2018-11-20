public class TriggerAccountlinkHandlerAU implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
      

            AccountlinkhelperAU acchelper = new AccountlinkhelperAU();
       if (Trigger.isbefore && Trigger.isupdate ) {               
                 if(Util_GetPermissionList.checkAccessOnUser(Label.addressupdateRT)){  
                    acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);                  
                }

			      if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail) || Util_GetPermissionList.checkAccessOnUser(Label.NZRetail)){ 
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
					acchelper.RevokeApexSharingBeforeUpdateDeleteFlag(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
                }
				
            }
      
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric) || Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric) ){
                { 
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.AU,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                   
				   if(Trigger.isupdate){
				      List<Account_Link__c> AccListNewList = Trigger.new;
						List<Account_Link__c> AccListOldList = Trigger.old;			
                  if(AccListNewList[0].Retail_Delete_Flag__c == false && AccListOldList[0].Retail_Delete_Flag__c == true)
                    {
                     acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                     acchelper.afterInsertEventShareAccount(Trigger.new);
                     }
					}					 
                } 		
           if(Trigger.isInsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.AURetail) || Util_GetPermissionList.checkAccessOnUser(Label.NZRetail)){
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

            }
			
			 
       
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
         List<Account_Link__c> AccListNewList = Trigger.new;
         
          //Added as part of MBANZ - 419 to remove access to deleted retail account  - deleted flag  is true 
          if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && (AccListNewList [0].MD__c == Label.AU || AccListNewList [0].MD__c == Label.NZ )){
          
                if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){
                   AccountlinkhelperAU acchelper = new AccountlinkhelperAU();
                   acchelper.RemoveAccessofUsers(trigger.new);
                }

         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && (AccListNewList [0].MD__c == Label.AU || AccListNewList [0].MD__c == Label.NZ )){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperAU acchelper = new AccountlinkhelperAU();
				   
				   //Added as part of Defect
				   acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                   acchelper.afterInsertEventShareAccount(Trigger.new);
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.AU,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
               }
               
           }
    }
}
}