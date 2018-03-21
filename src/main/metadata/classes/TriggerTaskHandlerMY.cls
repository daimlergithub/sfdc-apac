/**
* Handler class for Trigger on Task 
* Author: Sushma
* Created Date : 2017-11-21
*/

public class TriggerTaskHandlerMY implements TriggerHandlerIf {

    
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        List<Task> taskNewList=Trigger.new;   
        if(trigger.isAfter && trigger.isInsert)
        {     
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){     
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate); 
               if(Util_GetPermissionList.checkAccessOnUser(Label.RSVP)){
              TriggerTaskHelperMY.NumberOfPax(trigger.new);    
              }       
            }
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {    
              
            if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
            
           
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate); 
              }
                // RSVP for Campaign Members- Asish Kumar Nanda
                
                
             //   if(Util_GetPermissionList.checkAccessOnUser(Label.RSVP)){
            
             //  TriggerTaskHelperMY.NumberOfPax(trigger.new);  
             // }
            }                 
        }        
    
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
       List<Task> taskNewList=Trigger.new;
        // Implementation to be added as required in market.
       if( !trigger.isdelete  && !taskNewList.isEmpty() && taskNewList.size() > 0 && taskNewList[0].MD__c==Label.MY){
        if(trigger.isAfter && trigger.isInsert)
        {           
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);            
        }         
        if(trigger.isAfter && trigger.isUpdate)
        {            // RSVP for Campaign Members- Asish Kumar Nanda
               TriggerTaskHelperMY.NumberOfPax(trigger.new); 
              TriggerTaskHelperMY.updateCampaignMemberStatus(taskNewList,(Map<Id,Task>)trigger.oldmap,trigger.isinsert,trigger.isupdate);                   
        }
      }
    }
}