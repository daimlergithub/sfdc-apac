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
        }

      
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.IN){
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