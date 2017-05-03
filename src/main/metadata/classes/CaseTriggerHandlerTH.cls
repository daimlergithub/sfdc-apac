public class CaseTriggerHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    
   
        system.debug('Entered handler...JP handler');
        system.debug('Trigger IsDelete...' +trigger.isDelete);
        CaseHelperTH caseHelperTHd = new CaseHelperTH();
        if(trigger.isbefore){
            if(trigger.isupdate){
            caseHelperTHd.updateCase(trigger.new);
            }if(trigger.isinsert){
             caseHelperTHd.countRepeatComplaintCase(trigger.new,true);
             }
        }
         if (trigger.isAfter){
            if (trigger.isDelete){
               system.debug('Entered delete condition...');
               caseHelperTHd .calculateComplaintAmount(trigger.old);
            }else if (trigger.isInsert){
            system.debug('afterinsertdhanu');
               caseHelperTHd .calculateComplaintAmount(trigger.new); 
             
            }else if (trigger.isUpdate){
             system.debug('afterinsertdhanu1');
            
               caseHelperTHd.calculateComplaintAmount(trigger.new);
                 
            }
           
        }
           
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}