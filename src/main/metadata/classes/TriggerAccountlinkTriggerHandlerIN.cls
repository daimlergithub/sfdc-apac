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
        Util_getPermissions util_getP = new Util_getPermissions();
        
        
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
          
            if(util_getP.checkCustomPermission(Label.INGeneric)){ 
              acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.IN,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
            
            }
          
        }

      
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.IN){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkHelperIN acchelper = new AccountlinkHelperIN();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.IN,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
               }
               
           }
         
    }
}