/*
Type:       Trigger Handler
Purpose:    Update Address fields of DMRequest on Address type pickilist of DM request 
Author:     Prem Kumar
Date:       11/07/2018
*/
public class TriggerDMRequestTriggerHandlerIN implements TriggerHandlerIf {
    string market = System.Label.MarketIN;
    DMRequestHelperIN dmobj = new DMRequestHelperIN();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.INGeneric)){
            if(Trigger.isBefore && Trigger.isInsert){
                dmobj.InsertDMRequest(trigger.new,isInsert,market);         
            }
            if (Trigger.isBefore && Trigger.isUpdate){ 
                dmobj.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
            }
            if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){ 
                if(Util_GetPermissionList.checkAccessOnUser(Label.INRetail)){
                    dmobj.shareDMRequestRecordsWithDealer(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,market);      
                }
            }
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<DM_Request__c> dmrequestNewList = trigger.new;
        if(dmrequestNewList[0].MD__c==Label.IN){
            if(Trigger.isBefore && Trigger.isInsert){
                dmobj.InsertDMRequest(dmrequestNewList,isInsert,market);
            }
            if (Trigger.isBefore && Trigger.isUpdate){ 
                dmobj.UpdateDMRequest(dmrequestNewList,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
            }
        }
    }
}