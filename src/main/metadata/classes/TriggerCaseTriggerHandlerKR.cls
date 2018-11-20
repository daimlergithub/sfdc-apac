public without sharing class TriggerCaseTriggerHandlerKR implements TriggerHandlerIf
{
    public static boolean isFutureUpdate = false;
    public static boolean recurssionCheckbefore = false;
    public static boolean recurssionCheckafter = false;
    public static boolean recurssioncheckafterownerupdate = false;
    public static boolean recurssioncheckaftersendmail = false;
    public static integer countchecksendmail=0;
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
            map<string,string> caseOwnerIds = new map<string,String>();
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
                
                //MBK Message Send Manage 6/26/2018
                Map<Id,Case> dummap = new Map<Id,Case>();
                caseHelperKR.MessageSendManage((List<Case>)trigger.new, dummap,'Insert');                
            }
            if (trigger.isUpdate)
            {
                caseHelperJPinit.calculateComplaintAmount(trigger.new);
                caseHelperJPinit.updateGateKeaperforApprovedProcess(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
                caseHelperKR.updateCaseDeadLine(trigger.new,(Map<Id,Case>)trigger.oldMap,'isUpdate');
                if(recurssioncheckafterownerupdate != true){
                    caseHelperJP.assignCasestoqueues(Trigger.New,(Map<Id,Case>)trigger.oldMap, 'update');
                }
                for(Case cas: (List<Case>)trigger.new)
                {
                    for(Case casold: (List<Case>)trigger.old){
                    if(cas.OwnerId!=casold.OwnerId)
                    caseOwnerIds.put(cas.Id,cas.OwnerId);
                    countchecksendmail++;
                    }     
                } 
                if(!System.isFuture() && recurssioncheckaftersendmail!=true && countchecksendmail==1){
                  system.debug('*$*Call EMail Notification method3 *$*'+caseOwnerIds);
                  caseHelperKR.sendEmailToQueue(caseOwnerIds);                                 
                 }
                 caseHelperKR.casesharehierarchy(trigger.new);  
                 
                //MBK Message Send Manage 6/26/2018
                caseHelperKR.MessageSendManage((List<Case>)trigger.new, (Map<Id,Case>)trigger.oldMap, 'Update');                 
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