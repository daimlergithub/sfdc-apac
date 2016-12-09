public class CaseTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
	
	 if (trigger.isAfter)
    {
    if (trigger.isInsert){
    System.debug('$$$$$$@@@@'+trigger.new);
    caseHelperJP.shareCaseWithDealers(trigger.new);
    }
    if (trigger.isUpdate){
    System.debug('('$$$$$$@@@@'+'+trigger.new);
    caseHelperJP.shareCaseWithDealers(trigger.new);
    }
    } 
        system.debug('Entered handler...JP handler');
        system.debug('Trigger IsDelete...' +trigger.isDelete);
        CaseHelperJP caseHelperJP = new CaseHelperJP();
        if (trigger.isBefore){  
            if (trigger.isInsert)
                caseHelperJP.updateCaseDeadline(trigger.new);
            if (trigger.isUpdate){
                caseHelperJP.calculateComplaintAmount(trigger.new,trigger.oldMap);
                caseHelperJP.updateCaseDeadline(trigger.new,trigger.oldMap); 
                   
                }      
        }else if (trigger.isAfter){
            if (trigger.isDelete){
               system.debug('Entered delete condition...');
               caseHelperJP.calculateComplaintAmount(trigger.old);
            }else if (trigger.isInsert){
               caseHelperJP.calculateComplaintAmount(trigger.new); 
            }else if (trigger.isUpdate){
            caseHelperJP.updateCase(trigger.new);
               caseHelperJP.calculateComplaintAmount(trigger.new);
                 
            }
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}