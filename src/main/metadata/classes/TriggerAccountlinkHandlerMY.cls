public class TriggerAccountlinkHandlerMY implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
     
        AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
      
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
          
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){ 
              acchelper.ValidateC2CAfterUpdateInsert(trigger.new);
            }
          
        }

      
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].MD__c == Label.MY){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperMY acchelper = new AccountlinkhelperMY();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new);
               }
               
           }
         
    }
}