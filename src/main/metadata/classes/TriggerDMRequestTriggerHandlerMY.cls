/*
    Type:       Trigger
    Purpose:    Update Address fields of DMRequest on Address type pickilist of DM request 
    Author:     Sushma Bharti
    Date:       25/10/2017
*/
public class TriggerDMRequestTriggerHandlerMY 
    implements TriggerHandlerIf 
{
    string market = System.Label.MarketMY;
    DMRequestHelperMY dmobj=new DMRequestHelperMY();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            if(Trigger.isBefore && Trigger.isInsert)
            {
                dmobj.InsertDMRequest(trigger.new,isInsert,market);         
            }
            
            if (Trigger.isBefore && Trigger.isUpdate)
            { 
                dmobj.UpdateDMRequest(trigger.new,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
            }
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      List<DM_Request__c> dmrequestNewList=trigger.new;
      if(dmrequestNewList[0].MD__c==Label.MY){
          if(Trigger.isBefore && Trigger.isInsert)
          {
            dmobj.InsertDMRequest(dmrequestNewList,isInsert,market);
          }
          
          if (Trigger.isBefore && Trigger.isUpdate)
          { 
            dmobj.UpdateDMRequest(dmrequestNewList,(Map<ID,DM_Request__c>)trigger.oldMap,isUpdate,market);                        
          }
      }
    }
}