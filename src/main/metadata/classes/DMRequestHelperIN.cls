/**
* Utility for Trigger on DM Request for IN(India)
* Author: Prem Kumar
* Created Date : 11/07/2018
*/

//SB2017
public class DMRequestHelperIN {

    string market = System.Label.MarketIN; 
    
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