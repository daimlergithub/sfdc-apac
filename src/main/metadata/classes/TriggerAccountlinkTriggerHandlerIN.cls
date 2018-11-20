/**
* Handler for Trigger on Case for IN(India)
* Author:Namitha
* Created Date : 6th Mar 2018
* Utility for helperon Account_Link for IN(India)
* It will validate the duplicate
*/
public class TriggerAccountlinkTriggerHandlerIN implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
     
        AccountlinkHelperIN acchelper = new AccountlinkHelperIN();
     //   Util_getPermissions util_getP = new Util_getPermissions();
        //Start Namitha 08212018 Added to ensure parity with kernel functionality as per review.
        //Namitha 09032018 Added to prepopulate sales consultant as it is mandatory for eDealer.
        if (Trigger.isbefore && Trigger.isInsert && INTriggerRecursionCheck.updateSalesConsultant == false) { 
        INTriggerRecursionCheck.updateSalesConsultant = true;
            AccountlinkHelperIN.updateSalesConsultant(trigger.new); 
        }
        if (Trigger.isbefore && Trigger.isupdate ) {     
            if(Util_getPermissions.checkCustomPermission(Label.addressupdateRT) && INTriggerRecursionCheck.inAccLinkaddressupdateRT == false){  
                INTriggerRecursionCheck.inAccLinkaddressupdateRT = true;
                acchelper.addressupdateRT(trigger.new, (Map < Id, Account_Link__c > ) trigger.oldMap);                  
            }
        }
        if (Trigger.isAfter && Trigger.isupdate ) { 
            if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                TriggerRecursiveCheck.runOnce2();
                if(Util_getPermissions.checkCustomPermission(Label.AccountLInkAL)){
                acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.IN, Label.UpdateContext); 
                }                   
            }
			if(Util_getPermissions.checkCustomPermission(Label.INRetail) && INTriggerRecursionCheck.inAccLinkrevokesharing == false) 
			{                    
				INTriggerRecursionCheck.inAccLinkrevokesharing = true;
                acchelper.RevokeApexSharingAfterUpdate(Trigger.new, (Map < Id, Account_Link__c > ) Trigger.oldmap, Trigger.Old);
			}
        }
         //Ends Namitha 08212018.

        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
          
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric) && INTriggerRecursionCheck.inAccLinkvalC2C == false){ 
                INTriggerRecursionCheck.inAccLinkvalC2C = true;
                acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.IN,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
            }
            //Start 07042018 : Namitha added to invoke share retailcopy and Account as part of ph2.
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric) && INTriggerRecursionCheck.inAccLinkshareretailCopy == false){
                INTriggerRecursionCheck.inAccLinkshareretailCopy = true;
                acchelper.afterInsertEventShareRetailCopy(trigger.new);
            }
            if(Util_getPermissions.checkCustomPermission(Label.INGeneric) && INTriggerRecursionCheck.inAccLinkshareAccount == false){
                INTriggerRecursionCheck.inAccLinkshareAccount = true;
                acchelper.afterInsertEventShareAccount(trigger.new);
            }
            //ends
            if (Trigger.isInsert && TriggerRecursiveCheck.run2 && !System.isFuture()) {
			TriggerRecursiveCheck.runOnce2();
                if(Util_getPermissions.checkCustomPermission(Label.AccountLInkAL)){
					acchelper.InvokeCDMAccountlinkContaxt(trigger.new, Label.IN, Label.InsertContext);
                }
            }
        }
        //Call logic to share C2C record with dealers who have access to the accounts involved
        if (Trigger.isInsert && Trigger.isAfter){
            if(INTriggerRecursionCheck.OnAfterUpdateCreateC2CRetailCopy == false) 
            {                       
                INTriggerRecursionCheck.OnAfterUpdateCreateC2CRetailCopy = true;
                acchelper.ShareC2CRecord(Trigger.new);
            }
        }
      
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.IN){
           //Start Namitha 08212018 Added to ensure parity with kernel functionality as per review.
                if((trigger.isupdate || trigger.isinsert) && trigger.isbefore && INTriggerRecursionCheck.RemoveAccessofUsers == false){
				INTriggerRecursionCheck.RemoveAccessofUsers = true;
                   AccountlinkhelperIN acchelper = new AccountlinkhelperIN();
                   acchelper.RemoveAccessofUsers(trigger.new);
                }
                //ends 08212018
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkHelperIN acchelper = new AccountlinkHelperIN();
                   if (INTriggerRecursionCheck.inAccLinkvalC2C == false){
                       INTriggerRecursionCheck.inAccLinkvalC2C = true;
                       acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.IN,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);                       
                   }

               }
               
           }
         
    }
}