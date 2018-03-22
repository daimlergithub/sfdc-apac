/**
* Handler for Trigger on Case for AU(Australia)
* Author:
* Created Date : 
*/

public class triggercaseHandlerAU implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperAU caseHelperBased = new CaseHelperAU();
        string market = System.Label.MarketAU;
        
        if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
        
            if(trigger.isinsert && trigger.isbefore){
            caseHelperBased.countRepeatComplaintCase(trigger.new,true,market);
            caseHelperBased.updateCaseDeadLineAmount(trigger.new,market,null);
            
           }
           else if(trigger.isupdate &&trigger.isbefore){
               caseHelperBased.updateCaseDeadLineAmount(trigger.new,market,(Map<Id,Case>)trigger.oldMap);
           
           }
          
         if (trigger.isAfter){
            if (trigger.isDelete){
               caseHelperBased.calculateComplaintAmount(trigger.old,market);
            }
            else if (trigger.isInsert){
               caseHelperBased.calculateComplaintAmount(trigger.new,market); 
             
            }else if (trigger.isUpdate){
               caseHelperBased.calculateComplaintAmount(trigger.new,market);
                 
            }
           
        }
       }     
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}