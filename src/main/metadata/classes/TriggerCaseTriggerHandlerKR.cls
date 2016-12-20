public class TriggerCaseTriggerHandlerKR implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperJP caseHelperJP = new CaseHelperJP();
        if(trigger.isBefore && trigger.isInsert)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isInsert');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            caseHelperJP.updateCaseDeadline(trigger.new);
            caseHelperJP.updateGateKeaperforApprovedProcess(trigger.new);
        }
        
        if(trigger.isBefore && trigger.isUpdate)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isUpdate');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            caseHelperJP.calculateComplaintAmount(trigger.new,trigger.oldMap);
            caseHelperJP.updateCaseDeadline(trigger.new,trigger.oldMap);
            caseHelperJP.updateGateKeaperforApprovedProcess(trigger.new);
        }
        if(trigger.isAfter){
             if (trigger.isDelete){               
               caseHelperJP.calculateComplaintAmount(trigger.old);
            } 
            if (trigger.isInsert){
               caseHelperJP.calculateComplaintAmount(trigger.new);
               caseHelperJP.sharerecord(trigger.new); 
            }
            if (trigger.isUpdate){
               caseHelperJP.calculateComplaintAmount(trigger.new);
               caseHelperJP.sharerecord(trigger.new);
            }
        }
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}