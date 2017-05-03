/**
* Utility for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 5-april-2017
* this class will count the case complaint amount for thailand market if the record type is MB complaint 
*/

public class CaseHelperTH {
    
  
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
            
    public void calculateComplaintAmount(List<Case> cases){
      
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__C=='TH'){
                accounts.add (c.AccountId);
                system.debug('Accounts...' +c.accountid+'   '+c.md__c+'  '+c.case_class__c+'  '+c.recordtypeid);
            } 
        }                       
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                      Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id 
                                       and MD__c = 'TH')]; 
        if (case_acc != null && !case_acc.isEmpty()){                                         
            for(Case c : case_acc){
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null){
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }else{
                    tmpCaseIds.add(c.Id);
                }
            }
            
            accounts = new Set<Id>();
            accounts = accountCaseMap.keySet();
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts];
            for (Account acc : accRecords){
               List<Id> caseIds = accountCaseMap.get(acc.Id);
               acc.Complaint_Amount__c = caseIds.size();
               updateAccount.add(acc);
            }
          
        }else{
            Set<Id> accountIds = new Set<Id>();
            for (Id accId : accounts){
                accountIds.add(accId);
            }
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accountIds];
            for (Account acc : accRecords){
               acc.Complaint_Amount__c = 0;
               updateAccount.add(acc);
            } 
        }
        update updateAccount;                                                                                                                 
    }
    
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert) {
     for(Case caseNew : cases) {
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId&&caseNew.md__c=='TH'){
                    if (isInsert) {
                        if(caseNew.ParentId != null){
                            parentIds.add(caseNew.ParentId);
                        }
                        
                    }
                }
            }
        if (parentIds.size()>0){
                for(Case ca :[select Id, ParentId from Case where ParentId in :parentIds] ) {
                    if(!parentIdChildIds.containsKey(ca.ParentId)) {
                        parentIdChildIds.put(ca.ParentId, new List<Id>());
                    }
                    parentIdChildIds.get(ca.ParentId).add(ca.Id);
                }

                for(Case ca :[select Id, ParentId from Case where Id in :parentIds] ) {
                    if(ca.ParentId != null) {
                        parenthasParents.add(ca.Id);
                    }
                }
            }

                for(Case caseNew : cases) {
                
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.MD__c=='TH'){
            if(isInsert) {
                            caseNew.Repeat_Complaint_Times__c = 0;

             
                if (caseNew.ParentId != null){
                    if(parenthasParents.contains(caseNew.ParentId)) {
                        caseNew.addError(NOT_PRIMARY_REMINDER );
                    }
                    else
                    {
                        if(parentIdChildIds.containsKey(caseNew.ParentId)) {
                            caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 1;
                        }
                        else {
                            caseNew.Repeat_Complaint_Times__c = 1;
                        }
                       
                    }
                }
            }
        
        }
        }
    }
    public  void updateCase (List<case> caseSta) {

   
        
    }
   
      
      
   
 }