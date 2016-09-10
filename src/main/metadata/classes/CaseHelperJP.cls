public with sharing class CaseHelperJP {
    
    public Id caseInquiryRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
        
    public void calculateComplaintAmount(List<Case> cases, Map<Id,SObject> case_Map){
        system.debug('Trigger Old Map...' +case_Map);
        Set<Id> accounts = new Set<Id>();
        Map<Id, List<Integer>> acc_Count = new Map<Id, List<Integer>>();
        for (Case c : cases){
            if (c.MD__c == 'JP' || c.MD__c == 'KR'){
                Case caseRec = (Case)case_Map.get(c.Id);
                if (c.AccountId != caseRec.AccountId){
                    List<Integer> count = acc_Count.get(caseRec.AccountId);
                    if (count == null){
                        acc_Count.put(caseRec.AccountId, new List<Integer>{1});
                    }else{
                        count[0]++;
                    }
                    accounts.add(caseRec.AccountId);               
                }
             }
        }
        
        System.debug('Count of the Accounts changed...' +acc_Count);
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                      Where AccountId IN :accounts AND RecordTypeId =:caseInquiryRec_Id 
                                      AND Case_Class__c = 'Complaint'];           
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
        List<Account> accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts];
        for (Account acc : accRecords){
           List<Id> caseIds = accountCaseMap.get(acc.Id);
           List<Integer> caseCount = acc_Count.get(acc.Id);
           acc.Complaint_Amount__c = caseIds.size()-caseCount[0];
           updateAccount.add(acc);
        }
        system.debug('Accounts to be updated...' +updateAccount);
        update updateAccount;
    }
    
    public void calculateComplaintAmount(List<Case> cases){
        system.debug('Incoming Cases...' +cases);
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__c == 'JP' || c.MD__c == 'KR'){
                accounts.add (c.AccountId);
            } 
        }                       
        system.debug('Accounts...' +accounts);
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                          Where AccountId IN :accounts AND RecordTypeId =:caseInquiryRec_Id 
                                          AND Case_Class__c = 'Complaint'];                                  
        
        system.debug('Case_acc...' +case_acc);
        if (case_acc != null && !case_acc.isEmpty()){                                         
            for(Case c : case_acc){
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null){
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }else{
                    tmpCaseIds.add(c.Id);
                }
            }
            
            system.debug('accountCaseMap...' +accountCaseMap);
            accounts = new Set<Id>();
            accounts = accountCaseMap.keySet();
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts];
            for (Account acc : accRecords){
               List<Id> caseIds = accountCaseMap.get(acc.Id);
               acc.Complaint_Amount__c = caseIds.size();
               updateAccount.add(acc);
            }
            system.debug('Accounts to be updated...' +updateAccount);
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
    
    public void updateCaseDeadline(List<Case> cases){
        CaseDeadelineCalc__mdt caseDeadline;
        Date todayDate = Date.today();
        Integer days;
        Schema.DescribeSobjectResult results = CaseDeadelineCalc__mdt.getSObjectType().getDescribe();
        system.debug('Custom metadata :' +results.fields.getMap());
        
        Set<String> fields = results.fields.getMap().keySet();
        String fieldsToQuery = '';

        Integer i = 0;
        for (String f : fields){
            system.debug('map values...' +results.fields.getMap().get(f));
            if (i > 0){
                fieldsToQuery = String.ValueOf(fieldsToQuery+ ' ,'+results.fields.getMap().get(f));
                system.debug('fieldsToQuery...1' +fieldsToQuery); 
            }
            else{
                fieldsToQuery = String.ValueOf(results.fields.getMap().get(f));
                system.debug('fieldsToQuery...2' +fieldsToQuery); 
            }
            i++;
            system.debug('fieldsToQuery...3' +fieldsToQuery);  
        }
        
        String queryString = 'Select ' + fieldsToQuery + ' FROM CaseDeadelineCalc__mdt WHERE QualifiedApiName ='  +'\'Japan_Case_Deadlines\'';
        system.debug('Final query string..' +queryString);
        caseDeadline = Database.query(queryString);
        system.debug('Case deadline values...' +caseDeadline);
        
        for (Case c : cases){
            if (c.Case_Class__c == 'Others' && c.MD__c == 'JP' && c.RecordTypeId == caseInquiryRec_Id){
                if(c.Priority == 'A'){
                    system.debug('Case Deadlines...' +caseDeadline);
                    days = (Integer)caseDeadline.CaseDeadelineCalc1__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc2__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc3__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc4__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc5__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Complaint' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc6__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc7__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc8__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc9__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc10__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Claim' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc11__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc12__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc13__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc14__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc15__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Inquiry' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc16__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc17__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc18__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc19__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc20__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Request' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc21__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc22__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc23__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc24__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc25__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Touring Support' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc26__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc27__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc28__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc29__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc30__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Finance' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc31__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc32__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc33__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc34__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc35__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
          if ((c.Priority == 'A' || c.Priority == 'Red >= 4') && c.MD__c == 'KR'){
               c.DeadLine__c=System.Now() + 1;         
            }
          if ((c.Priority == 'B' || c.Priority == 'Yellow = 3') && c.MD__c == 'KR'){
              c.DeadLine__c= System.Now() + 3;
           }
          if ((c.Priority == 'C' || c.Priority == 'Green <= 2') && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 10;          
           }  
        }        
    }
   public void updateCaseDeadline(List<Case> cases, Map<Id,SObject> case_Map){     
         for (Case c : cases){ 
               Case caseRec = (Case)case_Map.get(c.Id);
            if ((c.Priority == 'A' || c.Priority =='Red >= 4') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               
                c.DeadLine__c=System.Now() + 1;         
             }
           if ((c.Priority == 'B' || c.Priority =='Yellow = 3') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 3;
            }
           if ((c.Priority == 'C' || c.Priority =='Green <= 2') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 10;          
            } 
          }      
       }
 }