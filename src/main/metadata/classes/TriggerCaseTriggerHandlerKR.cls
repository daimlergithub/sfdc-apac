public without sharing class TriggerCaseTriggerHandlerKR implements TriggerHandlerIf
{
    public static boolean isFutureUpdate = false;
	public static boolean recurssionCheckbefore = false;
    public static boolean recurssionCheckafter = false;
	public static boolean recurssioncheckafterownerupdate = false;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        CaseHelperJP caseHelperJPinit = new CaseHelperJP();
        if(trigger.isBefore && trigger.isInsert)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isInsert');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            caseHelperJPinit.updateCaseDeadline(trigger.new);
            caseHelperJPinit.updateCaseDealer(Trigger.New,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            
        }
        if(trigger.isBefore && trigger.isUpdate && isFutureUpdate != true)
        {
            System.debug('#########################################-->trigger.isBefore && trigger.isUpdate');
            CaseHelper.caseBeforeInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
            //caseHelperJPinit.calculateComplaintAmount(trigger.new,trigger.oldMap);
             if(recurssionCheckbefore != true){    
                caseHelperJPinit.updateCaseDealer(Trigger.New,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
             }
            //caseHelperJPinit.updateCaseDeadline(trigger.new,trigger.oldMap);
            
        }
        //caseHelperKR.roleRestrictionForCCC(Trigger.New,(Map<Id,Case>)trigger.oldMap,isUpdate,isDelete);
        if(trigger.isAfter)
        {
            if (trigger.isInsert)
            {
                CaseHelper.caseafterInsertUpdateEvents(Trigger.new,isInsert,isUpdate,(Map<Id,Case>)trigger.oldMap);
                if(recurssionCheckafter != true){
                    caseHelperJPinit.calculateComplaintAmount(trigger.new);
                }
				if(recurssioncheckafterownerupdate != true){
                    caseHelperJP.assignCasestoqueues(Trigger.New,(Map<Id,Case>)trigger.oldMap, 'insert');
                }
                caseHelperJPinit.updateGateKeaperforApprovedProcess(trigger.new,(Map<Id,Case>)trigger.oldMap,'isInsert');
                caseHelperKR.updateCaseDeadLine(trigger.new,(Map<Id,Case>)trigger.oldMap,'isInsert');
				caseHelperKR.casesharehierarchy(trigger.new);
				//caseHelperKR.sendEmailToQueue(trigger.new,'isInsert');
            }
            if (trigger.isUpdate)
            {
                caseHelperJPinit.calculateComplaintAmount(trigger.new);
                caseHelperJPinit.updateGateKeaperforApprovedProcess(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
                caseHelperKR.updateCaseDeadLine(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
				if(recurssioncheckafterownerupdate != true){
                    caseHelperJP.assignCasestoqueues(Trigger.New,(Map<Id,Case>)trigger.oldMap, 'update');
                }
				caseHelperKR.casesharehierarchy(trigger.new);
				//caseHelperKR.sendEmailToQueue(trigger.new,'isUpdate');
            }
            if (trigger.isDelete)
            {               
                caseHelperJPinit.calculateComplaintAmount(trigger.old);
            }
        }
        // Implementation to addedd as required in market
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        // Implementation to addedd as required in market
    }
}
