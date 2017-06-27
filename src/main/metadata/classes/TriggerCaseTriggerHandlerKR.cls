public class TriggerCaseTriggerHandlerKR implements TriggerHandlerIf
{
    public static boolean isFutureUpdate = false;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperJP caseHelperJP = new CaseHelperJP();
        if(trigger.isBefore && trigger.isInsert)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isInsert');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            caseHelperJP.updateCaseDeadline(trigger.new);
            caseHelperJP.updateCaseDealer(Trigger.New,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            
        }
        if(trigger.isBefore && trigger.isUpdate && isFutureUpdate != true)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isUpdate');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            //caseHelperJP.calculateComplaintAmount(trigger.new,trigger.oldMap);
            caseHelperJP.updateCaseDealer(Trigger.New,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            //caseHelperJP.updateCaseDeadline(trigger.new,trigger.oldMap);
            
        }
        
        if(trigger.isAfter)
        {
            if (trigger.isInsert)
            {
                CaseHelper.caseafterInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
                caseHelperJP.calculateComplaintAmount(trigger.new);
                caseHelperJP.updateGateKeaperforApprovedProcess(trigger.new,(Map<Id,Case>)trigger.oldMap,'isInsert');
                caseHelperKR.updateCaseDeadLine(trigger.new,(Map<Id,Case>)trigger.oldMap,'isInsert');
            }
            if (trigger.isUpdate)
            {
                caseHelperJP.calculateComplaintAmount(trigger.new);
                caseHelperJP.updateGateKeaperforApprovedProcess(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
                caseHelperKR.updateCaseDeadLine(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
            }
            if (trigger.isDelete)
            {               
                caseHelperJP.calculateComplaintAmount(trigger.old);
            }
        }
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}