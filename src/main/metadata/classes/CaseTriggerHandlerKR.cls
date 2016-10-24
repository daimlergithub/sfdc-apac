public class CaseTriggerHandlerKR
    implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        system.debug('Entered handler...KR handler');        
        caseHelperKR caseHelperKR = new caseHelperKR();
        if (trigger.isBefore){  
            if (trigger.isInsert){
                caseHelperKR.updateCaseDeadline(trigger.new);
            }            
        }
        if(trigger.isAfter && trigger.isInsert){
            caseHelperKR.sendEmailToSalesManager(trigger.new);        
        }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}