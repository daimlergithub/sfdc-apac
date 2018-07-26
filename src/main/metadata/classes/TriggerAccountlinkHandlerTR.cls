public class TriggerAccountlinkHandlerTR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
     
        AccountlinkhelperTR acchelper = new AccountlinkhelperTR();
      
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
          
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){ 
              acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.TR,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
             
            }
            
          
        }
        if (Trigger.isBefore && (Trigger.isupdate || Trigger.isInsert)) {
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){ 
               // AccountlinkhelperTR.updateOnPostalOptout(trigger.new);  
               // AccountlinkhelperTR.updateOnEmailOptout(trigger.new);                 
                //AccountlinkhelperTR.updateOnPhoneSMSoptout(trigger.new);
            }
        }
        

      
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].Market__c == Label.TR){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperTR acchelper = new AccountlinkhelperTR();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.TR,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
                  // AccountlinkhelperTR.updateOnPostalOptout(trigger.new); 
                   //AccountlinkhelperTR.updateOnEmailOptout(trigger.new);                
               //    AccountlinkhelperTR.updateOnPhoneSMSoptout(trigger.new);
               }
               
           }
         
    }
}