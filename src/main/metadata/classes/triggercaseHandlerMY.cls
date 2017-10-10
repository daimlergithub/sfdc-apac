/**
* Handler for Trigger on Case for MY(Malaysia)
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class triggercaseHandlerMY implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperMY caseHelperBased = new CaseHelperMY();
        string market = System.Label.MarketMY;
        
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
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}