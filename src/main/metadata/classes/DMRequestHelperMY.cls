/**
* Utility for Trigger on DM Request for MY(Malaysia)
* Author: Sushma
* Created Date : 10th Oct 2017
*/

//SB2017
public class DMRequestHelperMY {

    string market = System.Label.MarketMY; 
    
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