public class CaseCommentCustomHelperTH {
	//This method will send only those case comments records whose parent case's COS ticket number is not null. 
    public static void SendCaseCommentsToCOS(Map<Id,sObject> newCaseCommentMap)
    {
        List<Id> caseCommentIdLst=new List<Id>();
        Map<Id,Id> caseCommentIdCaseIdMap=new Map<Id,Id>();
        if(newCaseCommentMap!=null && newCaseCommentMap.size()>0)
        {
            for(Id caseCommentId:newCaseCommentMap.keySet())
            {
                Case_Comment__c caseCommentObj=(Case_Comment__c)newCaseCommentMap.get(caseCommentId);
                if(caseCommentObj.Case__c!=null)
                   caseCommentIdCaseIdMap.put(caseCommentId,caseCommentObj.Case__c);
            }
        }
        List<Case> caseLst;
        if(caseCommentIdCaseIdMap!=null && caseCommentIdCaseIdMap.size()>0)
        {
           caseLst=[Select Id from Case where Id IN:caseCommentIdCaseIdMap.values() and COS_Ticket_Number__c!=null]; 
        }
        if(caseLst!=null && caseLst.size()>0)
        {
            for(Id caseCommentId:newCaseCommentMap.keySet())
            {
                for(Case caseObj:caseLst)
                {
                    if(caseCommentIdCaseIdMap.get(caseCommentId)==caseObj.Id)
                        caseCommentIdLst.add(caseCommentId);
                }
            }
            
        }
          if(caseCommentIdLst.size()>0)
          {
              System.debug('caseCommentIdLst-----'+caseCommentIdLst);
              CDMInformatica_Services.sendCaseCommentDetailsToCOS(caseCommentIdLst, 'TH', 'Update');
          }
            
    }
    
    //copy 1st response or comment from COS into Description1 field
    public static void updateCustomerStatementField(List<Case> caseLst,Map<Id,Case_Comment__c> caseId2CaseComment)
    {
        List<Case> caseToUpdateLst=new List<Case>();
        for(Case caseObj:caseLst)
        {
            if((caseObj.Customer_Statement__c==null || String.isBlank(caseObj.Customer_Statement__c)) && caseId2CaseComment.get(caseObj.Id)!=null)
            {
                caseObj.Customer_Statement__c=caseId2CaseComment.get(caseObj.Id).Comment__c;
                caseToUpdateLst.add(caseObj);
            }
        }
        if(caseToUpdateLst!=null && caseToUpdateLst.size()>0)
        {
            update caseToUpdateLst;
        }
    }
    
    //Update feedback date from the latest case comment created date
    public static void updateFeedbackDate(List<Case_Comment__c> newCaseCommentLst)
    {
        Map<Id,Case_Comment__c> caseId2CaseCommentMap=new Map<Id,Case_Comment__c>();
        List<Id> caseIdLst=new List<Id>();
        List<Case> fsCaseLst=new List<Case>();
        for(Case_Comment__c caseCommentObj:newCaseCommentLst)
        {
            if(caseCommentObj!=null)
            {
                caseIdLst.add(caseCommentObj.Case__c);
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
                 }        
             }
         }
  		if(fsCaseLst!=null && fsCaseLst.size()>0 && caseId2CaseCommentMap.size()>0)
        {
            List<Case> caseToUpdateLst=new List<Case>();
            for(Case caseObj:fsCaseLst)
            {
                if(caseId2CaseCommentMap.get(caseObj.Id)!=null)
                {
                    caseObj.Feedback_DateTime__c=System.now();  
                    caseToUpdateLst.add(caseObj);
                }    
            }
            if(caseToUpdateLst.size()>0)
            	update caseToUpdateLst;
        }      
    }
}