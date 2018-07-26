/**
* Utility for Trigger on DM Request for TR(Turkey)
* Author: Hildaa
*/


public class DMRequestHelperTR {

    string market = System.Label.TR; 
    
    public void InsertDMRequest(List<DM_Request__c> triggerNew,boolean isInsert,string market){
            DMRequestHelperBase.InsertDMRequest(trigger.new,isInsert,market);    
    }
    
    public void UpdateDMRequest(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isUpdate,string market){
        DMRequestHelperBase.UpdateDMRequest(trigger.new,OldMap,isupdate,market);
    }
    
    public void shareDMRequestRecordsWithDealer(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,string market){
        DMRequestHelperBase.shareDMRequestRecordsWithDealer(trigger.new,OldMap,market);
    }
}