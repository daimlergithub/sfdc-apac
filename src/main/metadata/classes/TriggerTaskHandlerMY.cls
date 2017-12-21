/**
* Handler class for Trigger on Task 
* Author: Sushma
* Created Date : 2017-11-21
*/

public class TriggerTaskHandlerMY implements TriggerHandlerIf {

    List<Task> taskNewList=Trigger.new;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
            
        if(trigger.isAfter && trigger.isInsert)
        {     
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){     
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
            }
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {           
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);   
            }                 
        }        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to be added as required in market.
       if(taskNewList[0].MD__c==Label.MY){
        if(trigger.isAfter && trigger.isInsert)
        {           
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {            
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);                   
        }
      }
    }
}