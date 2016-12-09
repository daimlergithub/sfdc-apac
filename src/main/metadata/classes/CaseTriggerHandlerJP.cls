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
    System.debug('$$$$$$@@@@'+trigger.new);
    caseHelperJP.shareCaseWithDealers(trigger.new);
    }
    } 
        system.debug('Entered handler...JP handler');
        system.debug('Trigger IsDelete...' +trigger.isDelete);
        CaseHelperJP caseHelperJPd = new CaseHelperJP();
        if (trigger.isBefore){  
            if (trigger.isInsert)
                caseHelperJPd.updateCaseDeadline(trigger.new);
            if (trigger.isUpdate){
                caseHelperJPd.calculateComplaintAmount(trigger.new,trigger.oldMap);
                caseHelperJPd.updateCaseDeadline(trigger.new,trigger.oldMap); 
                   
                }      
        }else if (trigger.isAfter){
            if (trigger.isDelete){
               system.debug('Entered delete condition...');
               caseHelperJPd.calculateComplaintAmount(trigger.old);
            }else if (trigger.isInsert){
               caseHelperJPd.calculateComplaintAmount(trigger.new); 
            }else if (trigger.isUpdate){
            caseHelperJPd.updateCase(trigger.new);
               caseHelperJPd.calculateComplaintAmount(trigger.new);
                 
            }
        
		
		
        if (trigger.isAfter){
            if (trigger.isInsert||trigger.isUpdate){
               caseHelperJPd.countchildcase(trigger.new); 
            }
        }
        if(trigger.isBefore){
            if(trigger.isDelete){
                
              caseHelperJPd.countchildcase(trigger.old);    
                
            }
        }    
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
    
}