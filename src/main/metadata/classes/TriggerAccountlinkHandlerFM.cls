public class TriggerAccountlinkHandlerFM implements TriggerHandlerIf {

    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
      
            AccountlinkhelperFM acchelper = new AccountlinkhelperFM();
        	User loggedInUser=Utility_FM.getLoggedInUserInfo();
        
			 if (Trigger.isbefore && Trigger.isinsert ) {               
			      acchelper.updateFoundationMonth(trigger.new, Trigger.isinsert,Trigger.isupdate);
                
            }
			 if (Trigger.isbefore && Trigger.isupdate ) {               
			      acchelper.updateFoundationMonth(trigger.new, Trigger.isinsert,Trigger.isupdate);
                 if(Util_GetPermissionList.checkAccessOnUser(Label.addressupdateRT)){  
                    acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);                  
                }
            }
			
            if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
                    acchelper.ValidateC2CAfterUpdateInsert(trigger.new, loggedInUser.Market__c,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                   
				   if(Trigger.isInsert){
				    if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){
						acchelper.afterInsertEventShareRetailCopy(Trigger.new);
						acchelper.afterInsertEventShareAccount(Trigger.new);
						}
					}
					
                }
                if (Trigger.isInsert  && !System.isFuture()) {
				if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                   acchelper.InvokeCDMAccountlinkContaxt(trigger.new, loggedInUser.Market__c, Label.InsertContext);
				   }
                }
            }

            if (Trigger.isAfter && Trigger.isupdate ) {  
                if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                    TriggerRecursiveCheck.runOnce2();
					 if(Util_GetPermissionList.checkAccessOnUser(Label.AccountLInkAL)){
                     acchelper.InvokeCDMAccountlinkContaxt(trigger.new, loggedInUser.Market__c, Label.UpdateContext); 
                    }					
                }
                if(Util_GetPermissionList.checkAccessOnUser(Label.FMRetail)){                    
                    acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
					acchelper.OnAfterUpdateCreateC2CRetailCopy(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap);
                }
            }
        
        //to call market specific trigger handler
        FMMarketTriggerFactory.run('Account Link', loggedInUser.Market__c, true, true, true, true, true);
       
    }
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
        // Implementation to addedd as required in market
         List<Account_Link__c> AccListNewList = Trigger.new;
         //added for FM markets
         String marketCodes=Label.HandleIntegrationTriggerFMCountries;
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && marketCodes.contains(AccListNewList[0].Market__c)){
				if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){
				   AccountlinkhelperFM acchelper = new AccountlinkhelperFM();
                   acchelper.updateFoundationMonth(trigger.new, Trigger.isinsert,Trigger.isupdate);
				   acchelper.RemoveAccessofUsers(trigger.new,AccListNewList[0].Market__c);
				}
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperFM acchelper = new AccountlinkhelperFM();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, AccListNewList[0].Market__c,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
               }
               
           }
    }
}