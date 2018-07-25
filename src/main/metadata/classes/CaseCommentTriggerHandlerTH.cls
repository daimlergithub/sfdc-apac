public class CaseCommentTriggerHandlerTH implements TriggerHandlerIf {
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        if(trigger.Isafter)
        {
            if(trigger.IsInsert || trigger.IsUpdate)
            {
                CaseCommentHelperTH.SendCaseCommentsToCOS(trigger.newMap);
                CaseCommentHelperTH.updateFeedbackDate(trigger.new);
            }
                
            
        }
        
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<CaseComment> newCaseCommentLst=trigger.new;
        List<Case> fsCaseLst=new List<Case>();
        Set<Id> fsCaseIdTHSet=new Set<Id>();
        List<Id>caseCommentIdLst=new List<Id>();
        List<CaseComment> caseCommentLst=new List<CaseComment>();
        Map<Id,CaseComment> caseId2CaseCommentMap=new Map<Id,CaseComment>();
        List<Id> caseIdLst=new List<Id>();
        if(newCaseCommentLst!=null)
        {
            for(CaseComment caseCommentObj:newCaseCommentLst)
            {
                if(caseCommentObj!=null)
                {
                    caseIdLst.add(caseCommentObj.ParentId);
                    caseCommentLst.add(caseCommentObj);
                    //Insert only 1st case comment for a single case in caseId2CaseComment Map
                    if(!caseId2CaseCommentMap.containsKey(caseCommentObj.ParentId))
                        caseId2CaseCommentMap.put(caseCommentObj.ParentId, caseCommentObj);
                }
            }
            if(caseIdLst!=null && caseIdLst.size()>0)
            {
                List<Case> caseLst=[select id,COS_Ticket_Number__c,Customer_Statement__c,market__c from case where Id IN:caseIdLst];
                for(Case caseObj:caseLst)
                {
                    if(caseObj.Market__c=='TH'&& caseObj.COS_Ticket_Number__c!=null && !string.isBlank(caseObj.COS_Ticket_Number__c))
                    {
                        fsCaseLst.add(caseObj);
                        fsCaseIdTHSet.add(caseObj.Id);
                    }
                        
                }
            }
            
           
            
                if(fsCaseLst!=null && fsCaseLst.size()>0 && caseId2CaseCommentMap.size()>0)
                {
                    if(isAfter && isInsert)
                    	CaseCommentHelperTH.updateDescription1Field(fsCaseLst,caseId2CaseCommentMap);
                    
                }
                //Change the UTC CustomerRespomseDate DateTime coming to BKK time.
                if(fsCaseIdTHSet!=null && fsCaseIdTHSet.size()>0 && caseCommentLst!=null && caseCommentLst.size()>0)
                {
                    CaseCommentHelperTH.ChangeUTCtimeToBKKtime(caseCommentLst,fsCaseIdTHSet);
                }
            
        }
    }
}