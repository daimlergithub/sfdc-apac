/*Author: Tejbir (TH Team)
 *Description: This class is a helper class for case comment object. Initially designed for sending case comments record to COS through Informatica. 
 */
public class CaseCommentHelperTH {

    //This method will send only those case comments records whose parent case's COS ticket number is not null. 
    public static void SendCaseCommentsToCOS(Map<Id,sObject> newCaseCommentMap)
    {
        List<Id> caseCommentIdLst=new List<Id>();
        Map<Id,Id> caseCommentIdCaseIdMap=new Map<Id,Id>();
        if(newCaseCommentMap!=null && newCaseCommentMap.size()>0)
        {
            for(Id caseCommentId:newCaseCommentMap.keySet())
            {
                CaseComment caseCommentObj=(CaseComment)newCaseCommentMap.get(caseCommentId);
                if(caseCommentObj.ParentId!=null)
                   caseCommentIdCaseIdMap.put(caseCommentId,caseCommentObj.ParentId);
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
            CDMInformatica_Services.sendCaseCommentDetailsToCOS(caseCommentIdLst, 'TH', 'Update');
    }
    
    //copy 1st response or comment from COS into Description1 field
    public static void updateDescription1Field(List<Case> caseLst,Map<Id,CaseComment> caseId2CaseComment)
    {
        List<Case> caseToUpdateLst=new List<Case>();
        for(Case caseObj:caseLst)
        {
            if((caseObj.Customer_Statement__c==null || String.isBlank(caseObj.Customer_Statement__c)) && caseId2CaseComment.get(caseObj.Id)!=null)
            {
                caseObj.Customer_Statement__c=caseId2CaseComment.get(caseObj.Id).CommentBody;
                caseToUpdateLst.add(caseObj);
            }
        }
        if(caseToUpdateLst!=null && caseToUpdateLst.size()>0)
        {
            update caseToUpdateLst;
        }
    }
    
    //Update feedback date from the latest case comment created date
    public static void updateFeedbackDate(List<CaseComment> newCaseCommentLst)
    {
        Map<Id,CaseComment> caseId2CaseCommentMap=new Map<Id,CaseComment>();
        List<Id> caseIdLst=new List<Id>();
        List<Case> fsCaseLst=new List<Case>();
        for(CaseComment caseCommentObj:newCaseCommentLst)
        {
            if(caseCommentObj!=null)
            {
                caseIdLst.add(caseCommentObj.ParentId);
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
    
    public static void ChangeUTCtimeToBKKtime(List<CaseComment> caseCommentLst,Set<Id>fsTHcaseIdLst)
    {
        if(caseCommentLst!=null && caseCommentLst.size()>0)
        {
            for(CaseComment cmntObj:CaseCommentLst)
            {
                if(fsTHcaseIdLst.contains(cmntObj.ParentId))
                {
                    String commentBody=cmntObj.CommentBody;
                    List<String> customerResponseDate=commentBody.split('/n');
                    if(customerResponseDate!=null && customerResponseDate.size()==2)
                    {
                        DateTime utcDateTime=DateTime.valueOf(customerResponseDate[1]);
                        DateTime bkkDateTime=utcDateTime.addHours(7);
                        String bkkTimeFormat=bkkDateTime.format('dd-MM-yyyy HH:mm:ss');
                        commentBody=customerResponseDate[0]+bkkTimeFormat;
                        cmntObj.CommentBody=commentBody;
                    }
                    else If(customerResponseDate!=null && customerResponseDate.size()>2)
                    {
                        DateTime utcDateTime=DateTime.valueOf(customerResponseDate[1]);
                        DateTime bkkDateTime=utcDateTime.addHours(7);
                        String bkkTimeFormat=bkkDateTime.format('dd-MM-yyyy HH:mm:ss');
                        commentBody=customerResponseDate[0]+bkkTimeFormat+customerResponseDate[2];
                        cmntObj.CommentBody=commentBody;
                    }
                }
            }
            
        }
    }
}