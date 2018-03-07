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
                        caseCommentIdLst.add(caseCommentIdCaseIdMap.get(caseObj.Id));
                }
            }
            
        }
          if(caseCommentIdLst.size()>0)
            CDMInformatica_Services.sendCaseCommentDetailsToCOS(caseCommentIdLst, 'TH', 'Case');
    }
}