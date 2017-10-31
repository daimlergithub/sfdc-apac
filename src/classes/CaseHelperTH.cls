/**
* Utility for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 5-april-2017
* this class will count the case complaint amount for thailand market if the record type is MB complaint 
*/

public class CaseHelperTH {
    Date myDate =date.newinstance(1900, 1, 7);
    public Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
    public void updateCaseDeadLineAmount(List<case> caselist){
        for(Case caserec:Caselist){
            Integer i=0;
            Boolean flag;
            if((caserec.RecordTypeId==caseINquiryId && caserec.priority=='A')||(caserec.RecordTypeId==caseMBComplaintRec_Id && caserec.priority=='Red >= 4')&& caserec.md__c=='TH'){
                 string dayOfWeek = System.now().format('E');
                     if(dayOfWeek == 'Sat'){
                            caserec.DeadLine__c=System.Now()+3;
                       }
                     else if(dayOfWeek == 'Sun'){
                        caserec.DeadLine__c=System.Now()+2;
                        }
                     else if(dayOfWeek == 'Fri'){
                        caserec.DeadLine__c=System.Now()+3;
                        }
                     else{
                        caserec.DeadLine__c=System.Now()+1;
                        }
            }
            else if((caserec.RecordTypeId==caseINquiryId && caserec.priority=='B')||(caserec.RecordTypeId==caseMBComplaintRec_Id && caserec.priority=='Yellow = 3')&& caserec.md__c=='TH'){
            updatedeadine(caserec,72);
            }
            else if(caserec.RecordTypeId==caseMBComplaintRec_Id && caserec.priority=='Green <= 2' && caserec.md__c=='TH'){
            updatedeadine(caserec,144);
            }
 
            else if(caserec.RecordTypeId==caseINquiryId && caserec.md__c=='TH'){
                if(caserec.priority=='C'){
                    updatedeadine(caserec,120);
                }
                else if(caserec.priority=='D'){
                    updatedeadine(caserec,240);
                }
                else if(caserec.priority=='E'){
                    updatedeadine(caserec,360);
                }
        }    
    }
    }
    public void updatedeadine(case Caserec,Integer hours){
    Integer daystoadd=0;
    DateTime dt=System.now();
    
    Integer hourscount=0;
    While(hourscount<hours){
    string dayOfWeek = dt.format('E');
    system.debug('day of the week'+dayofweek);
    
        if(dayOfWeek =='Sat'||dayOfWeek =='Sun'){
            //hourscount=hourscount+24;
            system.debug('****hrsif'+hourscount+'   '+dayofweek);
        }
        else{
        
        hourscount=hourscount+24;
        system.debug('****hrselse'+hourscount+'   '+dayofweek);
        }
        dt=dt+1;
    daystoadd=daystoadd+1;
    system.debug('******   '+dt+'  '+daystoadd+'  '+dayofweek+'    '+hourscount);
    }
    
    if(caserec.deadline__c==null){
    caserec.deadline__c=System.now()+daystoadd;
    }
    }
    //Calculate total number of repeated MB complaints per account
    public void calculateComplaintAmount(List<Case> cases){
      
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__C == System.Label.MarketTH)
                accounts.add (c.AccountId);   
        }                       
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                      Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id and MD__c =: System.Label.MarketTH) LIMIT 50000]; 
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
        update updateAccount;                                                                                                                 
    }
    
    //Calculate the number of Repeated Case for an account 
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert) {
        for(Case caseNew : cases) {
            if (isInsert){
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId && caseNew.md__c == System.Label.MarketTH && caseNew.ParentId != null){    
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
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.MD__c == System.Label.MarketTH){
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