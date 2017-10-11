/**
* Utility for Trigger on Case to handle business logic
* Author:Honey
* Created Date : 26th Sep 2017
*/

public class CaseHelperBase {
    public Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY); // To get inquiry record type id
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT); // to get market record type id
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
    
    // This method is used to calculate deadline amount for complain case
    public void updateCaseDeadLineAmount(List<case> caselist, string market, Map<Id,Case> oldValcase){
        Case_Escalation_Matrix__mdt[] ceMatrix = [SELECT MasterLabel, DeveloperName, Escalation_Hours__c,Priority__c,Record_Type__c 
                                                    FROM Case_Escalation_Matrix__mdt];
        for(Case caserec:Caselist){
            for(Case_Escalation_Matrix__mdt cem : ceMatrix){
                //system.debug('inside for'+caserec.RecordTypeId+caserec.RecordTypeID+caserec.RecordType.DeveloperName+'=record type'+UtilRecordType.getRecordTypeIdByName('Case',cem.Record_Type__c)+'priorty'+caserec.priority+'---'+cem.Priority__C+'market'+caserec.md__c+'----'+cem.MasterLabel);
                if(caserec.RecordTypeID==UtilRecordType.getRecordTypeIdByName('Case',cem.Record_Type__c) && caserec.priority== cem.Priority__C && caserec.md__c==cem.MasterLabel){
                    if(oldValCase == NULL)
                        updatedeadine(caserec,Integer.ValueOf(cem.Escalation_Hours__c));
                    else if(caserec.priority !=oldValcase.get(caserec.id).priority)
                        updatedeadine(caserec,Integer.ValueOf(cem.Escalation_Hours__c));
                }
            }
        }                                            
    }
    //This method is used to return date to deadline amount method
    public void updatedeadine(case Caserec,Integer hours){
        
        if(hours < 24){
            caserec.deadline__c=System.now().addHours(hours);
        }
        else{
            Integer daystoadd=0;
            DateTime dt=System.now();
        
            Integer hourscount=0;
            While(hourscount<hours){
                string dayOfWeek = dt.format('E');
                system.debug('dayOfWeek'+dayOfWeek);
                if(dayOfWeek =='Sat'||dayOfWeek =='Sun'){
                    hourscount=hourscount+24;
                }
                else{
                    hourscount=hourscount+24;
                }
                dt=dt+1;
                daystoadd=daystoadd+1;
            }
        
                Datetime dow = System.now()+daystoadd;
                string dayOfWeek = dow.format('E');
                if(dayOfWeek =='Sat'){
                    caserec.deadline__c=System.now()+daystoadd+2;
                }
                else if(dayOfWeek =='Sun'){
                    caserec.deadline__c=System.now()+daystoadd+1;
                }
                else
                    caserec.deadline__c=System.now()+daystoadd;
        
        }
    }
    
    //Calculate total number of repeated MB complaints per account
    public void calculateComplaintAmount(List<Case> cases, string market){
      
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__C == market)
                accounts.add (c.AccountId);   
        }                       
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                              Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id and MD__c =: market) LIMIT 50000]; 
        if (case_acc != null && !case_acc.isEmpty()){                                         
            for(Case c : case_acc){
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null){
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }
                else{
                    tmpCaseIds.add(c.Id);
                }
            }
            
            accounts = new Set<Id>();
            accounts = accountCaseMap.keySet();
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts LIMIT 50000];
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
        DMLManagerService.updateAsSystem(updateAccount);                                                                                        
    }
    
    //Calculate the number of Repeated Case for an account 
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert, string market) {
        for(Case caseNew : cases) {
            if (isInsert){
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId && caseNew.md__c == market && caseNew.ParentId != null){    
                    parentIds.add(caseNew.ParentId);   
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
            if(isInsert) {
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.MD__c == market){
                    caseNew.Repeat_Complaint_Times__c = 0;

             
                    if (caseNew.ParentId != null){
                        if(parenthasParents.contains(caseNew.ParentId)) {
                            caseNew.addError(NOT_PRIMARY_REMINDER );
                        }
                        else
                        {   
                            if(parentIdChildIds.containsKey(caseNew.ParentId))
                                caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 1;
                            else
                                caseNew.Repeat_Complaint_Times__c = 1;
                        }
                    }
                }
        
            }
        }
    }
}