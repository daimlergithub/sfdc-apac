/**
* Utility for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 5-april-2017
* this class will count the case complaint amount for thailand market if the record type is MB complaint 
*/

public class CaseHelperTH {
    Date myDate =date.newinstance(1900, 1, 7);
    public static boolean booleanCampaignUpdate=true;
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
    public void updateCaseOwnerDependsonPrimaryCaseDealer(List<Case> caselist,boolean isInsertFlag){
        set<Id> accset=new set<ID>();
        if(isInsertFlag){
        for(Case cas:caselist){
            if(cas.Case_Dealer__c!=null){
                accset.add(cas.Case_Dealer__c);
            }
        }

        }
        
        else{
            for(Case cas:caselist){
             if(((Case)trigger.newmap.get(cas.id)).ownerId!=((case)trigger.oldmap.get(cas.id)).ownerId){
               //c.ownerid=dealerndcode.get(c.Case_Dealer__c).Dealer_Lead_Gate_Keeper__c;
            }else if(cas.Case_Dealer__c!=null&&((Case)trigger.newmap.get(cas.id)).case_Dealer__c!=((case)trigger.oldmap.get(cas.id)).Case_Dealer__c){
                accset.add(cas.Case_Dealer__c);
            }
        }
       
    }
           Map<id,Account> dealerndcode=new Map<id,Account>([select id,Dealer_Lead_Gate_Keeper__c from Account where id IN:accset and Dealer_Lead_Gate_Keeper__c!=null]);
       if(dealerndcode.size()>0){
       for(Case c:caselist){
           if(c.Case_Dealer__c!=null){
               c.ownerid=dealerndcode.get(c.Case_Dealer__c).Dealer_Lead_Gate_Keeper__c;
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
    
        if(dayOfWeek =='Sat'||dayOfWeek =='Sun'){
            //hourscount=hourscount+24;
        }
        else{
        
        hourscount=hourscount+24;
        }
        dt=dt+1;
    daystoadd=daystoadd+1;
    }
    
    if(caserec.deadline__c==null){
    caserec.deadline__c=System.now()+daystoadd;
    }
    }
	
	//Update Case Creator field with the CreatedBy value
    public void updateCaseCreator(List<Case> lst_Cases){
        If(!lst_Cases.isEmpty() && lst_Cases != Null){
            for(Case newCase: lst_Cases){
                newCase.Case_Creator__c = UserInfo.getUserId();
            }
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
    
    //shareRecord
    public Static void ShareRecordswithDealers(List<Case> caselist,Boolean flag){
     Set<String> dealerndcodeset=new Set<String>();
     set<Case> lstcase=new set<Case>();
     set<caseShare> caseshare=new set<caseShare>();
     set<id> casesharingtorevoke=new set<id>();
     set<String> sharingrevokefromgroups=new set<String>();
     List<Case> caselisttoiterat=[select id,createdby.usertype,createdby.Dealer_nd_code__c,Case_Dealer__c,Case_Dealer__r.Dealer_nd_code__c,ownerId from Case where id IN : caselist];
        Set<id> idset=new Set<id>();
        for(Case c:caselisttoiterat){
            idset.add(c.ownerid);
        }
        Map<id,User> usr=new map<id,User>([select id,name,Dealer_nd_code__c,usertype from user where id  IN :idset]);
        //below if part will work at the time of insert
     for(Case casesrec:caselisttoiterat){
         if(!flag){
             
             //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
             if(casesrec.createdby.usertype=='PowerPartner'&& casesrec.createdby.Dealer_nd_code__c!=null){
                    dealerndcodeset.add(casesrec.createdby.Dealer_nd_code__c);
                    lstcase.add(casesrec);
             }
             else if(casesrec.Case_Dealer__c!=null && casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
                dealerndcodeset.add(casesrec.Case_Dealer__r.Dealer_nd_code__c);
                 lstcase.add(casesrec);
            }
        }
        else{
             
         //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
            //system.debug(((Case)trigger.oldmap.get(casesrec.id)).owner!=((Case)trigger.newmap.get(casesrec.id)).owner);
            system.debug(((Case)trigger.oldmap.get(casesrec.id)).ownerId+'  '+((Case)trigger.newmap.get(casesrec.id)).ownerId);
         if(((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=null  && ((Case)trigger.oldMap.get(casesrec.id)).Case_Dealer__c==null&&casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
             dealerndcodeset.add(casesrec.Case_Dealer__r.Dealer_nd_code__c);
             lstcase.add(casesrec);
         }
         //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
         else if(((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=null  && ((Case)trigger.oldMap.get(casesrec.id)).Case_Dealer__c!=null&&((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__c&&casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
            dealerndcodeset.add(casesrec.Case_Dealer__r.Dealer_nd_code__c);
            lstcase.add(casesrec);
          //will revoke record access depends on dealer nd code  if we change the assigned dealer
             if (((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c!=null){
                sharingrevokefromgroups.add(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                casesharingtorevoke.add(((Case)trigger.oldmap.get(casesrec.id)).id);
            }
         }
         //if trigger old value is filled and new value did not filled then revoke access from old Dealer
         else if(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__c!=null && ((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c==null){
             sharingrevokefromgroups.add(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
             casesharingtorevoke.add(((Case)trigger.oldmap.get(casesrec.id)).id);
         }
         else if(((Case)trigger.oldmap.get(casesrec.id)).ownerId!=((Case)trigger.newmap.get(casesrec.id)).ownerId){
             dealerndcodeset.add(usr.get(casesrec.ownerid).dealer_nd_code__c);
              lstcase.add(casesrec);
         }
     }
     }
     for(Group gp:[select id,name from Group where name IN :dealerndcodeset]){
        for(Case caseid:lstcase){
            //this if part will applicable for Salesforce users
            if(gp.name==caseid.Case_Dealer__r.Dealer_nd_code__c){
            caseshare.add(new caseShare(CaseId=caseid.id,UserOrGroupId=gp.id,RowCause=Schema.caseShare.Rowcause.manual,CaseAccessLevel='EDIT'));
            }//this else part will applicable for Dealer users
            else if(gp.name==caseid.createdby.Dealer_nd_code__c&&caseid.createdby.Usertype=='PowerPartner'){
                caseshare.add(new caseShare(CaseId=caseid.id,UserOrGroupId=gp.id,RowCause=Schema.caseShare.Rowcause.manual,CaseAccessLevel='EDIT'));
            }
         }
     }
     
     //else part will work at the time of Update
     
     if(caseshare.size()>0){
         List<caseShare> caseshareList=new List<caseShare>();
         caseshareList.addall(caseshare);
         Database.insert(caseshareList);
         if(casesharingtorevoke.size()>0){
             database.delete([select id from caseShare where Id IN :casesharingtorevoke and UserOrGroupId IN :sharingrevokefromgroups]);
         }
     }
     
 }
    //sharereocrd
}