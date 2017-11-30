/**
* Handler class for Trigger on Task 
* Author: Sushma
* Created Date : 2017-11-21
*/

public class TriggerTaskHandler implements TriggerHandlerIf {

    List<Task> taskNewList=Trigger.new;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
    
        if(trigger.isInsert || trigger.isUpdate){
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){         
              TriggerTaskHelper.TaskFailBlacklist(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);
            }         
         }
        if(trigger.isAfter && trigger.isInsert)
        {     
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){     
              TriggerTaskHelper.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
            }
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {           
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
              TriggerTaskHelper.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);   
            }                 
        }
        if(trigger.isBefore && trigger.isInsert)
        {
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                TriggerTaskHelper.updateAccountMobile(taskNewList);
            }           
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
                TriggerTaskHelper.updateAccountMobile(taskNewList);    
            }          
        }
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to be added as required in market.
       if(taskNewList[0].MD__c==Label.MY){
        if(trigger.isInsert || trigger.isUpdate){         
              TriggerTaskHelper.TaskFailBlacklist(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);       
         }
        if(trigger.isAfter && trigger.isInsert)
        {           
              TriggerTaskHelper.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {            
              TriggerTaskHelper.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);                   
        }
         if(trigger.isBefore && trigger.isInsert)
        {
            TriggerTaskHelper.updateAccountMobile(taskNewList);            
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            TriggerTaskHelper.updateAccountMobile(taskNewList);             
        }
      }
    }
}