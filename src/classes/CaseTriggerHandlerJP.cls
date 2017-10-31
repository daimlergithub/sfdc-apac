public class CaseTriggerHandlerJP
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
            if(Trigger.isBefore && Trigger.isupdate)
        {
           CaseHelperJP.caseOwner(Trigger.New, (Map<Id,Case>) Trigger.OldMap);
            
        }
    
     if (trigger.isAfter)
    {
    if (trigger.isInsert){
    System.debug('$$$$$$@@@@'+trigger.new);
    caseHelperJP.shareCaseWithDealers(trigger.new);
     caseHelperJP.SendEmailToNotifyDealer(trigger.new,(Map<Id,Case>)Trigger.OldMap);
    }
    if (trigger.isUpdate){
    System.debug('$$$$$$@@@@'+trigger.new);
    caseHelperJP.shareCaseWithDealers(trigger.new);
     caseHelperJP.SendEmailToNotifyDealer(trigger.new,(Map<Id,Case>)Trigger.OldMap);
    }
    } 
        system.debug('Entered handler...JP handler');
        system.debug('Trigger IsDelete...' +trigger.isDelete);
        CaseHelperJP caseHelperJPd = new CaseHelperJP();
        if (trigger.isBefore){  
            if (trigger.isInsert)
                //caseHelperJPd.updateCaseDeadline(trigger.new); commented changes related to SFDCJP-2329
            if (trigger.isUpdate){
                caseHelperJPd.calculateComplaintAmount(trigger.new,trigger.oldMap);
                //caseHelperJPd.updateCaseDeadline(trigger.new,trigger.oldMap); commented changes related to SFDCJP-2329
                   
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
        
        }
        
        if (trigger.isAfter){
            if (trigger.isInsert||trigger.isUpdate){ 
              // caseHelperJP.countchildcase(trigger.new,trigger.old);  commented changes related to SFDCJP-2329
            }
        }
        if(trigger.isBefore){
            if(trigger.isDelete){
                
            //  caseHelperJP.countchildcase(trigger.new,trigger.old);     commented changes related to SFDCJP-2329
                
            }
        }    
		
		if (trigger.isbefore)
        {
          if (trigger.isInsert)
          {
          caseHelperJP.UpdatePrimarycasedealer(trigger.new); 
          }
        }  
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
	  CaseHelperJP caseHelperJPd = new CaseHelperJP();
	  
	  if (trigger.isBefore)
		{
		if (trigger.isUpdate){
                caseHelperJPd.calculateComplaintAmount(trigger.new,trigger.oldMap);
		}		
		}	
		
	   if (trigger.isAfter){
            if (trigger.isDelete){
               system.debug('Entered delete condition...');
               caseHelperJPd.calculateComplaintAmount(trigger.old);
            }else if (trigger.isInsert){
               caseHelperJPd.calculateComplaintAmount(trigger.new); 
            }else if (trigger.isUpdate){
            caseHelperJPd.updateCase(trigger.new);
               caseHelperJPd.calculateComplaintAmount(trigger.new);
                 
            }
        
        }
			
		
    }
    
}