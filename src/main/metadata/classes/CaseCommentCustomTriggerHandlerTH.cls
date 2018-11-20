public class CaseCommentCustomTriggerHandlerTH implements TriggerHandlerIf{
	public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){
        if(trigger.Isafter)
        {
            if((trigger.IsInsert || trigger.IsUpdate) && CaseCommentCustomController.IsTriggerRunRequired)
            {
                CaseCommentCustomHelperTH.SendCaseCommentsToCOS(trigger.newMap);  
                CaseCommentCustomHelperTH.updateFeedbackDate(trigger.new);
            }
        }   
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<Case_Comment__c> newCaseCommentLst=trigger.new;
        List<Case> fsCaseLst=new List<Case>();
        Set<Id> fsCaseIdTHSet=new Set<Id>();
        List<Id>caseCommentIdLst=new List<Id>();
        List<Case_Comment__c> caseCommentLst=new List<Case_Comment__c>();
        Map<Id,Case_Comment__c> caseId2CaseCommentMap=new Map<Id,Case_Comment__c>();
        List<Id> caseIdLst=new List<Id>();
        if(newCaseCommentLst!=null)
        {
            for(Case_Comment__c caseCommentObj:newCaseCommentLst)
            {
                if(caseCommentObj!=null)
                {
                    caseIdLst.add(caseCommentObj.Case__c);
                    caseCommentLst.add(caseCommentObj);
                    //Insert only 1st case comment for a single case in caseId2CaseComment Map
                    if(!caseId2CaseCommentMap.containsKey(caseCommentObj.Case__c))
                        caseId2CaseCommentMap.put(caseCommentObj.Case__c, caseCommentObj);
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
                        //fsCaseIdTHSet.add(caseObj.Id);
                    }
                        
                }
            }
               if(fsCaseLst!=null && fsCaseLst.size()>0 && caseId2CaseCommentMap.size()>0)
                {
                    if(isAfter && isInsert)
                    	CaseCommentCustomHelperTH.updateCustomerStatementField(fsCaseLst,caseId2CaseCommentMap);
                    
                }
                //Change the UTC CustomerRespomseDate DateTime coming to BKK time.
                /*if(fsCaseIdTHSet!=null && fsCaseIdTHSet.size()>0 && caseCommentLst!=null && caseCommentLst.size()>0)
                {
                    CaseCommentHelperTH.ChangeUTCtimeToBKKtime(caseCommentLst,fsCaseIdTHSet);
                }*/
            
        }
    }
}