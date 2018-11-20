public class TriggerAccountlinkHandlerTR implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
     
        AccountlinkhelperTR acchelper = new AccountlinkhelperTR();
         User currUserAlias = [SELECT Id, Name,alias FROM user WHERE Id=:userinfo.getuserId() LIMIT 1];
      
        if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
          
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){ 
              acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.TR,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
             
            }
			if(Trigger.isInsert){
               
                acchelper.afterInsertEventShareRetailCopy(Trigger.new);
                acchelper.afterInsertEventShareAccount(Trigger.new);
             
              }
            
          
        }
         if (Trigger.isBefore && Trigger.isInsert && currUserAlias.alias == Label.FormAssembly) {
            acchelper.updateretailcopy(Trigger.New);
        }

        if(Trigger.isBefore && (Trigger.isupdate || Trigger.isInsert)){
            acchelper.updateEmailField(Trigger.New,(Map<Id,Account_link__C>)trigger.oldMap,Trigger.isupdate);
        }
        if (Trigger.isAfter && Trigger.isupdate) {
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){ 
                acchelper.updateRetailDOCforDealers(Trigger.New,(Map<Id,Account_link__C>)trigger.oldMap);
            }
        }
       
    }
    
    public void handleIntegrationTrigger(boolean isInsert, boolean isUpdate, boolean isBefore, boolean isDelete, boolean isAfter) {
         List<Account_Link__c> AccListNewList = Trigger.new;
         
           if( !trigger.isdelete && !AccListNewList.isEmpty() && AccListNewList.size() > 0 && AccListNewList [0].Market__c == Label.TR){
               if (Trigger.isAfter && (Trigger.isupdate || Trigger.isInsert)) {
                   AccountlinkhelperTR acchelper = new AccountlinkhelperTR();
                   acchelper.ValidateC2CAfterUpdateInsert(trigger.new, Label.TR,Trigger.isinsert,Trigger.isupdate,trigger.oldMap);
				   if(Trigger.isInsert)
                   acchelper.afterInsertEventShareRetailCopy(Trigger.new);
				   acchelper.afterInsertEventShareAccount(Trigger.new);
                  // AccountlinkhelperTR.updateOnPostalOptout(trigger.new); 
                   //AccountlinkhelperTR.updateOnEmailOptout(trigger.new);                
               //    AccountlinkhelperTR.updateOnPhoneSMSoptout(trigger.new);
               }
               
           }
         
    }
}