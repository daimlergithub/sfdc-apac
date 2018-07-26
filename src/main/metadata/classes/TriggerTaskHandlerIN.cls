/**
* Utility for Trigger on Task for IN(India)
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/

public class TriggerTaskHandlerIN implements TriggerHandlerIf {

    
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Task> taskNewList=Trigger.new;   
        if(trigger.isAfter && trigger.isInsert)
        {     
            if( Util_getPermissions.checkCustomPermission(Label.INGeneric)){   
              TriggerTaskHelperIN.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
            }
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {           
             if( Util_getPermissions.checkCustomPermission(Label.INGeneric)){
              TriggerTaskHelperIN.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);   
            }                 
        }        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       List<Task> taskNewList=Trigger.new;
        // Implementation to be added as required in market.
       if( !trigger.isdelete  && !taskNewList.isEmpty() && taskNewList.size() > 0 && taskNewList[0].MD__c==Label.IN){
        if(trigger.isAfter && trigger.isInsert)
        {           
              TriggerTaskHelperIN.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {            
              TriggerTaskHelperIN.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);                   
        }
      }
    }
}