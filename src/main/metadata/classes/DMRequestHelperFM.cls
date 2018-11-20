public class DMRequestHelperFM {
     
   public void InsertDMRequest(List<DM_Request__c> triggerNew,boolean isInsert,string market){
        
            DMRequestHelperBase.InsertDMRequest(trigger.new,isInsert,market); 
        
         
    }
    
    public void UpdateDMRequest(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isUpdate,string market){
        try{
        DMRequestHelperBase.UpdateDMRequest(trigger.new,OldMap,isupdate,market);
        }
         catch(DMLException ex){CustomLogUtil.DebugException(ex);}
        CustomLogUtil.DebugLogInsert();
    }
    
    public void shareDMRequestRecordsWithDealer(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,string market){
        try{
        DMRequestHelperBase.shareDMRequestRecordsWithDealer(trigger.new,OldMap,market);
        }
         catch(DMLException ex){CustomLogUtil.DebugException(ex);}
        CustomLogUtil.DebugLogInsert();
    }
  }