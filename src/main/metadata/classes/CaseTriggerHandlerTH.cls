/**
* Handler for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 23-Apr-2017
*/

public class CaseTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperTH caseHelperTHd = new CaseHelperTH();
        
        if(trigger.isinsert && trigger.isbefore)
            caseHelperTHd.countRepeatComplaintCase(trigger.new,true);
            
         if (trigger.isAfter){
            if (trigger.isDelete){
               caseHelperTHd .calculateComplaintAmount(trigger.old);
            }
            else if (trigger.isInsert){
               caseHelperTHd .calculateComplaintAmount(trigger.new); 
             
            }else if (trigger.isUpdate){
               caseHelperTHd.calculateComplaintAmount(trigger.new);
                 
            }
           
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}